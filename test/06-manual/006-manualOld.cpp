#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <iostream>
#include <vector>
#define DATASIZE (6*1024*1024)

struct Signal {
  int ID;
  pthread_mutex_t begin;
  pthread_mutex_t end;

  std::vector<Signal> preds;
  std::vector<Signal> succs;
};

//EVE's signalling mutex's
pthread_mutex_t mSignal;
std::vector<Signal> sig_vector;

Signal createSignal(int ID) {
  pthread_mutex_t sig_begin;
  pthread_mutex_init(&sig_begin, NULL);
  pthread_mutex_lock(&sig_begin);

  pthread_mutex_t sig_end;
  pthread_mutex_init(&sig_end, NULL);
  pthread_mutex_lock(&sig_end);
  
  Signal sig;
  sig.ID = ID;
  sig.begin = sig_begin;
  sig.end = sig_end;

  return sig;
}


//Helper function for sending control messages 
void sendMsg(Signal sig){
  pthread_mutex_lock(&mSignal);   //Ensure only 1 signal per data value
  pthread_mutex_unlock(&sig.begin);   //Tell data thread to start
  pthread_mutex_lock(&sig.end);    //Wait for data thread to finish
  pthread_mutex_unlock(&mSignal); //Release hold on signal
}

//Thread that handles data
void *threadEve_Data( void *ptr )
{   
  //Declare data locally
  char sharedData;
 
  //Continually check for work to do 
  while (true) { 
    for (Signal sig : sig_vector) {
      if (pthread_mutex_trylock(&sig.begin) == 0) {
        if (sig.ID == 0) {
          sharedData = 'a';
        } else if (sig.ID == 1) {
          sharedData = (sharedData + rand()) % 256;  
        }
        pthread_mutex_unlock(&sig.end);
        sendMsg(sig.succs.front());
      }
    } 
  }
  return 0;
}

  int
main( int argc, char* argv[])
{
  //Create EVE Control systems
  pthread_mutex_init(&mSignal, NULL);
  pthread_t tEveData;
  pthread_create( &tEveData, NULL, threadEve_Data, NULL ); 

  //Create work signals
  Signal s0 = createSignal(0);
  Signal s1 = createSignal(1);

  sig_vector.push_back(s0);
  s0.succs.push_back(s1);

  //Start work
  sendMsg(s0);
  return 0;
}




