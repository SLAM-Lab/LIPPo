#include <sstream>
#include <iostream>
#include "opinfo.h"
#include "parse.h"
using namespace std;

vector<OpInfo>* readOpInfoFile(const char* opFileName, string& 
    topfunctionname)
{
  ifstream opinfo;
  string line;
  vector<OpInfo>* ret=new vector<OpInfo>();
  opinfo.open(opFileName);
  
  if(opinfo.is_open()==false)
  {
    cerr<<"Not exist "<<opFileName<<"\n";
    return nullptr;
  }
  getline(opinfo, line); // remove function name
  topfunctionname=line.substr(0,line.size()); // remove \n
  cout<<topfunctionname<<"\n";
  int opid=0;
  while(getline(opinfo,line).eof()==false)
  {
    string sep("\\|");
    vector<string> buffer;
    parser(line, sep, buffer);
//   if(buffer.size()==3)
//   {
//     int rtlid=stoi(buffer[1]);
//     int cstep=stoi(buffer[2]);
//     string code=buffer[0];
//     ret->emplace_back(opid, rtlid, cstep,
//         -1, code,1);
//   }
    if(buffer.size()==4)
    {
      int rtlid=stoi(buffer[1]);
      int cstep=stoi(buffer[2]);
      int bbid=stoi(buffer[3]);
      string code=buffer[0];
//      ret->emplace_back(opid, rtlid, cstep,
//          bbid, code,1);
      ret->emplace_back(opid, rtlid, cstep,
          bbid, code);
    }
    else
    {
      cout<<"Parsing error!!\n";
    }
//   if(buffer.size()==5)
//   {
//     int rtlid=stoi(buffer[1]);
//     int cstep=stoi(buffer[2]);
//     int bbid=stoi(buffer[3]);
//     int pwr=stoi(buffer[4]);
//     string code=buffer[0];
//     ret->emplace_back(opid, rtlid, cstep,
//         bbid,code, pwr);
//   }
    opid++;
  }
  return ret;
}

vector<RTLOpInfo>* readRTLOpInfoFile(const char* opFileName)
{
  ifstream opinfo;
  string line;
  vector<RTLOpInfo>* ret=new vector<RTLOpInfo>();
  opinfo.open(opFileName);
  
  if(opinfo.is_open()==false)
  {
    cerr<<"Not exist "<<opFileName<<"\n";
    return nullptr;
  }
  //getline(opinfo, line); // remove function name
  int rtlid=0;
  while(getline(opinfo,line).eof()==false)
  {
    rtlid++;
    string sep(" ");
    vector<string> buffer;
    parser(line, sep, buffer);
    ret->emplace_back(rtlid);
    for(int i=1,e=buffer.size(); i!=e;i++)
    {
      ret->rbegin()->bitWidth.push_back(
          stoi(buffer[i]));
    }
  }
  return ret;
}

vector<BBInfo>* readBBInfoFile(const char* bFileName)
{
  ifstream opinfo;
  string line;
  vector<BBInfo>* ret=new vector<BBInfo>();
  opinfo.open(bFileName);
  
  if(opinfo.is_open()==false)
  {
    cerr<<"Not exist "<<bFileName<<"\n";
    return nullptr;
  }
  //getline(opinfo, line); // remove function name
  while(getline(opinfo,line).eof()==false)
  {
    string sep("\\|");
    vector<string> buffer;
    parser(line, sep, buffer);
//   cerr<<line<<"\n";
//   cerr<<buffer[0]<<"\n";
//   for (auto & k : buffer)
//   {
//     cerr<<k<<"\n";
//   }
    ret->emplace_back(stoi(buffer[0]),buffer[2],buffer[3]);
  }
  return ret;

}

int test_readOpInfo(char** argv)
{
  string dump;
  auto k= readOpInfoFile(argv[1],dump);
  for (auto i : *k)
  {
    cout<<i.bbid<<"\n";
  }
  return 1;
}
// int main(int argc, char** argv)
// {
//   test_readOpInfo(argv);
// }
