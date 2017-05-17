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
#define BOOST_CB_DISABLE_DEBUG // The Debug Support has to be disabled, otherwise the code produces a runtime error.
#include <boost/circular_buffer.hpp>
using namespace std;
inline
void FileOut(vector<double>& v, string name, int id)
{

  vector<double> data; 
  data.swap(v);
  ofstream os(name+to_string(id)+string(".txt"),std::ofstream::trunc);
  if(os.is_open()==true)
  {
#if 1
    for(auto& i : data)
    {
      os<<i<<"\n";
    }
    os.close();
#else
   //double sum=0;
   //for(auto& i : data)
   //{
   //  sum+=i;
   //}
   //os<<sum<<"\n";
   os.close();
#endif
  }
  else
  {
    cerr<<"Cannot write power_out_"<<id<<"\n";
    exit(2);
  }
}

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
#ifdef BB_CONTROL_DECOMP
inline
void activity_log(
  ofstream* fout,
  int bbid,
  int bb_key,
  int cycles,
  boost::circular_buffer<uint8_t> & hamming_distance
)
{
  *fout<<bbid<<","<<bb_key<<","<<cycles;
  for(int i=0,e=hamming_distance.size(); i<e; i++)
  {
    *fout<<","<<int(hamming_distance[i]);
  }
  *fout<<"\n";
}
#else
inline
void activity_log(
  ofstream* fout,
  int bbid,
  int bb_key,
  int cycles,
  boost::circular_buffer<uint8_t> & hamming_distance
)
{
  *fout<<bbid<<","<<bb_key<<","<<cycles;
  for(int i=0,e=hamming_distance.size(); i<e; i++)
  {
    *fout<<","<<int(hamming_distance[i]);
  }
  *fout<<"\n";
}
#endif

#ifndef _ACTIVITY_MODEL_
extern int len_row;
void power_log(
  ofstream* fout,
  int bbid,
  int bb_key,
  int cycles,
  boost::circular_buffer<uint8_t> & hamming_distance
  );
#endif
