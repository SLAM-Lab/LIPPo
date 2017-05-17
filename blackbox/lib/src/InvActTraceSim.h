#pragma once
#include <memory>
#include <fstream>
#include <vector>
#include <iostream>
#include "funcinfo.h"
extern const char htable[256];
double predict(uint8_t* data);
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
unsigned ham(unsigned a, unsigned b)
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
class InvActTraceSim
{
public:
  static std::unique_ptr<InvActTraceSim> simulator;

  friend std::unique_ptr<InvActTraceSim>
  buildTraceSim(std::unique_ptr<FuncInfo> &func_info);
	InvActTraceSim()
	: fout(nullptr), inv_counter(0), acc(0)
	{
	}
	void initialize(std::string filename)
	{
    if(filename != "")
  		fout=new std::ofstream(filename);	
    else
      fout=nullptr;
		
	}
	~InvActTraceSim()
	{
    if(fout!=nullptr)
  		fout->close();
	}
	void set_operators(int n)
	{
		curr_ops.resize(n);
		for(int i=0; i<n; i++)
		{
			curr_ops[i]=0;
			htrace.reserve(1024);
		}
	}
  /*
	void inv_begin()
	{
		
	}*/
  int get_op(int rsc_id) { return curr_ops[rsc_id];}
	void trace(int rsc_id, int data, int mask)
	{
	  auto masked_data=mask & data;
		htrace.push_back(ham(masked_data, curr_ops[rsc_id]));
		curr_ops[rsc_id]=masked_data;
	}
  void trace_ls(int rtlid, int opS)
  {
		htrace.push_back(ham(opS, curr_ops[rtlid]));
		curr_ops[rtlid]=opS;
  }
	void trace_ctrl(unsigned char data)
	{
		htrace.push_back(data);
	}
	void inv_end()
	{
#ifdef _ACTIVITY_MODEL_
		*fout<<inv_counter;
		for(auto& i : htrace)
		{
			*fout<<","<<static_cast<int>(i);
		}
		*fout<<"\n";
		inv_counter++;
#else 
    if(fout!=nullptr)
      *fout<<predict(htrace.data())<<"\n";
    else
      acc+=predict(htrace.data());
#endif
		htrace.erase(htrace.begin(),htrace.end());
	}
	std::vector<unsigned char > htrace; 
	std::vector<int>  curr_ops;
	std::ofstream* fout;
	int inv_counter;
  double acc;
};
