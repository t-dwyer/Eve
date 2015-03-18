

#ifndef PATHENCODINGPASS_H
#define PATHENCODINGPASS_H


#include "llvm/Analysis/LoopInfo.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Module.h"
#include "llvm/Pass.h"


namespace augment {


struct AugmentPass : public llvm::ModulePass {

  static char ID;

  AugmentPass() : llvm::ModulePass(ID) { }

  virtual void getAnalysisUsage(llvm::AnalysisUsage &au) const override {
      au.setPreservesAll();
      au.addRequired<llvm::DataLayoutPass>();
  }

  virtual bool runOnModule(llvm::Module &m) override;

};


}


#endif

