#include "instrGraph.h"

//Datastructure related
struct Vertex {
  Value* val;
  unordered_map<Value*, unordered_set<string>> parents;
  unordered_map<Value*, unordered_set<string>> children;
  int level;
};

unordered_map<Value*,Vertex> vertex_map;

//LLVM Related
char DependencyPass::ID = 0;
RegisterPass<DependencyPass> X("instrDepGraph","construct an instruction dependency graph");
static IRBuilder<> Builder(getGlobalContext());


//CLustering related
bool MODULE = false;
bool FUNCTION = false;
bool BLOCKS = false;
bool DATAGRP = true;
bool LEVELS = false;
int clustNum = 0;

//GraphViz Edge related
bool CONTROL_ONLY = false;
bool DATA_ONLY = false;

unordered_map<Vertex*, int> vertex_order;


Vertex*
addNode(Value &i) {
  unordered_map<Value*,unordered_set<string>> parents; //Initialize parent edges
  unordered_map<Value*,unordered_set<string>> children; //Initialize child edges
  
  Vertex input; 
  input.val = &i;
  input.parents = parents;
  input.children = children;
  
  vertex_map[input.val] = input;

  return &vertex_map[input.val];
}

void 
addChild(Value &from, Value &child, string type) {
  if (isa<DbgInfoIntrinsic>(from) || isa<DbgInfoIntrinsic>(child)) { return; }
  if (vertex_map.find(&from) == vertex_map.end()) addNode(from); 
  if (vertex_map.find(&child) == vertex_map.end()) addNode(child);

  //Add 'child' as a child to the 'from' node
  auto *curChildren = &vertex_map[&from].children; 
  if ((*curChildren).find(&child) == (*curChildren).end()) { //Child has not been added before
    unordered_set<string> edge_types;
    edge_types.insert(type);
    (*curChildren)[&child] = edge_types;
  } else { //Child exists, add new edge type
    (*curChildren)[&child].insert(type);  
  }

  //Add 'from' as a parent to the 'child' node
  auto *curParents = &vertex_map[&child].parents; 
  if ((*curParents).find(&from) == (*curParents).end()) { //Has no parents, is batman
    unordered_set<string> edge_types;
    edge_types.insert(type);
    (*curParents)[&from] = edge_types;
  } else { //Parents exists, add new edge type
    (*curParents)[&from].insert(type);  
  }

}

void
addParent(Value &from, Value &parent, string type) {
  if (isa<DbgInfoIntrinsic>(from) || isa<DbgInfoIntrinsic>(parent)) { return; }
  if (vertex_map.find(&from) == vertex_map.end()) addNode(from);
  if (vertex_map.find(&parent) == vertex_map.end()) addNode(parent);

  //Add 'parent' as a parent to the 'from' node
  auto *curParents = &vertex_map[&from].parents; 
  if ((*curParents).find(&parent) == (*curParents).end()) { //Has no parents, is batman
    unordered_set<string> edge_types;
    edge_types.insert(type);
    (*curParents)[&parent] = edge_types;
  } else { //Parents exists, add new edge type
    (*curParents)[&parent].insert(type);  
  }

  //Add 'from' as a child of the 'parent' node
  auto *curChildren = &vertex_map[&parent].children; 
  if ((*curChildren).find(&from) == (*curChildren).end()) { //Child has not been added before
    unordered_set<string> edge_types;
    edge_types.insert(type);
    (*curChildren)[&from] = edge_types;
  } else { //Child exists, add new edge type
    (*curChildren)[&from].insert(type);  
  }
}

void
delChildEdges(Value &from, Value &to) {
  if (vertex_map.find(&from) == vertex_map.end()) { 
    outs() << "Error: delEdge - Cannot find 'from' vertex " << from << "\n";    return;   }
  if (vertex_map.find(&to) == vertex_map.end()) { 
    outs() << "Error: delEdge - Cannot find 'to' vertex " << from << "\n";    return;   }

  vertex_map[&from].children.erase(&to);
  vertex_map[&to].parents.erase(&to);
}

void
delParentEdges(Value &from, Value &to) {
  if (vertex_map.find(&from) == vertex_map.end()) { 
    outs() << "Error: delEdge - Cannot find 'from' vertex " << from << "\n";    return;   }
  if (vertex_map.find(&to) == vertex_map.end()) { 
    outs() << "Error: delEdge - Cannot find 'to' vertex " << from << "\n";    return;   }

  vertex_map[&from].parents.erase(&to);
  vertex_map[&to].children.erase(&to);
}



void 
findStoreInstr(Value &input, BasicBlock &bb, unordered_set<BasicBlock*> history){
  if (history.find(&bb) == history.end()) history.insert(&bb);
  else return;
  
  

  //Move backwards through the BB's instructions
  for (BasicBlock::reverse_iterator rI = bb.rbegin(), E = bb.rend(); rI != E; rI++){
    Instruction *compInstr = &*rI;
    if (isa<StoreInst>(compInstr)) {
      StoreInst *store = dyn_cast<StoreInst>(compInstr);
      LoadInst *load = dyn_cast<LoadInst>(&input);
      if (store->getPointerOperand() == load->getPointerOperand()) {
        Value *storeVal = dyn_cast<Value>(store);
//        if (node_map.find(store) == node_map.end()) traceBack(*storeVal);
        addChild(*storeVal,input,"data");
        addParent(input,*storeVal,"data");
        return;
      }
    }
  }

  //Store instruction was *not* found in this BB, go to its parents and continue...
  for (pred_iterator predIt = pred_begin(&bb), end = pred_end(&bb); predIt != end; ++predIt) {
    BasicBlock *pred = *predIt;
    findStoreInstr(input,*pred, history);
  }
}

void
traceBack(Value &input) {
  //Ignore debug instructions
  if (isa<DbgInfoIntrinsic>(input)) return;

  if (vertex_map.find(&input) == vertex_map.end()) addNode(input); 

  if (isa<Instruction>(input)) {   
    Instruction *instr = dyn_cast<Instruction>(&input);
    BasicBlock *parentBB = instr->getParent();

    //If it's a load instruction, we need to find ALL possible store instructions
    if (isa<LoadInst>(instr)) {
      //Search through all predesessor BBs until find store
//      unordered_set<BasicBlock*> history;
//      findStoreInstr(input,*parentBB,history);
      for (auto predIt = pred_begin(parentBB), end = pred_end(parentBB); predIt != end; ++predIt) {
//        BasicBlock *pred = *predIt;

//        findStoreInstr(input,*pred,history);
      }
    }

    //If this instruction has operands, add them and recurse
    for (int i = 0; i < int(instr->getNumOperands()); i++) {
      Value *target = dyn_cast<Value>(instr->getOperand(i));
      if (isa<Instruction>(target) || isa<GlobalVariable>(target)) {
        addChild(*target,input, "data");
        addParent(input,*target, "data");
        traceBack(*target);
      }
    }
  }
}

void
addControl(Value &input) {
  BranchInst *branch = dyn_cast<BranchInst>(&input);
  if (branch->isUnconditional()) {
    for (unsigned suc = 0; suc < branch->getNumSuccessors(); ++suc) {
      for (auto &child : *branch->getSuccessor(suc)) {
        addChild(input,child,"control");
        addParent(child,input,"control");
      }
    }
  } else {
    for (unsigned suc = 0; suc < branch->getNumSuccessors(); ++suc) {
      for (auto &child : *branch->getSuccessor(suc)) {
        addChild(input,child,"control" + to_string(suc));
        addParent(child,input,"control" + to_string(suc));
      }
    }
  }
}

void
getOrdering(Vertex &v, int depth) {
  if (vertex_order.find(&v) != vertex_order.end()) return;
  vertex_order[&v] = depth;
  vertex_map[v.val].level = depth;
  for (auto child : v.children) {
    getOrdering(vertex_map[child.first],depth+1);
  }
}

bool
DependencyPass::runOnModule(Module &m) {
  unordered_set<Vertex*> starts;

  for (auto &f : m) {
    Value *startNode = Builder.CreateUnreachable();
    Vertex *startVertex = addNode(*startNode);
    starts.insert(startVertex);

    for (auto &b : f) {     
      for (auto &i : b) {

        /****** Add all DATA dependencies ******/
        traceBack(i); 

        /****** Add start node control dependencies ******/
        if (&b == &f.front()) {
          addChild(*startNode,i,"control");
          addParent(i,*startNode,"control");
        }

        /***** Add in all control dependencies *****/
        if (isa<BranchInst>(&i)) 
          addControl(i);

      } //end BB for
    } //end Fun for
  } //end Mod for


  for (auto v : starts) {
    if ((*v).parents.size() == 0) {
      getOrdering(*v,0);
    }
  }

  return false;
} //end runOnModule


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

  //Print graphviz header
  out << "digraph {\n  node [shape=record];\n";

  // Print all vertex's
  for (auto v : vertex_map) {
    string name = "Unknown";
    string var = "";
    if (isa<Instruction>(v.first)) {
      Instruction *nInstr = dyn_cast<Instruction>(v.first);
      name = nInstr->getOpcodeName();
      var = nInstr->getName();
    } else {
      name = v.first->getName();
    }

    if (name == "unreachable") {
      name = "Start";
      if (v.second.children.size() == 0) continue; //Don't add empty start nodes
    }

    //Print graphviz node
    out << " " << v.first << "[label=\"{" << name << ":" << var << v.second.level << "}\"];\n";
  }

  string color = "black";

  // Print the edges between them
  for (auto v : vertex_map) {  //Iterate through all vertex's 
    for (auto child : v.second.children) { //Iterate over children
      for (auto edge : child.second) { ///Iterate over edges
        if (edge == "control") {
          color = "black";
        } else if (edge == "control0") {
          color = "green";
        } else if (edge == "control1") {
          color = "red";
        } else if (edge == "data") {
          color = "blue";
        } else if (edge == "test") {
          color = "yellow";
        } else {
          color = "pink";
        }
        
        //Print graphviz edge
        if (CONTROL_ONLY && edge == "data") continue;
        if (DATA_ONLY && (edge == "control" || edge == "control0" || edge == "control1")) continue;
        out << "  " <<  v.first << " -> " << child.first << "[color=" << color << "];\n";
      }
    }
  }

  //Do some clustering
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

  if (LEVELS) {
    bool flag = true;
    int curLevel = 0;
    while (flag) {
      flag = false;

      print_clustH(to_string(curLevel),"green",true);
      for (auto &v : vertex_order) {
        if (v.second == curLevel) {
          flag = true;
          Value *vValue = (*v.first).val;
          outs() << vValue << ";\n";
        }
      }
      print_clustH(to_string(curLevel),"green",false);
      curLevel++;
    }
  }
  //Print graphviz footer
  out << "}\n";

}


