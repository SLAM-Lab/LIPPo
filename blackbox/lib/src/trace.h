#pragma once
#include <memory>
#include "InvActTraceSim.h"
using namespace std;

typedef InvActTraceSim TraceSim;
unique_ptr<TraceSim> buildTraceSim(unique_ptr<FuncInfo>& funcInfo, string pfilename);
extern "C"
{
  void inv_end();
  void set_operators(int i);
  void trace_ctrl(unsigned char data);
}
