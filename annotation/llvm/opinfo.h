#pragma once
#include <string>
#include <vector>
#include <fstream>
using namespace std;



class OpInfo
{
  public:
    // OpInfo(int opid,int rtlid,int cstep,int bbid,string code,int pwr)
    //   : opid(opid),rtlid(rtlid),cstep(cstep),bbid(bbid),code(code),pwr(pwr)
    OpInfo(int opid,int rtlid,int cstep,int bbid,string code)
      : opid(opid),rtlid(rtlid),cstep(cstep),bbid(bbid),code(code)
    {
    }
    const int   opid; 
    const int   rtlid;
    const int   cstep;
    int   bbid;
//    int   pwr;
    const string code;
};
class RTLOpInfo
{
  public:
    RTLOpInfo(int rtlid)
      : rtlid(rtlid)
    {
    }
    int getOperandBitWidth(int i)
    {
      return bitWidth[i];
    }
    int getReturnBitWidth()
    {
      return *bitWidth.rbegin();
    }
    const int rtlid;
    vector<int> bitWidth;
    
};
class BBInfo
{
  public:
    BBInfo(int bbid,string begin_code, string end_code)
      : bbid(bbid),begin_code(begin_code), end_code(end_code)
    {
    }
    int bbid;
    string begin_code;
    string end_code;
};
//void fixRTLBitInfo(const vector<OpInfo>* cinfo, vector<RTLOpInfo>* rinfo); //TODO
vector<RTLOpInfo>* readRTLOpInfoFile(const char* opFileName);
vector<OpInfo>* readOpInfoFile(const char* opFileName, string& topfunctionname);
vector<BBInfo>* readBBInfoFile(const char* bbFileName);
