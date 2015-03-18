#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <iostream>


#define REPS    (8)  
#define NUMDATA (1024)
#define DATASIZE (6*1024)

pthread_mutex_t mutexA, mutexB;
int curThread = 0;

char dataA[NUMDATA][DATASIZE];
char dataB[NUMDATA][DATASIZE];

void *slowThreadA( void *ptr );
void *slowThreadB( void *ptr );

void doWorkA() {
    pthread_mutex_lock(&mutexA);
    for (int j=0;j<NUMDATA;j++) 
      for (int i=0;i<DATASIZE;i++) {
        int randA = rand() % NUMDATA;
        int randB = rand() % DATASIZE;
        dataA[randA][randB] = dataA[randA][randB] + rand() % 256; 
      }
    pthread_mutex_unlock(&mutexA);
}

void doWorkB() {
    pthread_mutex_lock(&mutexB);
    for (int j=0;j<NUMDATA;j++) 
      for (int i=0;i<DATASIZE;i++) {
        int randA = rand() % NUMDATA;
        int randB = rand() % DATASIZE;
        dataB[randA][randB] = dataB[randA][randB] + rand() % 256; 
      }
    pthread_mutex_unlock(&mutexB);    
}

  int
main()
{
  //Initialize Mutex's
  pthread_mutex_init(&mutexA, NULL); 
  pthread_mutex_init(&mutexB, NULL); 

  //Initialize Data
  for (int t=0;t<NUMDATA;t++) { 
    for (int i=0;i<DATASIZE;i++) { 
      dataA[t][i] = rand() % 256; 
      dataB[t][i] = rand() % 256;   
    }
  }


  //Initialize & start threads
  pthread_t slowB;
  pthread_create( &slowB, NULL, slowThreadB, NULL);  

  for (int i=0;i<REPS;i++) {
    doWorkA();
    doWorkB();
  }

  pthread_join( slowB, NULL);

  return 0;
}

void *slowThreadB( void *ptr )
{
  for (int i=0;i<REPS;i++) {
    doWorkA();
    doWorkB();
  }
  return 0;
}
