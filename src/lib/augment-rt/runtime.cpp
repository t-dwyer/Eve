
#include <cstdint>
#include <cstdio>


extern "C" {

bool D = false;  
int num_sig;
bool sig[100];
bool sigPrime[100];

#define AG(X)  Augment_ ## X


bool
  AG(init)(int numBlocks) {
    if (D) printf("Instrumentation initialized\n");
    if (D) printf("Number of blocks found : %d\n",numBlocks);

    num_sig = numBlocks;

    for (int i = 0 ; i < numBlocks ; ++i) {
      sig[i] = false;
      sigPrime[i] = false;
    }

    sigPrime[0] = true;
    return true;
  }


void AG(sig)(int blockNum) {
  if (D) printf("Block %d has been sent a SIGNAL, status was %d is now 1\n",blockNum,sig[blockNum]);
  sig[blockNum] = true;

}

void AG(sigPrime)(int blockNum) {
  if (D) printf("Block %d has been sent a SIG PRIME\n",blockNum);
  sigPrime[blockNum] = true; 
}


int
AG(sigTry)(int blockNum) {
  if (D) printf("Signal Check: Block %d tried, state was %d\n",blockNum,sig[blockNum]);
  if (sig[blockNum]) {
    return 1;
  }
  return 0;
}

int
AG(sigGet)(int blockNum) {
  if (D) printf("Signal Get: Block %d has been taken, state was %d ",blockNum,sig[blockNum]);
  sig[blockNum] = false;
  if (D) printf(" is now %d \n",sig[blockNum]);
  return 0;
}
bool
AG(sigDep)(int blockNum) {
  if (D) printf("Dependency check: Waiting on signal %d, it is %d\n",blockNum, sigPrime[blockNum]);
  return sigPrime[blockNum];
}

void
AG(printTrue)(int blockNum){
  //  printf("True %d!\n",blockNum);
}

void
AG(printFalse)(int blockNum){
  //  printf("False %d!\n", blockNum);
}


void
AG(doNOP)(){}

void
AG(writeOut)() {
  bool x = AG(sigTry)(3);
  if (x) {
    AG(sigPrime)(3);
  } 


}



}

