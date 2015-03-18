#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <iostream>

#define SINGLETHREAD false
#define MULTITHREAD false
#define EVE true

#define REPS    (1)  
#define DATASIZE (6*1024*1024)
#define THREADS 12
int workDone = 0;
char *sharedData; 

/* Start of MULTI-THREAD Related */
pthread_mutex_t mutexA;

//Work thread
void *thread( void *ptr )
{
  for (int j=0;j<DATASIZE;j++) {
    pthread_mutex_lock(&mutexA);
    int randLoc = rand() % DATASIZE;
    sharedData[randLoc] = (sharedData[randLoc] + 1) % 256;  
    workDone++;
    pthread_mutex_unlock(&mutexA);
  }
  return 0;
}
/* End of MULTI-THREAD Related */


/* Start of EVE Related */
//Initialize signalling mutex's
pthread_mutex_t signalBegin,signalEnd,mSignal;

//Helper function for sending control messages 
void sendMsg(pthread_mutex_t &start, pthread_mutex_t &finish){
  pthread_mutex_lock(&mSignal);   //Ensure only 1 signal per data value
  pthread_mutex_unlock(&start);   //Tell data thread to start
  pthread_mutex_lock(&finish);    //Wait for data thread to finish
  pthread_mutex_unlock(&mSignal); //Release hold on signal
}

//The control/work threads
void *threadEve( void *ptr )
{
  //Send a message to the data thread
  sendMsg(signalBegin,signalEnd); 
  return 0;
}

//Thread that handles data
void *threadEve_Data( void *ptr )
{   
  //Declare data locally
  char *sharedData = new char[DATASIZE];
  for (int i=0;i<DATASIZE;i++) { sharedData[i] = rand() % 256; } 
 
  //Continually check for work to do 
  while (true) { 
    if (pthread_mutex_trylock(&signalBegin) == 0){ //Control signal for this data object

      //Workload
      for (int j=0;j<DATASIZE;j++) {
        int randLoc = rand() % DATASIZE;
        sharedData[randLoc] = (sharedData[randLoc] + 1) % 256;  
        workDone++;
      }

      pthread_mutex_unlock(&signalEnd); //Respond with compleation signal
    } 
  }
  return 0;
}
/* End of EVE Related */


  int
main( int argc, char* argv[])
{
  if (SINGLETHREAD) {
    //Initialize data
    char *sharedData = new char[DATASIZE];
    for (int i=0;i<DATASIZE;i++) { sharedData[i] = rand() % 256; } 

    //Do Work
    for (int i=0;i<THREADS;i++) {
        for (int j=0;j<DATASIZE;j++) {
          int randLoc = rand() % DATASIZE;
          sharedData[randLoc] = (sharedData[randLoc] + 1) % 256;  
          workDone++;
        }
    }
  }

  if (MULTITHREAD) {
    //Initialize shared mutex & data
    pthread_mutex_init(&mutexA, NULL); 
    sharedData = new char[DATASIZE];
    for (int i=0;i<DATASIZE;i++) { sharedData[i] = rand() % 256; } 

    //Initialize & start threads
    pthread_t t[THREADS];
    for (int i=0;i<THREADS;i++) { pthread_create( &t[i], NULL, thread, NULL); } 

    //Wait for everything to finish, then quit
    for (int i=0;i<THREADS;i++) { pthread_join( t[i], NULL); } 
  }

  if (EVE) {
    //Initialize and lock signalling mutex's
    pthread_mutex_init(&signalBegin, NULL);  pthread_mutex_lock(&signalBegin);
    pthread_mutex_init(&signalEnd, NULL);    pthread_mutex_lock(&signalEnd);
    pthread_mutex_init(&mSignal, NULL);

    //Create control/work threads
    pthread_t tEve[THREADS], tEveData;
    for (int i=0;i<THREADS;i++) { pthread_create( &tEve[i], NULL, threadEve, NULL); }
    
    //Create data thread
    pthread_create( &tEveData, NULL, threadEve_Data, NULL ); 

    //Wait for everything to finish, then quit
    for (int i=0;i<THREADS;i++) { pthread_join( tEve[i], NULL);  }
  }

  printf("Workdone: %d", workDone);
  return 0;
}




