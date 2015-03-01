#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <iostream>

#define BUFSIZE   (2*1024*1024)
#define GLOBALSIZE (8*1024*1024)
#define LINESIZE 64
#define REPS 32
#define THREADS 12
/* Pointers to buffers */

char *MainBuffer = NULL;
char *GlobalBuffer = NULL;

pthread_mutex_t mutex;
void *thread( void *ptr );

  int
main()
{
  pthread_t threads[THREADS];
  pthread_mutex_init(&mutex, NULL);

  for (int i=0;i<THREADS;i++) {
    pthread_create( &threads[i], NULL, thread, NULL);
  }

  for (int i=0;i<THREADS;i++) {
    pthread_join( threads[i], NULL);
  }
  return 0;
}

void *thread( void *ptr )
{
  /* Allocate memory */
  MainBuffer = (char *)malloc(sizeof(char)*BUFSIZE);
  GlobalBuffer = (char *)malloc(sizeof(char)*GLOBALSIZE);

  char work = 0;
  for (int z=0;z<REPS;z++) {
    //Local work
    for(int I = 0; I < BUFSIZE; I++)
      work &= *((char *)MainBuffer+I);

    //Shared work
    pthread_mutex_lock(&mutex);
    for(int I = 0; I < GLOBALSIZE; I++)
      work &= *((char *)GlobalBuffer+I);
    pthread_mutex_unlock(&mutex);
  }
  return 0;
}
