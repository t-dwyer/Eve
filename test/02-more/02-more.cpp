#include <iostream>
#include <stdio.h>

int main ()
{
    int tmp = 0;
    for (int j=0; j<5; j++) {
           tmp = (tmp * 2) + 3;
    }
  	printf("Result is:%d\n",tmp);
    return tmp;
}
