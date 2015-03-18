#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUFSIZE   (2*1024*1024)
#define FLUSHSIZE (8*1024*1024)
#define LINESIZE 64

/* Pointers to buffers */

char *MainBuffer = NULL;
char *FlushBuffer = NULL;

void FlushCache()
{
    char RandChar = rand() % 256;
    memset((void *)FlushBuffer, RandChar, FLUSHSIZE);
}

int main(int Argc, char* Argv[])
{
    char Work;

    /* Allocate memory */
    MainBuffer = (char *)malloc(sizeof(char)*BUFSIZE);
    FlushBuffer = (char *)malloc(sizeof(char)*FLUSHSIZE);


    // Iterate over the MainBuffer
   
    Work = 0;
    for(int I = 0; I < BUFSIZE; I++)
        Work &= *((char *)MainBuffer+I);




    FlushCache();


    // Strided iterate over the MainBuffer
    
    for(int J = 0; J < LINESIZE; J++) 
    {
        for(int I = 0; I < BUFSIZE; I+= LINESIZE)
            Work &= *((char *)MainBuffer+I+J);
    }
    
    
    /* Deallocate memory */

    free(MainBuffer);
    free(FlushBuffer);

    return 0;
}


