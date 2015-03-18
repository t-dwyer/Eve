#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>

  int
main( int argc, char* argv[])
{
  int blocks = 10;
  pthread_mutex_t sigs[blocks];

  for (int i=0;i<blocks;i++) {  pthread_mutex_init(&sigs[i], NULL); pthread_mutex_lock(&sigs[i]); }
  
  int data = 0;
  while(true) {
    if (pthread_mutex_trylock(&sigs[0])) {
      data++;
    }
    if (pthread_mutex_trylock(&sigs[1])) { 
      data--;
    } 
    if (pthread_mutex_trylock(&sigs[2])) {
      data += 2;
    }
    if (pthread_mutex_trylock(&sigs[3])) {
      data -= 2;
    }
  }


  return 0;
}




