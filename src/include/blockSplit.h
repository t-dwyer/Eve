
#include "llvm/Transforms/IPO.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/Analysis/LoopPass.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Module.h"
#include "llvm/Pass.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Transforms/Scalar.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"
#include "llvm/Transforms/Utils/CodeExtractor.h"

#include "llvm/Pass.h"
#include "llvm/Analysis/AliasAnalysis.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/DebugInfo.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/IR/GlobalVariable.h"

//#include "llvm/Tranforms/Utils/BasicBlockUtils.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/IRBuilder.h"

#include <unordered_map>
#include <unordered_set>
#include <vector>

namespace blockSplit {
  struct blockSplitPass : public llvm::ModulePass {
    static char ID;
    blockSplitPass() : ModulePass(ID) { }  
    virtual ~blockSplitPass() { }
   
    virtual void getAnalysisUsage(llvm::AnalysisUsage &au) const override {
      au.setPreservesAll();
      au.addRequired<llvm::DataLayoutPass>();
    }

    virtual bool runOnModule(llvm::Module &m) override;
    virtual llvm::BasicBlock* splitBlocksUp(llvm::BasicBlock &b,std::vector<llvm::Instruction*>);
  };
}


using namespace blockSplit;
using namespace llvm;
using namespace std;

