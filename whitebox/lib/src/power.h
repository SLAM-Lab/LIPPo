#pragma once
#include <algorithm>
#include <vector>
#include <fstream>
#include <iostream>
#include <stdlib.h>
#include <array>
#include <set>
#include <memory>
#include <thread>
#include <sstream>
//#include "table.h"

#include "tree.h"
#include "regression.h"
#include "linear.h"
#include "gradientboost.h"
using namespace std;

extern const char htable[256];
  inline
int countOne(int a)
{
#if 1
  int i0 = (a>>24)&0xff;
  int i1 = (a>>16)&0xff;
  int i2 = (a>>8)&0xff;
  int i3 = (a)&0xff;
  return (htable[i0]+htable[i1]+htable[i2]+htable[i3]);
#else
  int ret=0;
  unsigned int item=0xffffffff&a;
  for(int i=0;i<32;i+=1)
  {
    ret=ret+(item&0x1);
    item>>=1;
  }
  return ret;
#endif
}
inline 
uint32_t ham(uint32_t& a, uint32_t& b)
{
  if(a==b)
  {
    return 0;
  }
  else
  {
    return countOne(a^b);
  }
}
inline
array<uint32_t,3> hamming(array<uint32_t,3>& a, array<uint32_t,3>& b)
{
  array<uint32_t,3> ret;
  for(int i=0,e=3; i!=e;i++)
  {
    if(a[i]==b[i])
      ret[i]=0;
    else
      ret[i]=countOne(a[i]^b[i]);
  }
  return ret;
}
inline
array<uint32_t,1> hamming(array<uint32_t,1>& a, array<uint32_t,1>& b)
{
  array<uint32_t,1> ret;
  for(int i=0,e=1; i!=e;i++)
  {
    if(a[i]==b[i])
      ret[i]=0;
    else
      ret[i]=countOne(a[i]^b[i]);
  }
  return ret;
}
inline
void activity_log(
  ofstream* fout,
  int size,
  int bbid,
  int path_id,
  vector<int>& rename_c_step_buffer,
  vector<vector<uint8_t> >& hamming_distance
)
{
  *fout<<bbid<<","<<path_id<<","<<size<<"\n";
  for(int i=0; i<size; i++)
  {
    *fout<<rename_c_step_buffer[i]<<","<<path_id+i;
    for(auto& hd : hamming_distance[i])
    {
      *fout<<","<<int(hd);
    }
    *fout<<"\n";
  }
}
#ifndef _ACTIVITY_MODEL_
void power_log(
    ofstream* fout,
    int size,
    int bbid,
    int path_id,
    vector<int>& rename_c_step_buffer,
    vector<vector<uint8_t> >& hamming_distance
    );
#endif
