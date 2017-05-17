#include "testvector.h"
#include "golden.h"
#include <stdio.h>
void dct(char indata[64], short outdata[64], short buf[64]);
int main(int argc, char** argv)
{
  char indata[64];
  short outdata[64];
  short buf[64];
  short ref[64];
  for(int i=0; i<TOTAL_TEST; i+=64)
  {
    for(int j=0; j<64; j++)
    {
      indata[j]=testvector[i+j];
      ref[j]=golden[i+j];
    }
    dct(indata, outdata, buf);
    for(int j=0; j<64; j++)
    {
      if(outdata[j]!=ref[j])
      {
        printf("error %d\n",i);
      }
    }
  }
  return 0;
}
