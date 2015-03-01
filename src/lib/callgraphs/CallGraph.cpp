
#include "CallGraph.h"
#include "llvm/IR/DebugInfo.h"
#include "llvm/Support/raw_ostream.h"

#include <list>
#include <iterator>

using namespace llvm;
using namespace callgraphs;

//Create a map for all the functions and their callsites
std::unordered_map<std::string,std::vector<std::pair<std::string,std::string>>> call_data;
char WeightedCallGraphPass::ID = 0;

RegisterPass<WeightedCallGraphPass> X("weightedcg","construct a weighted call graph of a module");


//This is run on each module of the application
bool
WeightedCallGraphPass::runOnModule(Module &m) {
  for (Function &fun : m){
  std::vector<std::pair<std::string,std::string>> callString;
    if (fun.getName() == "llvm.dbg.declare" || fun.getName() == "llvm.dbg.value") {
			continue;
		}
		for (BasicBlock &bb : fun) {
			for (Instruction &i : bb) {
				//Determines if this is a callsite
				CallSite cs(&i);
				if (!cs.getInstruction()) {
					continue;
				}

				//Get the filename and line number				
				std::string locStr;
				if (MDNode *n = i.getMetadata("dbg")) {
					DILocation loc(n);
					locStr = std::string(loc.getFilename()) + ":"; 
					locStr = locStr + std::to_string(loc.getLineNumber());
				}

				//This is a callsite, so get the function called
				Value *called = cs.getCalledValue()->stripPointerCasts();
				
				if (Function *f = dyn_cast<Function>(called)) {
				//Direct function call, f is the function called
					if (f->getName() != "llvm.dbg.declare" && f->getName() != "llvm.dbg.value") {
						callString.push_back(std::make_pair(f->getName(),locStr)); //instruction string added to vector
					}
				} else {
				//Indirect function call, test is function pointer

					CallInst *test = dyn_cast<CallInst>(&i); //Our function pointer

					for (Function &tFun : m) { //Go through all functions to compare function pointer to
						if (tFun.getName() != "llvm.dbg.declare" && tFun.getName() != "llvm.dbg.value") { //Skip debug functions
							Type *fType = tFun.getType()->getContainedType(0); //Get the type, but then the type inside that type								
							
              int testArgs = int(test->getNumArgOperands()); //Operands on the function pointer
							int funArgs = int(fType->getNumContainedTypes()); //Arguements in the function we are testing on

              bool flag = false; //A flag to test if this function is a possible target of the function pointer

              if (testArgs >= funArgs-1) { //Tests to see if the function has sufficient arguments
                 flag = true;
                 for (int i = 1; i < funArgs; i++) { //If has sufficient arguements, go through each, checking all of them
                   if (test->getArgOperand(i-1)->getType() != fType->getContainedType(i) ) { 	
                     flag = false; //In the case they do not equal, fail
                   }
                 }
              }
							if (funArgs == 1) { //Function doesn't have any arguments, always can work
								callString.push_back(std::make_pair(tFun.getName(),locStr));
							} else if (flag) { //Function augment bits match
								callString.push_back(std::make_pair(tFun.getName(),locStr));
							}
						}
					}
				}	
				
			}
		}

		//Set up data structure to be added ( pair<parentFunction,vector<pair<childFunction,callLocation>> )
		std::pair<std::string,std::vector<std::pair<std::string,std::string>>> retPair;
		retPair = std::make_pair(std::string(fun.getName()),callString);

		//Add above pair to global data structure
		call_data.insert (retPair);
	}	
  	return false;
}

//Gets the number of "in" arrows into a function
int
getWeight(std::string input) {
	int weight = 0;
	for (auto fun : call_data) {
		for (auto call : fun.second) {
			if (call.first == input) {
				weight++;
			}
		}
	}
	return weight;
}



//Prints out the graph in a graphviz friendly way
void
WeightedCallGraphPass::print(raw_ostream &out, const Module *m) const {
//Based upon call_data data structure (unordered map)
// call_data.first = Source function (Map key)
// call_data.second = Vector of all function calls out of source vector<pair<string,string>> = call
//	call[i] = pair<target function, call location (file:lineNumber)>
  
  std::string usedLines = ""; //This keeps track of multiple entries. Done instead of changing above data structure
 // return;
  //Print header
  out << "digraph {\n  node [shape=record];\n";

  // Print out all function nodes
  for (auto fun : call_data) { 	//Move through all source functions
	  out << "  " << fun.first //Function name (Box)
        	<< "[label=\"{" << fun.first // Function name for edges
	        << "|Weight: " << getWeight(fun.first); //Weight (in bound arrows) of function

    unsigned lineID = -1; //Use for unique identification of nodes & edges
    for (auto call : fun.second) { //Move through all targets call is pair<string,string>
		  if (int(usedLines.find(call.second)) < 0) { //This call has been NOT added before  === Lazy man's hack to remove duplicate blocks
		    ++lineID;
			  usedLines = usedLines + "," + call.second;
			  out << "|<l" << lineID << ">" << call.second; //The call location (file:lineNumber) 
		  }
    }
    out << "}\"];\n";
  }

  usedLines = "";
  // Print the edges between them
  for (auto fun : call_data) {	//Move through all source functions
    	unsigned lineID = -1;
    	for (auto call : fun.second) { //Move through all target calls
		    if (int(usedLines.find(call.second)) < 0) { //This call has been NOT added before === Again lazy man's hack :)
			    ++lineID;
			    usedLines += call.second + ",";
		    }
        out << "  " <<  fun.first /* ID for the caller function */
        		<< ":l" << lineID
         		<< " -> " <<  call.first << ";\n"; 		
   	  }
  }

  //Print footer
  out << "}\n";
}

