#include "funcinfo.h"
#include <sstream>
FuncInfo::FuncInfo(
      const char* bbFileName,
      const char* opFilaName,
      const char* loopFileName)
  :max_ops(0)
{
    readBBInfoFile(bbFileName);
    readOpInfoFile(opFilaName);
    readLoopInfoFile(loopFileName);
    build();
    //cout<<to_string(*this);
}
void FuncInfo::readBBInfoFile(const char* bbFileName)
{
  map<int, set<int> > _bbCStepInfo;
  ifstream bbinfo;
  bbinfo.open(bbFileName);
  if(bbinfo.is_open()==false)
  {
    cerr<<"Not exist "<<bbFileName<<"\n";
    exit(1);
  }
  string line;
  int tot_basicblock=0;
  int tot_csteps=0;
  while(getline(bbinfo,line).eof()==false)
  {
    string bb_sep("\\|");
    vector<string> parsed;
    int parsed_len=parser(line, bb_sep, parsed);
    if(parsed_len==4)
    {
      int bbid = stoi(parsed[0]);
      list<int> cstep_idx;
      string cstep_sep(",");
      addBBID(bbid);
      parsed_len=parser(parsed[1], cstep_sep, cstep_idx);
      for( auto i : cstep_idx)
      {
        addCStep(i);
        _bbCStepInfo[bbid].insert(i);
        //cerr<<"I: "<<bbid<<" "<<i<<"\n";
      }
      if(filler(_bbCStepInfo[bbid])==true)
      {
        cerr<<"Warning: BasicBlock["<<bbid<<"] has not completed\n";
      }
    }
//   else if(parsed_len==3)
//   {
//     int bbid = stoi(parsed[0]);
//     list<int> cstep_idx;
//     string cstep_sep(",");
//     addBBID(bbid);
//     parsed_len=parser(parsed[1], cstep_sep, cstep_idx);
//     for( auto i : cstep_idx)
//     {
//       addCStep(i);
//       _bbCStepInfo[bbid].insert(i);
//       //cerr<<"I: "<<bbid<<" "<<i<<"\n";
//     }
//     if(filler(_bbCStepInfo[bbid])==true)
//     {
//       cerr<<"Warning: BasicBlock["<<bbid<<"] has not completed\n";
//     }
//     if(bbCommit.size()<=bbid)
//     {
//       bbCommit.resize(bbid+1);
//       bbCommit[bbid]=stoi(parsed[2]);
//     }
//     else{
//       bbCommit[bbid]=stoi(parsed[2]);
//     }
//   }
    else
    {
      cerr<<"ERROR: during parsing "<<bbFileName<<endl;
      exit(1);
    }
  }
  if((*basicblocks.rbegin()+1)!=basicblocks.size())
  {
    cerr<<"Error: Check total_basicblock size\n";
  }
  if((*csteps.rbegin()+1)!=csteps.size())
  {
    cerr<<"Error: Check total_cstep size\n";
  }
  bbCStepInfo.resize(basicblocks.size());
  for(auto i : _bbCStepInfo)
  {
    bbCStepInfo[i.first].swap(i.second);
  }
  //cerr<<"HER\n";
  schedule.resize(basicblocks.size());
  //cerr<<"HER\n";
  cstepOPs.resize(csteps.size());
  //cerr<<"HER\n";
  bbinfo.close();
}
void FuncInfo::readOpInfoFile(const char* opFileName)
{
  ifstream opinfo;
  string line;
  opinfo.open(opFileName);
  if(opinfo.is_open()==false)
  {
    cerr<<"Not exist "<<opFileName<<"\n";
    return;
  }
  getline(opinfo, line); // remove function name
  while(getline(opinfo,line).eof()==false)
  {
    string sep("\\|");
    vector<string> buffer;
    parser(line, sep, buffer);
    if(buffer.size()==4 || buffer.size()==5)
    {
      int rtlid=stoi(buffer[1]);
      int cstep=stoi(buffer[2]);
      int bbid=stoi(buffer[3]);
      addOp(rtlid);
      addSchedule(bbid,cstep,rtlid);

    }
    else
    {
      cerr<<"Error during parsing "<< opFileName<<endl;
    }
  }
}
template<typename T>
bool addItem(const T& item, set<T>& container, bool check_unique)
{
  if(check_unique==false || container.find(item)==container.end())
  {
    container.insert(item);
    return true;
  }
  else
  {
    return false;
  }
}

void FuncInfo::addBBID(int bbid)
{
  if(addItem(bbid,basicblocks,true)==false)
  {
    cerr<<"ERROR: Duplicated BBID\n";
    exit(1);
  }
}
void FuncInfo::addCStep(int cstep)
{
  //cerr<<"CSTEP: "<<cstep<<"\n";
  addItem(cstep,csteps,false);
}
void FuncInfo::addOp(int opid)
{
//  cerr<<"addop: "<<opid<<"\n";
  if(opid>max_ops)
    max_ops=opid;
  if(addItem(opid,ops,true)==false)
  {
    //RTLID can be 
    //cerr<<"Resource sharing RTLID:"<<opid<<"\n";
  }
}
void FuncInfo::addSchedule(int bbid, int cstep, int opid)
{
  auto e_bb=basicblocks.end();
  auto e_cc=csteps.end();
  auto e_op=ops.end();
  if(basicblocks.find(bbid)!=e_bb &&
    csteps.find(cstep)!=e_cc &&
    ops.find(opid)!=e_op)
  {
    cstepOPs[cstep].insert(opid);
    schedule[bbid][cstep].insert(opid);
  }
  else
  {
    cerr<<"Error: "<<bbid<<" "<<cstep<<" "<<opid<<"\n";
    exit(1);
  }
}

void FuncInfo::readLoopInfoFile(const char* loopFile)
{
  ifstream loopfile;
  string line;
  loopfile.open(loopFile);
  if(loopfile.is_open()==false)
  {
    cerr<<"Not exist "<<loopFile<<"\n";
    exit(1);
    return;
  }
  renamed=true;
  renameTable=vector<int>(csteps.size(),-1);
  while(getline(loopfile,line).eof()==false)
  {
    string sep(",");
    vector<int> buffer;
    parser(line, sep, buffer);
    //map<int,int> renameMap;
    if(buffer.size()>=5)
    {
      int headerBBID=buffer[0];
      int tailBBID=buffer[1];
      int interval=buffer[2]; //II
      int renamedCstepBase=buffer[3];
      loopinfo.emplace_back(headerBBID,tailBBID,interval,renamedCstepBase);
      for(int i=4; i<buffer.size(); i++)
      {
        loopinfo.back().bodyIDs.insert(buffer[i]);
      }
    }
    else if(buffer.size()==2)
    {
      renameTable[buffer[0]]=buffer[1];
    }
    else
    {
      cerr<<"Error during parsing "<< loopFile<<endl;
    }
  }

}
string to_string(const LoopInfo& item)
{
  stringstream os;
  os<<"\theaderBBID: "<<item.headerBBID<<"\n";
  os<<"\ttailBBID: "<<item.tailBBID<<"\n";
  os<<"\tII: "<<item.interval<<"\n";
  os<<"\trenamedCstepBase: "<<item.renamedCstepBase<<"\n";
  os<<"\tBody: ";
  for(auto i : item.bodyIDs)
  {
    os<<i<<" ";
  }
  return os.str();
}
bool FuncInfo::filler(set<int> &container)
{
  int front=*container.begin();
  int end=*container.rbegin();
  if((end-front+1) != container.size())
  {
    for(int i=front; i<=end; i++)
    {
      container.insert(i);
    }
    return true;
  }
  return false;
}
string to_string(const FuncInfo& item)
{
  stringstream os;
  os<<"tot basicblocks: "<<item.basicblocks.size()<<"\n";
  os<<"tot csteps: "<<item.csteps.size()<<"\n";
  os<<"tot ops: "<<item.ops.size()<<"\n";
  os<<"bbCStepInfo:\n";
  int idx=0;
  for (auto& it : item.bbCStepInfo)
  {
    if(it.size()!=0)
      os<<"\t["<<idx<<"]: ";
    for(auto& i : it)
    {
      os<<i<<" ";
    }
    os<<"\n";
    idx++;
  }
  idx=0;
  os<<"cstepOPs:\n";
  for (auto& it : item.cstepOPs)
  {
    if(it.size()!=0)
      os<<"\t["<<idx<<"]: ";
    for(auto& i : it)
    {
      os<<i<<" ";
    }
    os<<"\n";
    idx++;
  }
  os<<"schedule:\n";
  idx=0;
  for (auto& it : item.schedule)
  {
    if(it.size()!=0)
      os<<"\t["<<idx<<"]: ";
    for(auto& cpair : it)
    {
      os<<"\t\t["<<cpair.first<<"]";
      for(auto& i : cpair.second)
      {
        os<<i<<" ";
      }
      os<<"\n";
    }
    os<<"\n";
    idx++;
  }
  os<<"LoopInfo:\n";
  for (auto& i : item.loopinfo)
  {
    os<<to_string(i)<<"\n";
  }

  return os.str();
}
void FuncInfo::build()
{
  if(renamed==true)
  {
    map<int, set<int> > _renamedCStepOPs;

    bbIDtoLoopMap.resize(basicblocks.size());
    for(auto& item : loopinfo)
    {
      bbIDtoLoopMap[item.headerBBID]=&item;
      item.csteps=bbCStepInfo[item.headerBBID];
      for(auto& bbid : item.bodyIDs)
      {
        bbIDtoLoopMap[bbid]=&item;
        item.csteps.insert(bbCStepInfo[bbid].begin(),
            bbCStepInfo[bbid].end());
      }
      //build renamed cstep info
      int renamed_cstep_offset=0;
      for(auto& cstep : item.csteps)
      {
        _renamedCStepOPs[(renamed_cstep_offset%item.interval)
          +item.renamedCstepBase].insert(cstepOPs[cstep].begin(),
              cstepOPs[cstep].end());
        renamed_cstep_offset++;
      }
    }
    for(int i=0, e=renameTable.size(); i!=e; i++)
    {
      if(renameTable[i]!=-1)
      {
        _renamedCStepOPs[renameTable[i]]=
          cstepOPs[i];
      }
    }
    int l=_renamedCStepOPs.rbegin()->first;
    renamedCStepOPs.resize(l+1);
    for(auto& i : _renamedCStepOPs)
    {
      renamedCStepOPs[i.first]=i.second;
    }
  }
  else
  {
    renameTable=vector<int>();
    renameTable.insert(renameTable.begin(),csteps.begin(), csteps.end());
    renamedCStepOPs=cstepOPs;
  }
  max_csteps=0;
  for(auto& i : bbCStepInfo)
  {
    if(i.size()>max_csteps)
      max_csteps=i.size();
  }
  for(auto& i : loopinfo)
  {
    auto e=i.csteps.size() ;
    if(e>max_csteps)
      max_csteps=e;
  }
//cout<<"RENAME\n"; 
//for(auto& i : renamedCStepOPs)
//{
//  for(auto& j : i)
//  {
//    cout<<j<<" ";
//  }
//  cout<<"\n";
//}
//
}

/*
string to_string(const FuncInfo& item)
{
  stringstream os;
  os<<"tot basicblocks: "<<item.basicblocks.size()<<"\n";
  os<<"tot csteps: "<<item.csteps.size()<<"\n";
  os<<"tot ops: "<<item.ops.size()<<"\n";
  os<<"bbCStepInfo:\n";
  for (auto bpair : item.bbCStepInfo)
  {
    os<<"\t["<<bpair.first<<"]: ";
    for(auto i : bpair.second)
    {
      os<<i<<" ";
    }
    os<<"\n";
  }
  os<<"cstepOPs:\n";
  for (auto bpair : item.cstepOPs)
  {
    os<<"\t["<<bpair.first<<"]: ";
    for(auto i : bpair.second)
    {
      os<<i<<" ";
    }
    os<<"\n";
  }
  os<<"schedule:\n";
  for (auto bpair : item.schedule)
  {
    os<<"\t["<<bpair.first<<"]\n";
    for(auto cpair : bpair.second)
    {
      os<<"\t\t["<<cpair.first<<"]";
      for(auto i : cpair.second)
      {
        os<<i<<" ";
      }
      os<<"\n";
    }
    os<<"\n";
  }
  os<<"LoopInfo:\n";
  for (auto i : item.loopinfo)
  {
    os<<to_string(i)<<"\n";
  }

  return os.str();
}
 */
unique_ptr<FuncInfo> buildFuncInfo(
  const char* bbFileName,
  const char* opFilaName,
  const char* loopFileName
)
{
  return unique_ptr<FuncInfo>(new FuncInfo(bbFileName,opFilaName,loopFileName));
}
