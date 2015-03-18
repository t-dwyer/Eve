#include "../../include/blockSplit.h"
#include "../../include/instrGraph.h"

/*struct bbNode {
  int name;
  BasicBlock* block;
  vector<Value*> contents;
  unordered_map<BasicBlock*, unordered_set<string>> parents;
  unordered_map<BasicBlock*, unordered_set<string>> children;
};*/

//LLVM Related
char blockSplitPass::ID = 0;
RegisterPass<blockSplitPass> Y("blockSplitter","splits all basic blocks into single data value block");
static IRBuilder<> Builder(getGlobalContext());

//Finds all the users of 'i' that are within basic block 'b'
vector<Instruction*>
findBlockUsers(Instruction &i, BasicBlock &b) {
  vector<Instruction*> useList; //List of instruction i's users
  useList.push_back(&i);        //i is a user of its self
  if (b.getTerminator() == &i) return useList; //if i is the last instruction, return
  for (auto *u : i.users()) {   //Iterate over all the users of i
    Instruction *instr = dyn_cast<Instruction>(u); //Cast each as an instruction
    if ((*instr).getParent() == &b) { //Check if the instruction is within the basic block
      useList.push_back(instr); //Add it to the list if it is
      //Find this instructions users, if they are in this bb, and them also
      auto deepUseList = findBlockUsers(*instr,b);
      for (auto d : deepUseList) {
        useList.push_back(d);
      }
    }
  } 
  return useList;
}

//Creates a new empty basic block above 'b', moves all instructions in 'workGroup' to the the block
//Below 'b' block is return, the BB without the workGroup instructions
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
  for (auto &f : m) { for (auto &b : f) { 
    if (f.getName() != "main") continue;
    bbList.push_back(&b); 
  } }
  for (auto &b : bbList) {
    vector<Instruction*> workGroup = findBlockUsers((*b).front(),*b); //Create a list of like-data instructions
    BasicBlock* newBlock = b; //The working block

    //Create the parent block (empty)
    BasicBlock* parentBlock = b ; //The parent block for internal blocks
    bbNode parentNode;
    parentNode.block = parentBlock; //Add original block as parent block
    bool split = !(workGroup.size() == (*parentBlock).size()+1);
    if (split) { //This block has instructions
      newBlock = SplitBlock(b,&(*b).front(),this); //Create an empty parent block (parent = b)
      unordered_set<string> edge;  edge.insert("control");
      parentNode.children[newBlock] = edge;
    }

    //Create ending block (empty) 
    bbNode endNode;
    BasicBlock* endBlock;
    endNode.block = parentBlock;
    if (split) {
      endBlock = SplitBlock(newBlock,(*newBlock).getTerminator(),this); //Create an empty parent block (parent = b)
      endNode.block = endBlock;
      for (Value &v : *endBlock) { endNode.contents.push_back(&v);  }
      
      int splitNum = 0;
      for (succ_iterator SI = succ_begin(endBlock), E = succ_end(endBlock); SI != E; ++SI) {
        unordered_set<string> edge; 
        BasicBlock *Succ = *SI;
        edge.insert("control"+to_string(splitNum)); splitNum++;
        endNode.children[Succ] = edge;
      }
    }

//    vector<BasicBlock*> childList;
    //Create the internal blocks (one user per block)
    while (split) {
      workGroup = findBlockUsers((*newBlock).front(),*newBlock); //Get the new user for this block
      BasicBlock *localBlock = splitBlocksUp(*newBlock,workGroup); //Keep one user from the block, and create a new one

      unordered_set<string> edge;  edge.insert("control");
      parentNode.children[newBlock] = edge;

      bbNode childNode; 
      childNode.block = newBlock;
      unordered_set<string> edge1;  edge1.insert("control");
      childNode.parents[parentNode.block] = edge1; 
      unordered_set<string> edge2;  edge2.insert("control");
      childNode.children[endNode.block] = edge2;
      for (Value &v : *newBlock) { childNode.contents.push_back(&v);  }

      unordered_set<string> edge3;  edge3.insert("control");
      endNode.parents[newBlock] = edge3;

//      childList.insert(newBlock);

      bbNode_map[childNode.block] = childNode;

      if ((*newBlock).size() > 2) newBlock = localBlock;
      else break;
    }

    if (!split) {
      int splitNum = 0;
      for (succ_iterator SI = succ_begin(parentNode.block), E = succ_end(parentNode.block); SI != E; ++SI) {
        unordered_set<string> edge;
        BasicBlock *Succ = *SI;
        edge.insert("control"+to_string(splitNum)); splitNum++;
        parentNode.children[Succ] = edge;
      }
    } else {
      for (Value &v : *(endNode.block)) { endNode.contents.push_back(&v);  }
      bbNode_map[endNode.block] = endNode;
    }

    for (Value &v : *parentBlock) { parentNode.contents.push_back(&v);  }
    bbNode_map[parentNode.block] = parentNode;
  }  
  return true;
} //end runOnModule
