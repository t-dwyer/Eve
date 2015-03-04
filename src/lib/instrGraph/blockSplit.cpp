#include "blockSplit.h"

//LLVM Related
char blockSplitPass::ID = 0;
RegisterPass<blockSplitPass> Y("blockSplitter","splits all basic blocks into single data value block");
static IRBuilder<> Builder(getGlobalContext());




vector<Instruction*>
findBlockUsers(Instruction &i, BasicBlock &b) {

  vector<Instruction*> useList;
  useList.push_back(&i);
  
  if (b.getTerminator() == &i) return useList;

  for (auto *u : i.users()) {
    Instruction *instr = dyn_cast<Instruction>(u);
    if ((*instr).getParent() == &b) {
      useList.push_back(instr);
    }
  } 
  return useList;
}

BasicBlock*
blockSplitPass::splitBlocksUp(BasicBlock &b, vector<Instruction*> workGroup) {
  BasicBlock *newBB = SplitBlock(&b,&b.front(),this);
  for (auto &i : workGroup) {
    (*i).moveBefore(b.getTerminator());
  }
  return newBB;
}

bool
blockSplitPass::runOnModule(Module &m) {
  vector<BasicBlock*> bbList;

  for (auto &f : m) {
    for (auto &b : f) {
      bbList.push_back(&b); 
    }
  }

  for (auto &b : bbList) {
    vector<Instruction*> workGroup = findBlockUsers((*b).front(),*b); 
    BasicBlock* newBlock = nullptr;
    if (workGroup.size() >= 1) {
      newBlock = splitBlocksUp(*b,workGroup);
    }
    while (newBlock != NULL && (*newBlock).size() > 2) {
      workGroup = findBlockUsers((*newBlock).front(),*newBlock); 
      if (workGroup.size() >= 1) {
        newBlock = splitBlocksUp(*newBlock,workGroup);
      }
    }
  }
  return true;
} //end runOnModule























