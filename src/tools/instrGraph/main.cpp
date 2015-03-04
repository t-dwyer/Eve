#include "main.h"
#include "instrGraph.h"
#include "blockSplit.h"

namespace {
  cl::opt<string>
  inPath( cl::Positional,
          cl::desc("<Module to analyze>"),
          cl::value_desc("bitcode filename"), 
          cl::Required);


template<typename T, typename... Args>
unique_ptr<T> make_unique(Args&&... args) { return unique_ptr<T>(new T(forward<Args>(args)...)); }

template<typename T>
struct DomGraphPrinter : public ModulePass {
  static char ID; 
  raw_ostream &out;
  DomGraphPrinter(raw_ostream &out) : ModulePass(ID), out(out) { } 
  virtual bool runOnModule(Module &m) { getAnalysis<T>().print(out, &m); return false; }
  virtual void getAnalysisUsage(AnalysisUsage &AU) const {
    AU.addRequired<T>();
//    AU.addRequired<DataLayoutPass>();
    AU.setPreservesAll();
  }
};
template<typename T>
char DomGraphPrinter<T>::ID = 0;


}

static void
saveModule(Module &m) {
  string errorMsg;
  raw_fd_ostream out("output.bc", errorMsg, sys::fs::F_None);
  if (!errorMsg.empty()){
    report_fatal_error("error saving llvm module to file \n"
        + errorMsg);
  }
  WriteBitcodeToFile(&m, out);
}

int
main (int argc, char **argv, const char **env) {
  // This boilerplate provides convenient stack traces and clean LLVM exit
  // handling. It also initializes the built in support for convenient
  // command line option handling.
  sys::PrintStackTraceOnErrorSignal();
  llvm::PrettyStackTraceProgram X(argc, argv);
  llvm_shutdown_obj shutdown;
  cl::ParseCommandLineOptions(argc, argv);

  // Construct an IR file from the filename passed on the command line.
  LLVMContext &context = getGlobalContext();
  SMDiagnostic err;
  unique_ptr<Module> module;
  module.reset(ParseIRFile(inPath.getValue(), err, context));

  if (!module.get()) {
    errs() << "Error reading bitcode file.\n";
    err.print(argv[0], errs());
    return -1;
  }

  // Build up all of the passes that we want to run on the module.
  PassManager pm;

  pm.add(new DataLayoutPass(module.get()));
  pm.add(new blockSplit::blockSplitPass);
  pm.add(new instrGraph::DependencyPass);
  pm.add(new DomGraphPrinter<instrGraph::DependencyPass>(outs()));

  pm.run(*module);

  saveModule(*module);
  return 0;
}

