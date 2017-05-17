#pragma once
#include <list>
#include <map>
#include <vector>
#include <set>
#include <fstream>
#include <string>
#include <memory>
#include <iostream>
//#include "util.h"
#include "parse.h"
using namespace std;
class LoopInfo
{
  public:
    LoopInfo(int headerBBID,int tailBBID,int interval,int renamedCstepBase)
    :headerBBID(headerBBID),tailBBID(tailBBID),interval(interval)
    ,renamedCstepBase(renamedCstepBase)
    {

    }
    bool isLoopHeader(int id) {return headerBBID==id;}
    bool isLoopTail(int id) {return tailBBID==id;}
    int headerBBID;
    int tailBBID;
    set<int> bodyIDs;
    set<int> csteps;
    int interval; //II
    int renamedCstepBase;
};
class FuncInfo
{
  friend unique_ptr<FuncInfo> buildFuncInfo(
    const char* bbFileName,
    const char* opFilaName,
    const char* loopFileName
  );
  private:
    FuncInfo(
      const char* bbFileName,
      const char* opFilaName,
      const char* loopFileName);
  public:
    vector< set<int> >              bbCStepInfo;//    BBCStepInfo[BBID]=list{csteps}
    vector< map<int, set<int> > >   schedule;   //    Schedule[BBID][Cstep] = set[op]
    vector< set<int> >              cstepOPs;   //    Op
    set<int>                        basicblocks;
    set<int>                        csteps;
    set<int>                        ops;
    vector<LoopInfo>                loopinfo;
    bool                            renamed;
    vector<int>                     renameTable;
    vector<LoopInfo*>               bbIDtoLoopMap;
    vector< set<int> >              renamedCStepOPs;
    vector<int>                     bbCommit;
    int max_ops;

  private:
    void readBBInfoFile(const char* bbFile);
    void readOpInfoFile(const char* opFile);
    void readLoopInfoFile(const char* loopFile);
    void build();

    void addBBID(int bbid);
    void addCStep(int cstep );
    void addOp(int opid);
    void addSchedule(int bbid, int cstep, int opid);
    bool filler(set<int>& container);
};
string to_string(const FuncInfo& item);
string to_string(const LoopInfo& item);
unique_ptr<FuncInfo> buildFuncInfo(
  const char* bbFileName,
  const char* opFilaName,
  const char* loopFileName
);
