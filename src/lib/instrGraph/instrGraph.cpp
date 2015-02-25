#include "instrGraph.h"

char DependencyPass::ID = 0;
RegisterPass<DependencyPass> X("instrDepGraph","construct an instruction dependency graph");

bool header = true;
int clustNum = 0;
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

  if (history.find(&bb) != history.end()) return;
  else history.insert(&bb);

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

  if (isa<DbgInfoIntrinsic>(input)) return;

  auto itr = node_map.find(&input); 
  if (itr != node_map.end()) { return; } 
  addNode(input);

  if (isa<Instruction>(input)) {   
    Instruction *instr = dyn_cast<Instruction>(&input);
    BasicBlock *parentBB = instr->getParent();

    //Search through current branch block, until hit beginning (needed?)
    if (isa<LoadInst>(instr)) {
      //Search through all predesessor BBs until find store
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


    //Add control dependencies, and recurse
    int temp = 0;

    for (auto predIt = pred_begin(parentBB), end = pred_end(parentBB); predIt != end; ++predIt) {
      BasicBlock *pred = *predIt;
      Value *control = dyn_cast<Value>(pred->getTerminator());
      traceBack(*control);
      addEdge(*control,input,"control"+to_string(temp));
      temp++;
    }

  }
}

void
removeRedCtrEdge(Value &control, BasicBlock *inTarget){

  BasicBlock *targetBlock = inTarget;
  auto controlNode = node_map.find(&control);
  auto controlEdges = controlNode->second;

  for (auto &parent : *targetBlock) {
    auto parentNode = node_map.find(&parent);
    if (parentNode == node_map.end() ) { outs() << "findRedundant fail1 \n"; return; }

    auto parentEdges = parentNode->second;

    for (auto child : parentEdges) { 
      auto dupEdge = controlEdges.find(dyn_cast<Value>(child.first));
      if (dupEdge != controlEdges.end()) {
        //There is an edge between parent and child
        //AND an Edge between control and parent (how we found parent)
        //AND an Edge between control and child (above)
        if (dupEdge->first != dyn_cast<Value>(targetBlock->getFirstNonPHI())) {
          //AND that edge is not the first, incomming edge to BB
          addEdge(parent,*child.first,"control");
          delEdge(control, *child.first);
        }
      }
    }
  }
}

void
removeRedCtrNode() {
  for (auto n : node_map) {
    auto node = n.first;
    if (isa<BranchInst>(node)) {
      Instruction *target = dyn_cast<Instruction>(node);

    }
  }
}

void
print_clustNode(Value &input) {
  if (isa<DbgInfoIntrinsic>(input)) return;
  outs() << &input << ";\n";
}

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
clust_data(Value &input) {
  print_clustNode(input);
  for (User *U : input.users()) {
    clust_data(*dyn_cast<Value>(U));  
  }
}




bool
DependencyPass::runOnModule(Module &m) {
  bool SERIAL = false;
  bool BLOCKS = false;
  bool DATAGRP = true;
  if (header) return false;

  if (BLOCKS) print_clustH("Main Module","white",true);
  for (auto &f : m) {
    Value *prevInstr = NULL;

    if (BLOCKS) print_clustH(f.getName(),"lightgray",true);
    for (auto &b : f) {

      if (BLOCKS) print_clustH("BB","lightblue",true);
      for (auto &i : b) {

        traceBack(i);

        if (DATAGRP && !strcmp(i.getOpcodeName(),"alloca")) {
          print_clustH(i.getName(),"lightblue",true);
          clust_data(*dyn_cast<User>(&i));
          print_clustH(i.getName(),"lightblue",false);
        }
        if (BLOCKS) print_clustNode(i);
        if (SERIAL && prevInstr) {addEdge(*prevInstr,*dyn_cast<Value>(&i),"serial"); }
        prevInstr = &i;

      }

      if (BLOCKS) print_clustH("BB","lightblue",false);

    }
    if (BLOCKS) print_clustH(f.getName(),"lightgray",false);


  }
  if (BLOCKS) print_clustH("module","white",false);


/*
  for (auto &f : m) {
    for (auto &b : f) {
      for (auto predIt = pred_begin(&b), end = pred_end(&b); predIt != end; ++predIt) {
        BasicBlock *pred = *predIt;
        if (pred->getTerminator()) {
          Value *control = dyn_cast<Value>(pred->getTerminator());
          removeRedCtrEdge(*control,&b);
        }
      }
    }
  }
*/
  /******End of analysis on LLVM IR**************/
  /******Start of optimization on node_map*******/

//  removeRedCtrNode();


  return false;
}


//Prints out the graph in a graphviz friendly way
void
DependencyPass::print(raw_ostream &out, const Module *m) const {
  if (header) {
    out << "digraph {\n  node [shape=record];\n";
    header = false;
  } else {

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
          if (edge == "control0") {
            color = "green";
          } else if (edge == "control1") {
            color = "red";
          } else if (edge == "data") {
            color = "black";
          } else if (edge == "test") {
            color = "pink";
          } else if (edge == "serial") {
            color = "red";
          } else {
            color = "blue";
          }
          out << "  " <<  node.first
            << " -> " << target.first << "[color=" << color << "];\n";
        }
      }
    }



    out << "}\n";
  }
}

