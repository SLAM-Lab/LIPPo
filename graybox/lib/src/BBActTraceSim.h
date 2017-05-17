#pragma once
#define NDEBUG

#define BOOST_CB_DISABLE_DEBUG // The Debug Support has to be disabled, otherwise the code produces a runtime error.
#include <fstream>
#include <algorithm>
#include <iostream>
#include <boost/circular_buffer.hpp>
#include <stdlib.h>
#include "funcinfo.h"
#include "power.h"
#include <array>

#ifndef DEPTH
#define DEPTH 7
#endif
#ifndef PATH_KEY
#define PATH_KEY 3
#endif
#ifndef ACT_DEPTH
#define ACT_DEPTH 3
#endif

using namespace std;
#define OPSIZE 1
typedef std::array<uint32_t, OPSIZE> operator_t;
typedef vector<boost::circular_buffer<operator_t> > buffer_t;

class cstep_info
{
  public:
    cstep_info(int cstep, int rename_cstep)
      :cstep(cstep),rename_cstep(rename_cstep),bbid_list(5)
    {

    }
    void updateCstep(int _bbid, int _cstep)
    {
      cstep=_cstep;
    }
    int cstep;
    int rename_cstep;
    boost::circular_buffer<char> bbid_list;
};

typedef boost::circular_buffer<cstep_info> cstep_buffer_t;

class BBActTraceSim
{
  public:
    static unique_ptr<BBActTraceSim> simulator;
    friend unique_ptr<BBActTraceSim> buildTraceSim(unique_ptr<FuncInfo>& finfo);
    void setHead(int i) {
      head=i;
      commit();
      head=0;
    }
    void initialize(string filename)
    {
      tot_rop=funcInfo->max_ops+1;
      curr.resize(tot_rop);
      prev.resize(tot_rop);
//      hamming_distance(top_rop*3*)
      buffer.resize(tot_rop);
      if(filename !="")
        fout = new ofstream(filename, ios_base::out);
      else
        fout = nullptr;
      path_id_history.resize(ACT_DEPTH);
#ifndef _ACTIVITY_MODEL_
      activity_headers.resize(ACT_DEPTH);
      hamming_distance.set_capacity(512);
#else
      activity_headers.resize(1);
      hamming_distance.set_capacity(512);
#endif
    }
    void updateHeadCstep()
    {
      headCstep=cstep_buffer[head].cstep;
    }
    int computePathID()
    {
      //TODO end of execution, we need to delet all items..
      int path_id =curBBID;
      int j=1;
      for(auto& i : cstep_buffer.begin()->bbid_list)
      {
        path_id = path_id + (i * (1<<(PATH_KEY*j)));
        j++;
      }
      return (path_id & 0x3fffffff);
    }

    void bbBegin(int id)
    {
      prevBBID=curBBID;
      curBBID=id;
      // loop check
      prvLoopInfo=curLoopInfo;
      curLoopInfo=funcInfo->bbIDtoLoopMap[id];
      // head updates
      if(curLoopInfo!=nullptr)
      {
        //bodyID=*(curLoopInfo->bodyIDs.begin());
        if(curLoopInfo->isLoopHeader(id))
        {
          if(curLoopInfo==prvLoopInfo)
          {
            setHead(head+(curLoopInfo->interval));
          }
          else
          {
          //is loop begin?
            setHead(cstep_buffer.size());
          }
        }
        else
        {
        }
      }
      else
      {
        if(*(funcInfo->bbCStepInfo[id].begin()) == lastCstep)
        {
          setHead(cstep_buffer.size()-1);
        }
        else
        {
          setHead(cstep_buffer.size());
        }
      }
      // loop check

      // Add cstep links
      if(curLoopInfo!=nullptr) 
      {
        // is header ?
        bool loopHeader=(curLoopInfo->isLoopHeader(id));
        addCStepLoop(funcInfo->bbCStepInfo[id], curLoopInfo->interval,
            curLoopInfo->renamedCstepBase, loopHeader);
      }
      else
      {
        //add fsm
        addCStepForBB(funcInfo->bbCStepInfo[id]);
      }
      updateHeadCstep();
    }
    void commit()
    {
      if(head==0)
        return;
      /*  //cout<<prevBBID<<"\n";
      for(auto  i = cstep_buffer.begin(), e=cstep_buffer.end(); i!=e; i++) 
      {
        cout<<i->cstep<<" "<<i->rename_cstep<<" : ";
        for(auto& j : i->bbid_list)
        {
          cout<<" "<<int(j);
        }
        cout<<"\n";
      }*/
      computePower(prevBBID,computePathID(),head);
      cstep_buffer.erase(cstep_buffer.begin(), cstep_buffer.begin()+head);
    }
    void bbEnd()
    {
      for(auto& i : cstep_buffer)
      {
        i.bbid_list.push_back(curBBID);
      }
    }

    void trace(int cstep, uint32_t opid, uint32_t rtlid, uint32_t opA, uint32_t opB, uint32_t opC)
    {
      assert(false);
     // operator_t a={opA,opB,opC};
     // buffer[rtlid].push_back(std::move(a));
    }
    void trace_ls(int rtlid, uint32_t op)
    {
      operator_t a={op};
      buffer[rtlid].push_back(std::move(a));
    }
    BBActTraceSim()
      :curBBID(0),lastCstep(-1),curLoopInfo(nullptr),prvLoopInfo(nullptr),curCSteps(nullptr),
      buffer(32)
    {
      head=0;
      cstep_buffer=cstep_buffer_t(32);
     //for(int i=0; i<10; i++)
      for(int i=0; i<32;i++)
        buffer[i]=boost::circular_buffer<operator_t>(64);
    }
    ~BBActTraceSim()
    {
      head=cstep_buffer.size();
      computePower(curBBID,computePathID(),head);
      head=0;
      cstep_buffer.erase(cstep_buffer.begin(), cstep_buffer.begin()+head);
      if(fout!=nullptr)
      {
        fout->close();
      }
    }
    void addCStepForBB(const set<int>& csteps)
    {
      auto ptr=csteps.begin();
      if(*ptr==lastCstep)
      {
        cstep_buffer[head];
        ptr++;
      }
      for(auto e=csteps.end();ptr!=e;ptr++)
      {
        int i =*ptr;
        cstep_buffer.push_back(cstep_info(i,funcInfo->renameTable[i]));
      }
      lastCstep=*csteps.rbegin();
    }
    void addCStepLoop(const set<int>& csteps, int ii, int base, bool header)
    {
      int buffer_size=cstep_buffer.size();
      int ptr=0;
      if(header)
      {
        ptr=head;
      }
      else
      {
        ptr=((*csteps.begin())-cstep_buffer[head].cstep)+head;
      }
      int re=0;
      for(auto& i : csteps)
      {
        if(buffer_size<=ptr)
        {
          cstep_buffer.push_back(cstep_info(i,re+base));
        }
        else
        {
          cstep_buffer[ptr].cstep=i;
        }
        re=(re+1)%ii;
        ptr++;
      }
      lastCstep=*csteps.rbegin();
    }
//#ifdef BB_CONTROL_DECOMP 
    void computePower(int bbid, int path_id, int cycles)
    {
      int rtlid=0;
      int idx=0;
      // remove previous hamming (FIFO)
      for(int i=0; i<activity_headers[0]; i++)
      {
        hamming_distance.pop_front();
      }
      for (auto& traces : buffer)
      {
        for (int i=0,e=traces.size();i!=e;i++)
        {
          curr[rtlid]=traces.front();
          auto h=hamming(curr[rtlid],prev[rtlid]);
          for(auto& hd : h)
          {
            hamming_distance.push_back(hd);
            idx++;
          }
          prev[rtlid]=curr[rtlid];
          traces.pop_front();
        }
        rtlid++;
      }
      activity_headers.push_back(idx);
      int bb_key=path_id;
      path_id_history.push_back(path_id);
      for(int i=0; i<ACT_DEPTH; i++)
      {
        bb_key+=path_id_history[i];
      }
#ifdef _ACTIVITY_MODEL_
      activity_log(fout, bbid, bb_key, cycles, hamming_distance);
#else
      power_log(fout, bbid, bb_key, cycles, hamming_distance);
#endif
    }
//#endif 
    int curBBID;
    int lastCstep;
    LoopInfo*               curLoopInfo;
    LoopInfo*               prvLoopInfo;
    set<int>*                     curCSteps;
    unique_ptr<FuncInfo>          funcInfo;
    cstep_buffer_t                cstep_buffer;
    int            head;
    int            headCstep;
    int prevBBID;
    buffer_t      buffer;
    ofstream* fout;
    vector<operator_t >    curr;
    vector<operator_t >    prev;
    boost::circular_buffer<uint8_t>        hamming_distance;
    boost::circular_buffer<int>            activity_headers;
    boost::circular_buffer<int>            path_id_history;
    int tot_rop;
};


