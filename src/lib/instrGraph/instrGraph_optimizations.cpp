




/*

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

      // Move redundant control edges into flow edges //
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


  */
