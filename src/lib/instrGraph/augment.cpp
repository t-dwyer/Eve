

#include "llvm/ADT/SmallVector.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/Support/GraphWriter.h"
#include "llvm/Transforms/Utils/ModuleUtils.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"

#include <unordered_map>

#include "augment.h"
#include "instrGraph.h"
#include "blockSplit.h"

using namespace llvm;
using namespace augment;


char AugmentPass::ID = 0;
RegisterPass<AugmentPass> Z("Program Augmenter","Augments the code in a way to be data and signal focused");
static IRBuilder<> Builder(getGlobalContext());

bool D = false;

bool
AugmentPass::runOnModule(Module &module) {
  auto &context = module.getContext();
  auto *voidTy  = Type::getVoidTy(context);
  auto *int1Ty = Type::getInt1Ty(context);
  auto *int64Ty = Type::getInt64Ty(context);

  auto *voidFunTy = FunctionType::get(voidTy, false);
//  auto *intFunTy = FunctionType::get(int64Ty, false);

  std::vector<Value*> params;
  auto *helperTy = FunctionType::get(int1Ty, int64Ty, false);
  auto *sigTry  = module.getOrInsertFunction("Augment_sigTry", helperTy);  
  auto *sigGet  = module.getOrInsertFunction("Augment_sigGet", helperTy);  
  auto *sigDep  = module.getOrInsertFunction("Augment_sigDep", helperTy);  
  auto *sig  = module.getOrInsertFunction("Augment_sig", helperTy);  
  auto *sigPrime  = module.getOrInsertFunction("Augment_sigPrime", helperTy);  

  auto *init  = module.getOrInsertFunction("Augment_init", helperTy);  
  auto *printTrue  = module.getOrInsertFunction("Augment_printTrue", helperTy);
  auto *printFalse  = module.getOrInsertFunction("Augment_printFalse", helperTy);
  auto *doNOP  = module.getOrInsertFunction("Augment_doNOP", voidFunTy);

  BasicBlock *blockList[bbNode_map.size()];


  for (auto b : bbNode_map) {      
    blockList[b.second.name] = b.first;
  }

  for (auto b : bbNode_map) {
    BasicBlock *sigBlock = b.first;
    IRBuilder<> dbBuilder(&(*sigBlock).front());
    BasicBlock *nextSigBlock;

    if (b.second.name < bbNode_map.size() -1) {
      nextSigBlock = blockList[b.second.name+1];
    }    else {
      nextSigBlock = blockList[0];
    }

    //Split our current block into 3, signal, dependency, and data
    SplitBlockAndInsertIfThen(dbBuilder.getInt1(1),dyn_cast<Instruction>(&(*sigBlock).front()),false);
    BasicBlock *depBlock = (*(*sigBlock).getTerminator()).getSuccessor(0);
    BasicBlock *dataBlock = (*(*sigBlock).getTerminator()).getSuccessor(1);

    //Signal block
    b.second.sigBlock = sigBlock;
    dbBuilder.SetInsertPoint(&(*sigBlock).front());
    CallInst *sigCheck = dbBuilder.CreateCall(sigTry,dbBuilder.getInt64(b.second.name));
    Value *cmpVal = dbBuilder.CreateICmpEQ(sigCheck,dbBuilder.getInt1(1));
    BranchInst *sigBranch = dyn_cast<BranchInst>((*sigBlock).getTerminator());
    (*sigBranch).setSuccessor(0, depBlock);
    (*sigBranch).setSuccessor(1, nextSigBlock);
    (*sigBranch).setCondition(cmpVal);

    //Dependency block
    b.second.depBlock = depBlock;
    dbBuilder.SetInsertPoint(&(*depBlock).front());
    if (D) dbBuilder.CreateCall(printTrue,dbBuilder.getInt64(b.second.name));
    Value *depVal = dbBuilder.getTrue();
    bool dependencies = false;
    for (auto &p : b.second.parents) {
      for (auto &cEdge : p.second) {
        if (cEdge != "data") {
          CallInst *dep = dbBuilder.CreateCall(sigDep,dbBuilder.getInt64(bbNode_map[p.first].name));
          depVal = dbBuilder.CreateAnd(dyn_cast<Value>(dep),depVal);
          dependencies = true;
        }
      }
    }
    //Signal & dependencies met, actually signal (required to be atomic)
    CallInst *sigGetCall = dbBuilder.CreateCall(sigGet,dbBuilder.getInt64(b.second.name));
    depVal = dbBuilder.CreateAnd(dyn_cast<Value>(sigGetCall),depVal);
    Value *depCMPVal = dbBuilder.CreateICmpEQ(depVal,dbBuilder.getInt1(1));
    BranchInst *depBranch = dyn_cast<BranchInst>((*depBlock).getTerminator());
    BranchInst *newBranch = BranchInst::Create(dataBlock,nextSigBlock,depCMPVal);
    ReplaceInstWithInst(depBranch,newBranch);

 
    //Data block
    b.second.dataBlock = dataBlock;
    dbBuilder.SetInsertPoint(&(*dataBlock).front());
    if (D) dbBuilder.CreateCall(printFalse,dbBuilder.getInt64(b.second.name));

    //Add 'data block complete' signal to end of block (sigPrime)
    dbBuilder.CreateCall(sigPrime,dbBuilder.getInt64(b.second.name));

    //For unconditional data blocks (returns return, and conditional branchs make branch then signal accordingly)
    TerminatorInst *blockTerm = (*dataBlock).getTerminator();
    if ((*blockTerm).getNumSuccessors() == 1) { //Branch is unconditional
      //Add signals for child blocks (sig)
      for (auto &c : b.second.children) {
        for (auto &cEdge : c.second) {
          if (cEdge != "data") {
            dbBuilder.CreateCall(sig,dbBuilder.getInt64(bbNode_map[c.first].name));
          }
        }
      }
      //Set terminator to go to next signal block
      (*blockTerm).setSuccessor(0,nextSigBlock); 
    } else if ((*blockTerm).getNumSuccessors() == 2) { //Conditional branch      
      BranchInst *dataCond = dyn_cast<BranchInst>(blockTerm);
      TerminatorInst *dataTerm = SplitBlockAndInsertIfThen((*dataCond).getCondition(),dyn_cast<Instruction>(blockTerm),false);
      BasicBlock *dataTrueBlock = (*(*dataBlock).getTerminator()).getSuccessor(0);
      (*(*dataTrueBlock).getTerminator()).setSuccessor(0,nextSigBlock);
      BasicBlock *dataFalseBlock = (*(*dataBlock).getTerminator()).getSuccessor(1);
      BranchInst *dataFalseBranch = dyn_cast<BranchInst>((*dataFalseBlock).getTerminator());
      BranchInst *newDataBranch = BranchInst::Create(nextSigBlock);
      ReplaceInstWithInst(dataFalseBranch,newDataBranch);
      (*(*dataFalseBlock).getTerminator()).setSuccessor(0,nextSigBlock);
//      (*(*dataFalseBlock).getTerminator()).setSuccessor(1,nextSigBlock);

      for (auto &c : b.second.children) {
        for (auto &cEdge : c.second) {
          if (cEdge == "control" || cEdge == "control0") {
            dbBuilder.SetInsertPoint(&(*dataTrueBlock).front());
            dbBuilder.CreateCall(sig,dbBuilder.getInt64(bbNode_map[c.first].name));
          }
          else if (cEdge == "control1") {
            dbBuilder.SetInsertPoint(&(*dataFalseBlock).front());
            dbBuilder.CreateCall(sig,dbBuilder.getInt64(bbNode_map[c.first].name));
          }
        }
      }
    }
    bbNode_map[b.first] = b.second; //Update map

  } //End of bbNode_map loop

  for (auto &f : module) {
    if (f.getName() == "main") {
      BasicBlock *orig = ((*f.getEntryBlock().getTerminator()).getParent());
      BasicBlock *b = BasicBlock::Create(context,"entry",&f,&f.getEntryBlock());
      IRBuilder<> funBuilder(b);
      funBuilder.CreateCall(init,funBuilder.getInt64(bbNode_map.size()));
      // XxX Insert initialization instrumentation here XxX // 
      funBuilder.CreateBr(orig);
    }
  }


  /*
  BasicBlock *curBlock;
  for (auto &f : module) {
    if (f.isDeclaration()) continue;
  
    curBlock = &f.getEntryBlock();
    IRBuilder<> funBuilder(f.getEntryBlock().getFirstInsertionPt());
    
    //Split the first block on a dummy instruction (this worked better than SplitBlock)
    CallInst *initBreakPoint = funBuilder.CreateCall(doNOP,params);
    SplitBlockAndInsertIfThen(funBuilder.getInt1(1),dyn_cast<Instruction>(initBreakPoint),false);
    BasicBlock *trueTopBlock = (*(*curBlock).getTerminator()).getSuccessor(0);
    BasicBlock *falseTopBlock = (*(*curBlock).getTerminator()).getSuccessor(1);

    //True block - This will only execute on program initialization
    funBuilder.SetInsertPoint((*trueTopBlock).getTerminator());
    funBuilder.CreateCall(init,funBuilder.getInt64(bbNode_map.size()));

    //Add signals for child blocks (sig)
    for (auto &c : bbNode_map[curBlock].children) {
      for (auto &cEdge : c.second) {
        if (cEdge != "data") {
          funBuilder.CreateCall(sig,funBuilder.getInt64(bbNode_map[c.first].name));
        }
      }
    }
    // XxX Insert extra initialization initialization here XxX //

    //False block - This will execute on every loop
    funBuilder.SetInsertPoint((*falseTopBlock).getTerminator());
    BasicBlock *topBlock = falseTopBlock;
    curBlock = falseTopBlock;
      
        

    //Set up START/UNLOCK messages (main loop, and try lock checks)
    for (auto &b : bbNode_map) {
      Instruction *insertPoint = (*b.first).getTerminator();
      if (insertPoint != NULL) {
        
        //Create try for signal, branch upon signal result
        CallInst *sigCheck = funBuilder.CreateCall(sigTry,funBuilder.getInt64(b.second.name));
        Value *cmpVal = funBuilder.CreateICmpEQ(sigCheck,funBuilder.getInt1(1));
        SplitBlockAndInsertIfThen(cmpVal,(*curBlock).getTerminator(),false);
        BasicBlock *trueBlock = (*(*curBlock).getTerminator()).getSuccessor(0);        
        BasicBlock *falseBlock = (*(*curBlock).getTerminator()).getSuccessor(1);

        //True block - (signal locked), change successor to basic block that is correlated to the data block
        funBuilder.SetInsertPoint((*trueBlock).getTerminator());
        if (D) funBuilder.CreateCall(printTrue,funBuilder.getInt64(b.second.name));
        (*(*trueBlock).getTerminator()).setSuccessor(0,b.first); //Set the successor as our data block
     
        
        //Add dependency signals (wait for parents to complete)
        Value *depVal = funBuilder.getTrue();
        bool dependencies = false;
        for (auto &p : b.second.parents) {
          for (auto &cEdge : p.second) {
            if (cEdge != "data") {
              CallInst *dep = funBuilder.CreateCall(sigDep,funBuilder.getInt64(bbNode_map[p.first].name));
              depVal = funBuilder.CreateAnd(dyn_cast<Value>(dep),depVal);
              dependencies = true;
            }
          }
        }

        //If this block had dependencies, split current block
        if (dependencies) {
          Value *depCMPVal = funBuilder.CreateICmpEQ(depVal,funBuilder.getInt1(1));
          CallInst *depBreakPoint = funBuilder.CreateCall(doNOP,params);
          SplitBlockAndInsertIfThen(depCMPVal,dyn_cast<Instruction>(depBreakPoint),false);
          BasicBlock *trueDepBlock = (*(*trueBlock).getTerminator()).getSuccessor(0);
          BasicBlock *falseDepBlock = (*(*trueBlock).getTerminator()).getSuccessor(1);

          //True Dep Block - Dependencies have been met, execute our data block
          funBuilder.SetInsertPoint((*trueDepBlock).getTerminator());
          if (D) funBuilder.CreateCall(printTrue,funBuilder.getInt64(b.second.name+100));
          funBuilder.CreateCall(sigGet,funBuilder.getInt64(b.second.name));
          (*(*trueDepBlock).getTerminator()).setSuccessor(0,b.first);

          //False Dep Block - Dependencies have not been met, return to loop
          funBuilder.SetInsertPoint((*falseDepBlock).getTerminator());
          if (D) funBuilder.CreateCall(printFalse,funBuilder.getInt64(b.second.name+100));
          (*(*falseDepBlock).getTerminator()).setSuccessor(0,falseBlock);
        } else {
          funBuilder.CreateCall(sigGet,funBuilder.getInt64(b.second.name));
        }

        //False block - (signal not locked), move onto next try check
        funBuilder.SetInsertPoint((*falseBlock).getTerminator());
        if (D) funBuilder.CreateCall(printFalse,funBuilder.getInt64(b.second.name));
        curBlock = falseBlock;

      }
    }

    //Make this an infinite loop
    TerminatorInst *lastInst = (*curBlock).getTerminator(); //Terminator of our last 'than' block
    (*lastInst).setSuccessor(0,topBlock); //Set its terminator to our first block


    for (auto &b : bbNode_map) {
      if (b.first == topBlock) continue; //Don't do modifications on first block, it is considered a starting data block
      Instruction *insertPoint = (*b.first).getTerminator();
      if (insertPoint != NULL) {
        funBuilder.SetInsertPoint((*b.first).getTerminator());

        //Add 'data block complete' signal to end of block (sigPrime)
        funBuilder.CreateCall(sigPrime,funBuilder.getInt64(b.second.name));

        //For unconditional data blocks (returns return, and conditional branchs make branch then signal accordingly)
        TerminatorInst *blockTerm = (*b.first).getTerminator();
        if ((*blockTerm).getNumSuccessors() == 1) { //Branch is unconditional
          (*blockTerm).setSuccessor(0,topBlock); 

          //Add signals for child blocks (sig)
          for (auto &c : b.second.children) {
            for (auto &cEdge : c.second) {
              if (cEdge != "data") {
                funBuilder.CreateCall(sig,funBuilder.getInt64(bbNode_map[c.first].name));
              }
            }
          }
        }
      }
    }
  }
  */
  return true;
}























