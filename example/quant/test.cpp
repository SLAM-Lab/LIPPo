#include <stdio.h>
#include "funcinfo.h"
#include "trace.h"
#include <sys/time.h> 
#include <iostream>
extern "C" void quant(short input[64], short output[64], unsigned char y, unsigned char scale);
#include <vector>
#include <map>
using namespace std;
int main(int argc, char** argv)
{
  short input[64];
  short output[64];
#ifdef TRAIN
#define FILENAME "/home/polaris/dlee/working2016/quant/src/roki.in"
#define TOTAL    1200
#else
#define FILENAME "/home/polaris/dlee/working2016/quant/src/lena.in"
#define TOTAL   12288
#endif
  unique_ptr<FuncInfo> finfo=buildFuncInfo("bbInfo.txt",argv[1],"pipeline.txt");
  TraceSim::simulator=std::move(buildTraceSim(finfo,argv[2]));
  struct timeval t1, t2;
  double elapsedTime;
  gettimeofday(&t1, NULL);
  unsigned char qual[3]={1,63,100};
  for(int l=0;l<3; l++)
  {
    FILE* infile=fopen(FILENAME, "r");
    if(infile==NULL)
    {
      fprintf(stderr,"%s is not exist\n",argv[1]);
      return 1;
    }
    for (int i=0; i<TOTAL; i++)
    {
      for(int j=0; j<64; j++)
      {
        fscanf(infile, "%d\n", &input[j]);
      }
      int y=(i%3);
      quant(input,output,y,qual[l]);
    }
    fclose(infile);
  }
  gettimeofday(&t2, NULL);
  elapsedTime = (t2.tv_sec - t1.tv_sec) * 1000.0;      // sec to ms
  elapsedTime += (t2.tv_usec - t1.tv_usec) / 1000.0;   // us to ms
  std::cout << elapsedTime << " ms.\n";
  return 0;
}
