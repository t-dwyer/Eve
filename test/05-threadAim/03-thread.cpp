#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <iostream>

pthread_mutex_t mutex;
void *thread( void *ptr );

int globalVar[10000];

int
main()
{
     pthread_t thread1, thread2;

     pthread_mutex_init(&mutex, NULL);

     pthread_create( &thread1, NULL, thread, NULL);
     pthread_create( &thread2, NULL, thread, NULL);
     pthread_join( thread1, NULL);
     pthread_join( thread2, NULL); 
    
  return 0;
}

void *thread( void *ptr )
{
  int localVar[10000];
  
  //Fill Cache with global variable
  pthread_mutex_lock(&mutex);
  for (int i=0;i<10000;i++) {
    globalVar[i] = 0;
  }
  pthread_mutex_unlock(&mutex);

  //Fill cache with local variable
  for (int j=0;j<10000;j++) {
    localVar[j] = 0;
  }

  return 0;
}
