#include "blockSplit.h"

//LLVM Related
char blockSplitPass::ID = 0;
RegisterPass<blockSplitPass> Y("blockSplitter","splits all basic blocks into single data value block");
static IRBuilder<> Builder(getGlobalContext());


void
moveUp(Instruction &i, BasicBlock &b) {


}

bool
blockSplitPass::runOnModule(Module &m) {

  for (auto &f : m) {
    BasicBlock &b = f.front();
    BasicBlock *newBB = SplitBlock(&b,&b.front(),this);
    BasicBlock *temp = &(*newBB); 
    Instruction *oldAddLoc = b.getTerminator();
    Instruction *newAddLoc = (*newBB).getTerminator();
  
    int stopAt = 2;
    for (auto &temp : *temp) {
      //    Instruction *startLoc = &(*newBB).front();
      Instruction *instr = dyn_cast<Instruction>(&temp);
      for (auto *u : (*instr).users()) {
        Instruction *cur = dyn_cast<Instruction>(u);
        if ((*cur).getParent() == newBB || (*cur).getParent() == &b) {
          (*cur).moveBefore(oldAddLoc);
        }
      }

      oldAddLoc = (*newBB).getTerminator();
      newBB = SplitBlock(&(*newBB),&(*newBB).front(),this);
      if (stopAt == 0) break;
      stopAt--;
    }

  } 

  return true;
} //end runOnModule

