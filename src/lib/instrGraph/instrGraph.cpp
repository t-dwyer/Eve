#include "instrGraph.h"

char DependencyPass::ID = 0;
RegisterPass<DependencyPass> X("instrDepGraph","construct an instruction dependency graph");

//Value *ErrorV(const char *Str) { Error(Str); return 0; }
static IRBuilder<> Builder(getGlobalContext());
static map<std::string, Value*> NamedValues;

int clustNum = 0;

//Data structure is:
// unordered_map<Source, unordered_map< Destintion, Edge Type>>
// Source is a value/instruction/node
// Destination is a value/instruction/node
// Edge type is Data, Control, Flow
unordered_map<Value*,unordered_map<Value*,vector<string>>> node_map;

void
addEdge(Value &from, Value &to, string type) {
  if (isa<DbgInfoIntrinsic>(from) || isa<DbgInfoIntrinsic>(to)) { return; }

  auto fromLoc = node_map.find(&from); //Find to 'from' instruction
  if (fromLoc == node_map.end()) {  outs() << "FAIL" << from << "\n";  return;  }

  auto targetEdge = fromLoc->second.find(&to);
  if (targetEdge == fromLoc->second.end()) { //Edge does not exit, initialize it
    vector<string> edge_vec;
    edge_vec.push_back(type);
    fromLoc->second.insert(make_pair(&to,edge_vec));
  } else { //Other edges exist, test to see if same color edge exists already
    bool exist = false;
    for (auto targetType : targetEdge->second) {
      if (targetType == type) {
        exist = true;
        break;
      }   
    }   
    if (!exist) { //Edge of same color does not exist, add it
      targetEdge->second.push_back(type);
    }   
  }
}

void
delEdge(Value &from, Value &to) {
  auto fromLoc = node_map.find(&from);
  if (fromLoc == node_map.end()) { outs() << "Should not happen \n"; return; }
  fromLoc->second.erase(&to);
}

void
addNode(Value &i) {
  unordered_map<Value*,vector<string>> edges; //Initialize edges
  node_map.insert(make_pair(&i,edges));
}

void 
findStoreInstr(Value &input, BasicBlock &bb, unordered_set<BasicBlock*> history){

  if (dyn_cast<Instruction>(&input)->getParent() == &bb) return;

  //History of blocks 
  if (history.find(&bb) != history.end()) return;
  else history.insert(&bb);

  //Move backwards through the BB's instructions
  for (BasicBlock::reverse_iterator rI = bb.rbegin(), E = bb.rend(); rI != E; rI++){

    Instruction *compInstr = &*rI;
    if (isa<StoreInst>(compInstr)) {
      StoreInst *store = dyn_cast<StoreInst>(compInstr);
      LoadInst *load = dyn_cast<LoadInst>(&input);
      if (store->getPointerOperand() == load->getPointerOperand()) {
        Value *storeVal = dyn_cast<Value>(store);
        traceBack(*storeVal);
        addEdge(*storeVal,input,"data");
        return;
      }
    }
  }

  //Store instruction was *not* found in this BB, go to its parents and continue...
  for (pred_iterator predIt = pred_begin(&bb), end = pred_end(&bb); predIt != end; ++predIt) {
    BasicBlock *pred = *predIt;
    findStoreInstr(input,*pred,history);
  }
}

void
traceBack(Value &input) {

  //Ignore debug instructions
  if (isa<DbgInfoIntrinsic>(input)) return;

  //Ignore instructions we have added already
  if (node_map.find(&input) != node_map.end()) { return; } 
  
  //Add this instruction - Note: All edges from this node must be added here, it will not be analyzed again
  addNode(input);

  if (isa<Instruction>(input)) {   
    Instruction *instr = dyn_cast<Instruction>(&input);
    BasicBlock *parentBB = instr->getParent();

    //If it's a load instruction, we need to find ALL possible store instructions
    if (isa<LoadInst>(instr)) {
      //Search through all predesessor BBs until find store (LLVM does not store in a BB (I think))
      for (auto predIt = pred_begin(parentBB), end = pred_end(parentBB); predIt != end; ++predIt) {
        BasicBlock *pred = *predIt;
        unordered_set<BasicBlock*> history;
        findStoreInstr(input,*pred,history);
      }
    }

    //If this instruction has operands, add them and recurse
    for (int i = 0; i < int(instr->getNumOperands()); i++) {
      Value *target = dyn_cast<Value>(instr->getOperand(i));
      if (isa<Instruction>(target) || isa<GlobalVariable>(target)) {
        traceBack(*target);
        addEdge(*target, input, "data");
      }
    }
  }
}



void
removeRedCtrEdge(Value &control, BasicBlock *inTarget){

  BasicBlock *targetBlock = inTarget;
  auto controlNode = node_map.find(&control);
  if (controlNode == node_map.end()) return;
  auto controlEdges = controlNode->second;

  for (auto &parent : *targetBlock) {
    auto parentNode = node_map.find(&parent);
    if (parentNode == node_map.end() ) { return; }

    auto parentEdges = parentNode->second;

    for (auto child : parentEdges) { 
      auto dupEdge = controlEdges.find(dyn_cast<Value>(child.first));
      if (dupEdge != controlEdges.end()) {
        //There is an edge between parent and child
        //AND an Edge between control and parent (how we found parent)
        //AND an Edge between control and child (above)
        if (dupEdge->first != dyn_cast<Value>(targetBlock->getFirstNonPHI())) {
          //AND that edge is not the first, incomming edge to BB
          addEdge(parent,*child.first,"flow");
          delEdge(control, *child.first);
        }
      }
    }
  }
  
}



bool
DependencyPass::runOnModule(Module &m) {
  for (auto &f : m) {
    Value *startNode = Builder.CreateUnreachable();
    addNode(*startNode); 

    for (auto &b : f) {     
      for (auto &i : b) {

        /****** Add all DATA dependencies ******/
        traceBack(i); 

        /****** Add start node control dependencies ******/
        if (&b == &f.front()) 
          addEdge(*startNode,i,"control");     

        /***** Add in all control dependencies *****/
        if (isa<BranchInst>(&i)) {
          BranchInst *branch = dyn_cast<BranchInst>(&i);
          if (branch->isUnconditional()) {
            for (unsigned suc = 0; suc < branch->getNumSuccessors(); ++suc) {
              for (auto &child : *branch->getSuccessor(suc)) {
                addEdge(i,child,"control");
              }
            }
          } else {
            for (unsigned suc = 0; suc < branch->getNumSuccessors(); ++suc) {
              for (auto &child : *branch->getSuccessor(suc)) {
                addEdge(i,child,"control"+ to_string(suc));
              }
            }
          }
        }
      }

      /***** Move redundent controle edges into flow edges ******/
      for (auto predIt = pred_begin(&b), end = pred_end(&b); predIt != end; ++predIt) {
        BasicBlock *pred = *predIt;
        if (pred->getTerminator()) {
          Value *control = dyn_cast<Value>(pred->getTerminator());
          removeRedCtrEdge(*control,&b);
          removeRedCtrEdge(*startNode,pred);
        }

      }
      removeRedCtrEdge(*startNode,&b);
    }
  }
  
  //Remove un-necessary branch statement edges
  bool flag = true;
  while(flag) {
    flag = false;
    for (auto n : node_map) {
      if (isa<BranchInst>(n.first) && dyn_cast<BranchInst>(n.first)->isConditional()) {
        //Node 'n' is an conditional branch instruction
        for (auto child : n.second) {
          if (isa<BranchInst>(child.first) && dyn_cast<BranchInst>(child.first)->isUnconditional()) {
            //Node 'n' has a child, 'child', that is an unconditional branch. Merge.
            for (auto childEdge : node_map.find(child.first)->second) {
              addEdge(*n.first,*childEdge.first,child.second[0]);
              delEdge(*n.first,*child.first);
              flag = true;
            }
          }

        }
      } 
    }
  }
  
  
  //Remove the unconditional branch instr
  for (auto &f : m) {
    for (auto &b : f) {
      for (auto &i : b) {
        if (isa<BranchInst>(&i) && dyn_cast<BranchInst>(&i)->isUnconditional()) {
         node_map.erase(&i);
        }
      }
    }
  }
  
  return false;
}


//Following 3 functions used for clustering instructions
void 
print_clustH(string label, string color, bool header) {
  if (header) {
    outs() << "subgraph cluster" << clustNum << " {\n" 
      << "style=filled;\n" 
      << "color=" << color << ";\n"
      << "label=\"" << label << "\";\n";
  } else {
    outs() << "}\n";
    clustNum++;
  }
}

void
print_clustNode(const Value &input) {
  if (isa<DbgInfoIntrinsic>(input)) return;
//  if (isa<BranchInst>(&input) && dyn_cast<BranchInst>(&input)->isUnconditional()) return;
  outs() << &input << ";\n";
}

void 
clust_data(const Value &input) {
  print_clustNode(input);
  for (const User *U : input.users()) {
    clust_data(*dyn_cast<Value>(U));  
  }
}

//Prints out the graph in a graphviz friendly way
void
DependencyPass::print(raw_ostream &out, const Module *m) const {
  bool MODULE = false;
  bool FUNCTION = true;
  bool BLOCKS = false;
  bool DATAGRP = true;

  out << "digraph {\n  node [shape=record];\n";

  for (auto n : node_map) {
    string name = "Unknown";
    string var = "";
    if (isa<Instruction>(n.first)) {
      Instruction *nInstr = dyn_cast<Instruction>(n.first);
      name = nInstr->getOpcodeName();
      var = nInstr->getName();
    } else {
      name = n.first->getName();
    }

    if (name == "unreachable") {
      name = "Start";
      if (n.second.size() == 0) continue; //Don't add empty start nodes
    }

    out << " " << n.first
      << "[label=\"{" << name << ":" << var
      << "}\"];\n";
  }

  string color = "black";

  // Print the edges between them
  for (auto node : node_map) {  //Move through all source functions 
    // node_map = unordered_map, node.first = from Instruction, node.second = unordered_map
    for (auto target : node.second) { //Move through all target
      //node.second = unordered_map, target.first = to Instruction, node.second = edge vector
      for (auto edge : target.second) { ///Move through all edges between target
        //target.second = vector<string>, edge = edge code between from and to
        if (edge == "control") {
          color = "chocolate";
        } else if (edge == "control0") {
          color = "green";
        } else if (edge == "control1") {
          color = "red";
        } else if (edge == "data") {
          color = "black";
        } else if (edge == "test") {
          color = "yellow";
        } else if (edge == "flow") {
          color = "blue";
        } else {
          color = "blue";
        }
        out << "  " <<  node.first
          << " -> " << target.first << "[color=" << color << "];\n";
      }
    }
  }


  if (MODULE) print_clustH("Main Module","white",true);
  for (auto &f : *m) {
    if (FUNCTION) print_clustH(f.getName(),"lightgray",true);
    for (auto &b : f) {
      if (BLOCKS) print_clustH("BB","lightblue",true);
      for (auto &i : b) {
        if (DATAGRP && !strcmp(i.getOpcodeName(),"alloca") ) {
          print_clustH(i.getName(),"lightblue",true);
          clust_data(*dyn_cast<Value>(&i));
          print_clustH(i.getName(),"lightblue",false);
        }
        if (BLOCKS | FUNCTION | MODULE) print_clustNode(*dyn_cast<Value>(&i));
      }
      if (BLOCKS) print_clustH("BB","lightblue",false);
    }
    if (FUNCTION) print_clustH(f.getName(),"lightgray",false);
  }
  if (MODULE) print_clustH("module","white",false);

  out << "}\n";

}

