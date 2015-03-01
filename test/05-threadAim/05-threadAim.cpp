#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <iostream>

#define BUFSIZE   (2*1024*1024)
#define GLOBALSIZE (8*1024*1024)
#define LINESIZE 64
#define REPS 16
#define THREADS 12
/* Pointers to buffers */

char *MainBuffer = NULL;
char *GlobalBuffer = NULL;

pthread_mutex_t mutex;
void *thread( void *ptr );
void *updateGlobalVar( void *ptr);

  int
main()
{
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
  pthread_mutex_init(&mutex, NULL);
  GlobalBuffer = (char *)malloc(sizeof(char)*GLOBALSIZE);
  //Continually loop over execution options
  while(true) {

    //First execution option 
    pthread_mutex_trylock(&mutex);
    char work = 0;
    for(int I = 0; I < GLOBALSIZE; I++)
      work &= *((char *)GlobalBuffer+I);

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
    pthread_mutex_unlock(&mutex); // <- Mono-directional signal to updateGlobalVar
  }
  return 0;
}


