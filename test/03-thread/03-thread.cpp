#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <iostream>

#define REPS    (10)  
#define NUMDATA (1024)
#define DATASIZE (6*1024)

bool fast = true;
pthread_mutex_t mutexA,mutexB;

int curThread = 0;
char dataA[NUMDATA][DATASIZE];
char dataB[NUMDATA][DATASIZE];

void *threadB( void *ptr );

void doWorkA() {
  pthread_mutex_lock(&mutexA);
  printf("Doing work A\n");
  for (int j=0;j<NUMDATA;j++) 
    for (int i=0;i<DATASIZE;i++) {
      dataA[j][i] = dataA[j][i] + rand() % 256; 
    }
  pthread_mutex_unlock(&mutexA);
}

void doWorkB() {
  pthread_mutex_lock(&mutexB);
  printf("Doing work B\n");
  for (int j=0;j<NUMDATA;j++) 
    for (int i=0;i<DATASIZE;i++) {
     dataB[j][i] = dataB[j][i] + rand() % 256; 
    }
  pthread_mutex_unlock(&mutexB);    
}

/*****Start Additional Variables & Functions******/
pthread_mutex_t signalABegin,signalBBegin,signalAEnd,signalBEnd,mSignal;
pthread_t dataThrd,dataThrdA,dataThrdB;

//Helper function for sending control messages 
void sendMsg(pthread_mutex_t &start, pthread_mutex_t &finish){
//  pthread_mutex_lock(&mSignal);
  pthread_mutex_unlock(&start); //Tell data thread to start
  pthread_mutex_lock(&finish); //Wait for data thread to finish
//  pthread_mutex_unlock(&mSignal);    
}

//Thread that handles data
void *dataThreadA( void *ptr )
{   
  for (int t=0;t<NUMDATA;t++) { for (int i=0;i<DATASIZE;i++) { dataA[t][i] = rand() % 256; } }
  while (true) { 
    if (pthread_mutex_trylock(&signalABegin) == 0){ //check for doWorkA() message
      doWorkA();
      pthread_mutex_unlock(&signalAEnd);
    } 
  }
  return 0;
}
//Thread that handles data
void *dataThreadB( void *ptr )
{
  for (int t=0;t<NUMDATA;t++) { for (int i=0;i<DATASIZE;i++) { dataB[t][i] = rand() % 256; } }
  while (true) { 
    if (pthread_mutex_trylock(&signalBBegin) == 0){ //check for doWorkB() message
      doWorkB();
     pthread_mutex_unlock(&signalBEnd);
    }
  }
  return 0;
}
/******End Additional Variables & Functions******/

  int
main( int argc, char* argv[])
{
  if (argc <= 1) { printf("Please enter 'slow' or 'fast' as an arguement\n"); return 1; }
  if (std::string(argv[1]) == "slow") fast = false; //else, run as fast

  //Initialize Mutex's
  pthread_mutex_init(&mutexA, NULL); 
  pthread_mutex_init(&mutexB, NULL); 

  if (fast) {
    //Initialize & lock additional signal mutex's
    pthread_mutex_init(&signalABegin, NULL);  pthread_mutex_lock(&signalABegin);
    pthread_mutex_init(&signalAEnd, NULL);    pthread_mutex_lock(&signalAEnd);
    pthread_mutex_init(&signalBBegin, NULL);  pthread_mutex_lock(&signalBBegin);
    pthread_mutex_init(&signalBEnd, NULL);    pthread_mutex_lock(&signalBEnd);
    pthread_mutex_init(&mSignal, NULL); 
    //Create helper thread for data

    pthread_create( &dataThrdA, NULL, dataThreadA, NULL); 
    pthread_create( &dataThrdB, NULL, dataThreadB, NULL); 
  }

  //Initialize & start secondary 'B' thread
  pthread_t thrdB;
  pthread_create( &thrdB, NULL, threadB, NULL);  

  //Initialize A's data
//  if (!fast) for (int t=0;t<NUMDATA;t++) { for (int i=0;i<DATASIZE;i++) { dataA[t][i] = rand() % 256; } }
  
  //Start execution of thread 'A'
//  for (int i=0;i<REPS;i++) {
//    fast ? sendMsg(signalABegin,signalAEnd) : doWorkA();
 //   fast ? sendMsg(signalABegin,signalAEnd) : doWorkB();
//    fast ? sendMsg(signalABegin,signalAEnd) : doWorkA();
//  }

  //Wait until thread B finishes, and quit
  pthread_join( thrdB, NULL );
  if (fast)  pthread_cancel( dataThrd );
  return 0;
}

void *threadB( void *ptr )
{
  //Initialize B's data
  if (!fast) for (int t=0;t<NUMDATA;t++) { for (int i=0;i<DATASIZE;i++) { dataB[t][i] = rand() % 256; } }
  
  for (int i=0;i<REPS;i++) {
    fast ? sendMsg(signalABegin,signalAEnd) : doWorkA();
    fast ? sendMsg(signalBBegin,signalBEnd) : doWorkB();
//    fast ? sendMsg(signalBBegin,signalBEnd) : doWorkB();

  }
  return 0;
}




