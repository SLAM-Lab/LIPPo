#include "testvector.h"
#include "golden.h"
#include <stdio.h>
#include "funcinfo.h"
#include "trace.h"
#include <sys/time.h> 
#include <iostream>
extern "C" void dct(char indata[64], short outdata[64], short tmp[64]);
//#define TEST_VECTOR 300
#ifdef TEST_VECTOR
#undef TOTAL_TEST
#define TOTAL_TEST (TEST_VECTOR*64)
#endif

#include <vector>
#include <map>
using namespace std;
int main(int argc, char** argv)
{
  unique_ptr<FuncInfo> finfo=buildFuncInfo("bbInfo.txt",argv[1],"pipeline.txt");
  TraceSim::simulator=std::move(buildTraceSim(finfo,argv[2]));
#ifdef _INV_MODEL_
  set_operators(8); // mamually annotate it 
#endif
  char indata[64];
  short outdata[64];
  short ref[64];
  short tmp[64];
  struct timeval t1, t2;
  double elapsedTime;
  gettimeofday(&t1, NULL);
  for(int i=0; i<TOTAL_TEST; i+=64)
  {
    //printf("%d\n",i);
    for(int j=0; j<64; j++)
    {
      indata[j]=testvector[i+j];
      ref[j]=golden[i+j];
    }
    //printf("%d\n",i);
#ifdef _INV_MODEL_
    // place for ctrl inputs trace
#endif
    dct(indata, outdata,tmp);
#ifdef _INV_MODEL_
    // place for end of inv
    inv_end();
#endif

#ifdef __DEBUG__
    for(int j=0; j<64; j++)
    {
      if(outdata[j]!=ref[j])
      {
        printf("%d error %d %d\n",i,outdata[j],ref[j]);
      }
    }
#endif
  }
  gettimeofday(&t2, NULL);
  elapsedTime = (t2.tv_sec - t1.tv_sec) * 1000.0;      // sec to ms
  elapsedTime += (t2.tv_usec - t1.tv_usec) / 1000.0;   // us to ms
  std::cout << elapsedTime << " ms.\n";
  return 0;
}
