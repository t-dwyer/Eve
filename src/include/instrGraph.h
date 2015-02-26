
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

#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/IRBuilder.h"

#include <unordered_map>
#include <unordered_set>
#include <vector>

namespace instrGraph {
  struct DependencyPass : public llvm::ModulePass {
    static char ID;
    DependencyPass() : ModulePass(ID) { }  
    virtual ~DependencyPass() { }
   
    virtual void getAnalysisUsage(llvm::AnalysisUsage &au) const override {
      au.setPreservesAll();
      au.addRequired<llvm::DataLayoutPass>();
    }

    virtual bool runOnModule(llvm::Module &m) override;
    virtual void print(llvm::raw_ostream &out, const llvm::Module *m) const;
  };
}

void traceBack(llvm::Value &input);

using namespace instrGraph;
using namespace llvm;
using namespace std;

