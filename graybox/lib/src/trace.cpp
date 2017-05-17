#include "trace.h"
#define DEBUG(A) A
//#ifndef BBACT
unique_ptr<BBActTraceSim> BBActTraceSim::simulator;
unique_ptr<TraceSim> buildTraceSim(unique_ptr<FuncInfo>& finfo, string filename)
{
  unique_ptr<TraceSim> ret(new TraceSim());
  //ret->power.init(finfo->max_ops+1, filename);
  ret->funcInfo.swap(finfo);
  ret->initialize(filename);
  return ret;
}
//#else
// //unique_ptr<TraceSim> buildTraceSim(string filename)
// unique_ptr<TraceSim> buildTraceSim(unique_ptr<FuncInfo>& funcInfo, string filename)
// {
//   unique_ptr<TraceSim> ret(new TraceSim());
//   ret->power.init(funcInfo->ops.size(), filename);
//   //ret->power.init(filename);
//   ret->funcInfo.swap(funcInfo);
//   return ret;
// }
// #endif
TraceSim& getTraceSim()
{
  return *(TraceSim::simulator);
}

extern "C"
{
#define OPT
#ifdef _ACTIVITY_MODEL_
  void trace(int rtlid, int cstep, int opid, int opA, int opB, int opS)
  {
    getTraceSim().trace(cstep, opid, rtlid, opA, opB,opS);
  }
#ifndef OPT
  void trace_ls(int rtlid, int opS)
  {
    getTraceSim().trace(0, 0, rtlid, 0, 0,opS);
  }
#else
  void trace_ls(int rtlid, int opS)
  {
    getTraceSim().trace_ls(rtlid,opS);
  }
#endif
#else
// void trace(int rtlid, int c_step, int opid, int opA, int opB, int opS)
// {
//   //OLD version please check !!
//   getTraceSim().trace(c_step, rtlid, update, opA, opB,opS);
// }
  void trace(int rtlid, int c_step, int opid, int opA, int opB, int opS)
  {
    //OLD version
    //getTraceSim().trace(c_step, rtlid, update, opA, opB,opS);
    getTraceSim().trace(c_step, opid, rtlid, opA, opB,opS);
  }
#ifndef OPT
  void trace_ls(int rtlid, int opS)
  {
    getTraceSim().trace(0, 0, rtlid, 0, 0,opS);
  }
#else
  void trace_ls(int rtlid, int opS)
  {
    getTraceSim().trace_ls(rtlid,opS);
  }
#endif
#endif
  void bb_begin(int a)
  {
    //cerr<<"bb: "<<a<<endl;
    getTraceSim().bbBegin(a);
  }
  void bb_end()
  {
    //cerr<<"bb_end"<<endl;
    getTraceSim().bbEnd();
  }
  int _set(int val,int rep, int lo, int hi)
  {
    unsigned int mask=0xffffffff;
    if(lo<=hi)
    {
      //      printf("s: %x %x %x %x \n",val,rep,lo,hi);
      mask>>=(31-(hi-lo));
      mask<<=lo;
      val&=(~mask);
      rep&=(mask>>lo);
      //      printf("s: %x \n",(val|(rep<<lo)));
      return (val | (rep<<lo));

    }
    else
    {
      mask>>=(31-(lo-hi));
      mask<<=hi;
      val&=(~mask);
      rep&=(mask>>hi);
      int ret=0;
      for(int i=0; i<lo-hi+1;i++)
      {
        ret|=((rep>>i) & 0x1);
        if(i<lo-hi)
        {
          ret=(ret<<1);
        }
      }
      //      printf("ss: %x %x %x %x\n", val, rep,lo,hi);
      return ((ret<<hi)|val);
    }

  }
  long long  _set64(long long  val,long long  rep, long long  lo, long long  hi)
  {
    unsigned long long  mask=0xffffffffffffffff;
    if(lo<=hi)
    {
      //      printf("s: %x %x %x %x \n",val,rep,lo,hi);
      mask>>=(63-(hi-lo));
      mask<<=lo;
      val&=(~mask);
      rep&=(mask>>lo);
      //      printf("s: %x \n",(val|(rep<<lo)));
      return (val | (rep<<lo));

    }
    else
    {
      mask>>=(63-(lo-hi));
      mask<<=hi;
      val&=(~mask);
      rep&=(mask>>hi);
      int ret=0;
      for(int i=0; i<lo-hi+1;i++)
      {
        ret|=((rep>>i) & 0x1);
        if(i<lo-hi)
        {
          ret=(ret<<1);
        }
      }
      //      printf("ss: %x %x %x %x\n", val, rep,lo,hi);
      return ((ret<<hi)|val);
    }

  }
  unsigned long long  _select64(long long val, long long lo, long long hi)
  {
    unsigned long long v=val;
    long long mask=-1;
    if(lo<=hi)
    {
      //      printf("s: %x %x %x\n", val, lo,hi);
      v>>=lo;
      mask>>=(63-(hi-lo));
      //      printf("s: %x \n", (v&mask));
      return (v&mask);
    }
    else
    {
      v>>=hi;
      mask>>=(63-(lo-hi));
      v=v& mask;
      unsigned long long ret=0;
      for(int i=0; i<lo-hi+1;i++)
      {
        ret|=((v>>i) & 0x1);
        if(i<lo-hi)
        {
          ret=(ret<<1);
        }
      }
      //      printf("ss: %x %x %x\n", val, lo,hi);
      return ret;
    }
  }
  unsigned int _select(int val, int lo, int hi)
  {
    unsigned int v=val;
    int mask=-1;
    if(lo<=hi)
    {
      //      printf("s: %x %x %x\n", val, lo,hi);
      v>>=lo;
      mask>>=(31-(hi-lo));
      //      printf("s: %x \n", (v&mask));
      return (v&mask);
    }
    else
    {
      v>>=hi;
      mask>>=(31-(lo-hi));
      v=v& mask;
      unsigned int ret=0;
      for(int i=0; i<lo-hi+1;i++)
      {
        ret|=((v>>i) & 0x1);
        if(i<lo-hi)
        {
          ret=(ret<<1);
        }
      }
      //      printf("ss: %x %x %x\n", val, lo,hi);
      return ret;
    }
  }
}
