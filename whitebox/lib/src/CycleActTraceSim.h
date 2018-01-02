#pragma once
#define NDEBUG
#define BOOST_CB_DISABLE_DEBUG // The Debug Support has to be disabled, otherwise the code produces a runtime error.

#include <fstream>
#include <algorithm>
#include <iostream>
#include <boost/circular_buffer.hpp>
#include <stdlib.h>
#include "funcinfo.h"
#include <array>
#include "power.h"
using namespace std;
#ifdef DEBUG_SIM
typedef array<uint32_t, 5> operator_t;  //[4] -> transaction id
#else
typedef array<uint32_t, 4> operator_t;  //[0,1,2,3] -> rtlid, a,b,s
#endif

class RowEntry {
public:
  RowEntry(int c_step, int rename_c_step)
    : c_step(c_step), rename_c_step(rename_c_step), queries() {
#ifdef __SMALL__
    queries.reserve(32);
#else
    queries.reserve(256);
#endif
  }

  void updateCStep(int new_c_step) {
    c_step = new_c_step;
  }

public:
  int c_step;
  int rename_c_step;
  std::vector<operator_t> queries;
};

typedef boost::circular_buffer<RowEntry> buffer_t;

class CycleActTraceSim {
public:
  static unique_ptr<CycleActTraceSim> simulator;

  friend unique_ptr<CycleActTraceSim>
  buildTraceSim(unique_ptr<FuncInfo> &func_info);

  void initialize(std::string filename)
  {
    total_ops = funcInfo->max_ops+1;
    if(filename!="")
    {
      fout=new ofstream(filename,ios_base::out);
    }
    else
    {
      fout=nullptr;
    }
    //cout<<total_ops<<"\n";
    curr.resize(total_ops);
    prev.resize(total_ops);
  }
  void setHead(int i) {
    head = i;
    commit();
    head = 0;
  }

  int computePathID() {
    int path_id = 0;
    auto path_depth = bbid_history.size();
    auto start = bbid_history.begin();
    for (int i = 0; i != path_depth; i++) {
      path_id = path_id + (*(start + i)) * (1 << (4 * i));
    }
    if (path_depth - 2 > 0) {
      bbid_history.erase(bbid_history.begin(),
        bbid_history.begin() + (path_depth - 2));
    }
    //TODO end of execution, we need to delet all items..
    return path_id;
  }

  void updateHeadCstep() {
    headCStep = buffer[head].c_step;
  }

  void bbBegin(int id) {
    prevBBID = curBBID;
    curBBID = id;
    // loop check
    prvLoopInfo = curLoopInfo;
    curLoopInfo = funcInfo->bbIDtoLoopMap[id];
    // head updates
    if (curLoopInfo != nullptr) {
      //bodyID=*(curLoopInfo->bodyIDs.begin());
      if (curLoopInfo->isLoopHeader(id)) {
        if (curLoopInfo == prvLoopInfo) {
          bbid_history.push_back(curBBID);
          setHead(head + (curLoopInfo->interval));
        }
        else {
          //is loop begin?
          bbid_history.push_back(curBBID);
          setHead(buffer.size());
        }
      }
      else {
        bbid_history.push_back(curBBID);
      }
    }
    else {
      if (*(funcInfo->bbCStepInfo[id].begin()) == lastCStep) {
        bbid_history.push_back(curBBID);
        setHead(buffer.size() - 1);
      }
      else {
        bbid_history.push_back(curBBID);
        setHead(buffer.size());
      }
    }

    // Add c_step links
    if (curLoopInfo != nullptr) {
      // is header ?
      bool loopHeader = (curLoopInfo->isLoopHeader(id));
      addCStepLoop(funcInfo->bbCStepInfo[id]
                   , curLoopInfo->interval
                   , curLoopInfo->renamedCstepBase
                   , loopHeader);
    }
    else {
      //add fsm
      addCStepForBB(funcInfo->bbCStepInfo[id]);
    }
    updateHeadCstep();
  }

  void commit() {
    if (head == 0)
      return;
    computePower(prevBBID, computePathID(), head);
    buffer.erase(buffer.begin(), buffer.begin() + head);
  }
  void computePower(int bbid, int path_id, int size)
  {
    vector<int>  rename_c_step_buffer(size);
    if(size==0)
      return;
    if(hamming_distance.size() < size)
    {
      hamming_distance.resize(size);
      for(auto& i : hamming_distance)
      {
        i.resize(total_ops*3);
      }
    }
    for(int j=0; j!=size; j++)
    {
      rename_c_step_buffer[j]=buffer[j].rename_c_step;
      for(auto& i : buffer[j].queries)
      {
        int opid=i[0];
        curr[opid]=std::move(array<uint32_t,3>({{i[1],i[2],i[3]}}));
      }
      for(int k=0,ek=curr.size(); k!=ek; k++)
      {
        auto h=hamming(curr[k],prev[k]);
        hamming_distance[j][k*3+0]=static_cast<uint8_t>(h[0]);
        hamming_distance[j][k*3+1]=static_cast<uint8_t>(h[1]);
        hamming_distance[j][k*3+2]=static_cast<uint8_t>(h[2]);
      }
      prev=curr;
    }
#ifdef _ACTIVITY_MODEL_
    activity_log(fout
                 , size, bbid, path_id, rename_c_step_buffer, hamming_distance);
#else
    power_log(fout, size, bbid, path_id, rename_c_step_buffer, hamming_distance);
#endif

  }

  void bbEnd() {
  }

  void trace(
    int cstep
    , uint32_t opid
    , uint32_t rtlid
    , uint32_t opA
    , uint32_t opB
    , uint32_t opC
  ) {
#ifdef DEBUG_SIM
    operator_t a={rtlid,opA,opB,opC,opid};
#else
    operator_t a={rtlid, opA, opB, opC};
#endif
    int hint = head + (cstep - headCStep);
    buffer[hint].queries
      .emplace_back(std::move(a));
  }

  CycleActTraceSim()
    : curBBID(0)
      , lastCStep(-1)
      , curLoopInfo(nullptr)
      , prvLoopInfo(nullptr)
      , curCSteps(nullptr)
      , bbid_history(4) {
    head = 0;
    buffer = buffer_t(40);
  }

  ~CycleActTraceSim() {
    head = buffer.size();
    bbid_history.push_back(curBBID);
    computePower(curBBID, computePathID(), head);
    head = 0;
    buffer.erase(buffer.begin(), buffer.begin() + head);
    if(fout !=nullptr)
      fout->close();
  }

  void addCStepForBB(const set<int> &csteps) {
    auto ptr = csteps.begin();
    if (*ptr == lastCStep) {
      ptr++;
    }
    for (auto e = csteps.end(); ptr != e; ptr++) {
      int i = *ptr;
      buffer.push_back(RowEntry(i, funcInfo->renameTable[i]));
    }
    lastCStep = *csteps.rbegin();
  }

  void addCStepLoop(const set<int> &csteps, int ii, int base, bool header) {
    auto buffer_size = buffer.size();
    int ptr = 0;
    if (header) {
      ptr = head;
    }
    else {
      ptr = ((*csteps.begin()) - buffer[head].c_step) + head;
    }
    int re = 0;
    for (auto &i : csteps) {
      if (buffer_size <= ptr) {
        buffer.push_back(RowEntry(i, re + base));
      }
      else {
        buffer[ptr].updateCStep(i);
      }
      re = (re + 1) % ii;
      ptr++;
    }
    lastCStep = *csteps.rbegin();
  }

  int curBBID;
  int lastCStep;
  LoopInfo* curLoopInfo;
  LoopInfo* prvLoopInfo;
  set<int>* curCSteps;
  unique_ptr<FuncInfo> funcInfo;
  buffer_t buffer;
  int head;
  int headCStep;
  int prevBBID;
  boost::circular_buffer<int> bbid_history;
  vector<array<uint32_t,3> >    curr;
  vector<array<uint32_t,3> >    prev;
  vector<vector<uint8_t> >      hamming_distance;

  int total_ops;
  ofstream* fout;
};


