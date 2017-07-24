#include <iostream>
#include <stdio.h>

short sqrt_t[]={0,
  128,
  181,
  221,
  256,
  286,
  313,
  338,

  0,
  362,
  512,
  627,
  724,
  809,
  886,
  957,

  0,
  1024,
  1448,
  1773,
  2048,
  2289,
  2508,
  2709,

  0,
  2048,
  2896,
  3547,
  4096,
  4579,
  5016,
  5418};
short exp_t[]={
  8192,
  7695,
  7229,
  6791,
  6379,
  5993,
  5630,
  5289,
  4968,
  4667,
  4384,
  4119,
  3869,
  3635,
  3414,
  3208,
  3013,
  2831,
  2659,
  2498,
  2347,
  2204,
  2071,
  1945,
  1827,
  1717,
  1613,
  1515,
  1423,
  1337,
  1256,
  1180,
  1108,
  1041,
  978,
  919,
  863,
  811,
  761,
  715,
  672,
  631,
  593,
  557,
  523,
  491,
  462,
  434,
  407,
  383,
  359,
  338,
  317,
  298,
  280,
  263,
  247,
  232,
  218,
  205,
  192,
  180,
  170,
  159};
#include <sys/time.h> 

#define MIN(A,B) ((A>B) ? B : A)
#define ROW 8
#define COL 8
#include "trace.h"
extern "C" void computeWeightRGB_fxp(short ret[ROW][COL], short R[ROW][COL],short G[ROW][COL], short B[ROW][COL], short tmp[ROW][COL], short sqrt_t[64], short exp_t[64],short row, short col);

using namespace std;
#include <iostream>
#include <vector>
#include <map>
int main(int argc, char** argv)
{
#ifdef SMALL_HOUSE
  FILE* input=fopen("small_house_data","r");
#define IMAGE_HEIGHT 100
#define IMAGE_WIDTH  150
#endif
#ifdef SMALL_CHURCH
  FILE* input=fopen("small_church_data","r");
#define IMAGE_HEIGHT 100
#define IMAGE_WIDTH  200
#endif
  if(input ==0)
  {
    return 0;
  }
  int tot_run=0;
  short R[ROW][COL];
  short G[ROW][COL];
  short B[ROW][COL];
  short ret[ROW][COL];
  short refret[ROW][COL];
  short tmp[ROW][COL];
  int r,g,b;
  int rt;
  unique_ptr<FuncInfo> finfo=buildFuncInfo("bbInfo.txt",argv[1],"pipeline.txt");
  TraceSim::simulator=std::move(buildTraceSim(finfo,argv[2]));
#ifdef _INV_MODEL_
  set_operators(14); // mamually annotate it 
#endif
  struct timeval t1, t2;
  double elapsedTime;
  gettimeofday(&t1, NULL);
  for(int m=0; m<4; m++){
    for(int i=0; i<IMAGE_HEIGHT; i+=8)
    {
      for(int j=0; j<IMAGE_WIDTH; j+=8)
      {
        for(int k=0; k<(ROW); k++)
        {
          for(int l=0;l<(COL ); l++)
          {
            fscanf(input, "%d,%d,%d,%d\n", &r,&g,&b,&rt);
            R[k][l]=r;
            G[k][l]=g;
            B[k][l]=b;
            refret[k][l]=rt;
          }
        }
        int k_min=MIN(ROW,IMAGE_HEIGHT-i);
        int l_min=MIN(COL,IMAGE_WIDTH-j);
        computeWeightRGB_fxp(ret, R,G,B,tmp,sqrt_t,exp_t,k_min,l_min);
#ifdef _INV_MODEL_
    // place for end of inv
    inv_end();
#endif
        tot_run++;
#ifdef TEST_VECTOR
        if(tot_run>=TEST_VECTOR)
        {
          fclose(input);
          return 0;
        }
#endif
#ifdef __DEBUG__
        for(int k=0; k<(ROW); k++)
        {
          for(int l=0;l<(COL ); l++)
          {
            if(refret[k][l]!=ret[k][l])
            {
              std::cout<<"err: "<<k<<" "<<l<<" "<<ret[k][l]<<" "<<refret[k][l]<<std::endl;
            }
          }
        }
#endif
      }
    }
  }
  fclose(input);
  gettimeofday(&t2, NULL);
  elapsedTime = (t2.tv_sec - t1.tv_sec) * 1000.0;      // sec to ms
  elapsedTime += (t2.tv_usec - t1.tv_usec) / 1000.0;   // us to ms
  std::cout << elapsedTime << " ms.\n";
  return 0;
}
