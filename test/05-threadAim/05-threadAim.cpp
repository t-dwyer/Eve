#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <iostream>

#define BUFSIZE   (512*1024)
#define GLOBALSIZE (512*1024)
#define LINESIZE 64
#define REPS (1000)
#define THREADS 1
/* Pointers to buffers */

char *MainBuffer = NULL;
char *GlobalBuffer = NULL;

pthread_mutex_t muSig;
pthread_mutex_t sig;
void *thread( void *ptr );
void *updateGlobalVar( void *ptr);

  int
main()
{
  pthread_mutex_init(&muSig, NULL);
  pthread_mutex_init(&sig, NULL);

  pthread_t threads[THREADS];

  for (int i=0;i<THREADS;i++) {
    pthread_create( &threads[i], NULL, thread, NULL);
  }
  pthread_t newThread;
  pthread_create( &newThread, NULL, updateGlobalVar, NULL );

  for (int i=0;i<THREADS;i++) {
    pthread_join( threads[i], NULL);
  }

  pthread_cancel(newThread); 

  return 0;
}

void *updateGlobalVar( void *ptr) 
{
  //Initialize the required mutex's for this thread 

  GlobalBuffer = (char *)malloc(sizeof(char)*GLOBALSIZE);
  //Continually loop over execution options
  while(true) {

    //First execution option 
    pthread_mutex_lock(&sig);
    pthread_mutex_unlock(&sig);
    char RandChar = rand() % 256;
    memset((void *)GlobalBuffer, RandChar, GLOBALSIZE);
//    char work = 0;
//    for(int I = 0; I < GLOBALSIZE; I++)
//      work &= *((char *)GlobalBuffer+I);
    pthread_mutex_unlock(&muSig);

  } 
}

void *thread( void *ptr )
{
  /* Allocate memory */
  MainBuffer = (char *)malloc(sizeof(char)*BUFSIZE);


  char work = 0;
  for (int z=0;z<REPS;z++) {
    //Local work
    for(int I = 0; I < BUFSIZE; I++)
      work &= *((char *)MainBuffer+I);


    //Shared work
    pthread_mutex_lock(&muSig); // <- Mono-directional signal to updateGlobalVar
    pthread_mutex_unlock(&sig);
    //Remote thread runs
    pthread_mutex_lock(&muSig);
    pthread_mutex_unlock(&muSig);

  }
  return 0;
}


