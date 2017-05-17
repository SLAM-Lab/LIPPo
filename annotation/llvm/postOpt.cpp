#include "llvm/IR/Module.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/Analysis/LoopInfo.h"

#include "llvm/Pass.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/CommandLine.h"
#include <fstream>
#include <string>
#include <iostream>
#include <algorithm>
#include <stdlib.h>
#include <vector>
#include <map>
#include <set>
#include <stdio.h>
#include "postOpt.h"
using namespace llvm;

char BBTracer::ID = 1;
static RegisterPass<BBTracer> A("BBTracer", "Add bb_begin bb_end");
//char OptTracer::ID = 2;
//static RegisterPass<OptTracer> B("OptTracer", "add tracer in bit file.");
//char PipelineInfo::ID = 3;
//static RegisterPass<PipelineInfo> C("pipelineinfo", "Print loop info");
char ActTracer::ID = 4;
static RegisterPass<ActTracer> D("ActTracer", "activity Collection");
std::string& remove_space(std::string& str)
{
  std::string::iterator end_pos = std::remove(str.begin(), str.end(), ' ');
  str.erase(end_pos, str.end());
  end_pos = std::find(str.begin(), str.end(), '#');
  str.erase(end_pos, str.end());
  return str;
}

template<bool must_find>
Instruction* findMatchedInst(string code,BasicBlock*i)
{
  for (BasicBlock::iterator j= i->begin(),  je = i->end(); j != je; ++j)
  {
    // tostring(insturction)*/
    std::string tmp;
    raw_string_ostream ss(tmp);
    ss<<(*j);
    std::string copy_code=code;
    std::string code_wo_space=remove_space(copy_code);
    std::string code=remove_space(ss.str());
//  errs()<<"F: "<<code<<" "<<code_wo_space<<"\n";
    if(code.compare(0,code.size(),code_wo_space,0,min(code.size(),code_wo_space.size()))==0)
    {
      return &*j;
    }
  }
  if(must_find==true)
  {
    errs()<<"cannot find "<<code<<"\n";
    assert(true); //never reach this point!
  }
  return nullptr;
}
Function* get_bb_begin(Module& M);

int get_bb_id(Module& m,BasicBlock* b)
{
  //Module& m=*(b->getParent()->getParent());
  Function* bb_begin=get_bb_begin(m);
  for(BasicBlock::iterator i=b->begin(), e=b->end(); 
      i!=e; ++i)
  {
    CallInst* call=dyn_cast<CallInst>(&*i);
    if(call!=nullptr && call->getCalledFunction()==bb_begin)
    {
      //get first arg
      ConstantInt* id = dyn_cast<ConstantInt>(call->getArgOperand(0));
      return id->getZExtValue();
    }
  }
  return -1;
}
Function* get_bb_begin(Module& M)
{
  Function* target=M.getFunction(StringRef("bb_begin"));
  if(target==NULL)
  {
    Type* voidTy =Type::getVoidTy(M.getContext());
    Type* int32Ty =Type::getInt32Ty(M.getContext());
    FunctionType* bb_begin_ty =FunctionType::get(voidTy, ArrayRef<Type*>(int32Ty), false);
    Function* bb_begin=dyn_cast<Function>(M.getOrInsertFunction("bb_begin",bb_begin_ty));
    return bb_begin;
  }
  else
  {
    return target;
  }
}
Function* get_bb_end(Module& M)
{
  Function* target=M.getFunction(StringRef("bb_end"));
  if(target==NULL)
  {
    Type* voidTy =Type::getVoidTy(M.getContext());
    FunctionType* bb_end_ty   =FunctionType::get(voidTy, ArrayRef<Type*>(), false);
    Function* bb_end=dyn_cast<Function>(M.getOrInsertFunction("bb_end",bb_end_ty));
    return bb_end;
  }
  else
  {
    return target;
  }
}
Function* getTargetFunc(Module& M,std::string targetName)
{
  //errs()<<"Get: "<<targetName<<"\n";
  Function* target=M.getFunction(StringRef(targetName.c_str()));
  if(target!=nullptr)
  {
    //errs()<<"Start basic block analysis\n";
  }
  else
  {
    errs()<<"Cannot find the target ("<<targetName<<")\n";
    exit(1);
  }
  return target;
}
bool
BBTracer::runOnModule(Module& M)
{
  //errs()<<"BBTracer: "<<targetName<<"\n";
 // assign bb id and put bb_begin and bb_end in module
  Function* target= getTargetFunc(M,targetName);
  // create bb_begin(int id), bb_end() signature
  Function* bb_begin=get_bb_begin(M);
  Function* bb_end=get_bb_end(M);
  Type* int32Ty =Type::getInt32Ty(M.getContext());
  for (auto& bb : bbInfo)
  {
    int bbid=bb.bbid;
    string hint_begin_code=bb.begin_code;
    string hint_end_code=bb.end_code;
    bool assigned=false;
    for (Function::iterator b_i=target->begin(), b_e=target->end();
        b_i!=b_e; b_i++)
    {
      BasicBlock* curBB=&(*b_i);
      if(get_bb_id(M,curBB)!=-1)
      {
        continue;
      }
      Instruction* b=findMatchedInst<false>(hint_begin_code,curBB);
      Instruction* e=findMatchedInst<false>(hint_end_code,curBB);
      if(b!=nullptr && e !=nullptr)
      {
        //errs()<<"Found: "<<*b<<" "<<*e<<" "<<bbid<<"\n";
        Instruction* b_ptr=b_i->getFirstNonPHI();
        Instruction* e_ptr=&*b_i->rbegin();
        if(b==e)
        {
          int num_inst=0;
          for (BasicBlock::iterator bbi=b_i->begin(), 
              bbe=b_i->end(); bbi!=bbe;bbi++)
          {
            string tmp;
            raw_string_ostream ss(tmp);
            ss<<(*bbi);
            string i_code=ss.str();
            if(std::string::npos == i_code.find("ssdm"))
            {
              num_inst++;
            }
          }
          if(num_inst!=1)
          {
            errs()<<"Inst: "<<num_inst<<"\n";
            errs()<<"Cannot found: "<<*b<<" "<<*e<<" "<<bbid<<"\n";
            continue;
          }
        }
        if(inv_mode==false)
        {
          auto bb_begin_call=CallInst::Create(bb_begin, ArrayRef<Value*>(ConstantInt::getSigned(int32Ty,bbid)));
          auto bb_end_call=CallInst::Create(bb_end,ArrayRef<Value*>());
          bb_begin_call->insertBefore(b_ptr);
          bb_end_call->insertBefore(e_ptr);
        }
        assigned=true;
        break;
      }
    }
    if(assigned==false)
    {
     errs()<<bbid<<" "<<hint_end_code<<" "<<hint_begin_code<<"\n";
      errs()<<"Cannot assign bbid !!: check bbInfo.txt\n";
      exit(2);
    }
  }
  //errs()<<"End basic block analysis\n";
  return true;
}
// bool 
// PipelineInfo::runOnModule(Module& M)
// {
//   errs()<<"PipelineInfo: "<<targetName<<"\n";
//   Function* target= getTargetFunc(M,targetName);
//   LoopInfo*  LI = &getAnalysis<LoopInfo>(*target);
//   errs()<<"Loop start\n";
//   for(LoopInfo::iterator i =  LI->begin(), e=LI->end(); i!=e ; ++i)
//   {
//     errs()<<"Loop : depth="<<(*i)->getLoopDepth()<<"\n"
//       <<"\tloop end="<<get_bb_id(M,(*i)->getExitingBlock())<<"\n";
//     for(Loop::block_iterator j= (*i)->block_begin(), je=(*i)->block_end(); j!=je; ++j)
//     {
//       if(LI->isLoopHeader(*j))
//       {
//         errs()<<"\theader: "<<get_bb_id(M,(*j))<<"\n";
//       }else
//       {
//         errs()<<"\tbody: "<<get_bb_id(M,(*j))<<"\n";
//       }
//     }
//   }
//   errs()<<"Loop done\n";
//   return true;
// }
Function* getTracer(Module& M,int signals, bool optimized)
{
  std::string tracer_name="trace";
// if(optimized==true)
// {
//   tracer_name+=to_string(signals);
// }
  Function* ret=M.getFunction(StringRef(tracer_name.c_str()));
  if(ret==nullptr)
  {
    Type* int32Ty =Type::getInt32Ty(M.getContext());
    Type* voidTy =Type::getVoidTy(M.getContext());
    if(optimized==false)
    {
      Type* argsTypes[]={int32Ty, int32Ty, int32Ty, int32Ty, int32Ty, int32Ty};
      FunctionType* trace=FunctionType::get(voidTy, ArrayRef<Type*>(argsTypes,6), false);
      ret=dyn_cast<Function>(M.getOrInsertFunction(tracer_name.c_str(),trace));
      return ret;
    }
    else
    {
//     std::vector<Type*> args(signals+1,int32Ty);
      Type* argsTypes[]={int32Ty, int32Ty, int32Ty, int32Ty, int32Ty, int32Ty}; // rtlid, cstep, update, a,b, s
      FunctionType* trace=FunctionType::get(voidTy, ArrayRef<Type*>(argsTypes,6), false);
      ret=dyn_cast<Function>(M.getOrInsertFunction(tracer_name.c_str(),trace));
      return ret;
    }
  }
  return ret;
}
typedef  std::vector<std::pair<Instruction*,Instruction*> > insertList_ty;
// void createOptTracer(Module& M,OpInfo& cop, RTLOpInfo& rop, Instruction* inst,
//     insertList_ty& insertList)
// {
//   Type* int32Ty =Type::getInt32Ty(M.getContext());
//   assert(int32Ty!=nullptr);
//   std::vector<Value*> args;
//   args.push_back(ConstantInt::getSigned(int32Ty, cop.rtlid));
//   args.push_back(ConstantInt::getSigned(int32Ty, cop.cstep));
//   args.push_back(ConstantInt::getSigned(int32Ty, cop.pwr));
//   Instruction* insertPtr=inst;
//   for(int arg_num=0, e=3 ;arg_num!=e; arg_num++) 
//   {
//     Value* arg=nullptr;
//     int bitwidth=32;
//     if(arg_num == 2)
//     {
//       bitwidth=rop.getReturnBitWidth();
//       if(bitwidth!=0)
//         arg=inst;
//       else
//         arg=nullptr;
//     }
//     else
//     {
//       bitwidth=rop.getOperandBitWidth(arg_num);
//       if(bitwidth!=0)
//         arg=inst->getOperand(arg_num);
//       else
//         arg=nullptr;
//     } 
//     if(bitwidth!=0)
//     {
//       //casting
//       Type* argType=arg->getType();
//       assert(argType!=nullptr);
//       if((argType->isIntegerTy(bitwidth)==false) ||
//         (argType!=int32Ty))
//       {
//         Type* newType =Type::getIntNTy(M.getContext(), bitwidth);
//         assert(newType!=nullptr);
//         auto sext=CastInst::CreateIntegerCast(arg, newType, true);
//         assert(sext!=nullptr);
//         insertList.push_back(std::pair<Instruction*,Instruction*>(insertPtr,sext));
//         auto casting=CastInst::CreateIntegerCast(sext,int32Ty, false);
//         assert(casting!=nullptr);
//         insertList.push_back(std::pair<Instruction*,Instruction*>(sext,casting));
//         insertPtr=casting;
//         arg=casting;
//       }
//     }
//     else
//     {
//       arg=ConstantInt::getSigned(int32Ty,0);
//     }
//     args.push_back(arg);
//   }
//   Function* optTracer=getTracer(M,args.size(),true);
//   auto newInst = CallInst::Create(optTracer, 
//       ArrayRef<Value*>(args));
//   insertList.push_back(std::pair<Instruction*,Instruction*>(insertPtr,newInst));
// }
void createLSTracer(Module& M,OpInfo& cop, RTLOpInfo& rop, Instruction* inst,
    insertList_ty& insertList)
{
  Type* int32Ty =Type::getInt32Ty(M.getContext());
  assert(int32Ty!=nullptr);
  std::vector<Value*> args;
  args.push_back(ConstantInt::getSigned(int32Ty, cop.rtlid));
  Instruction* insertPtr=inst;
  for(int arg_num=0, e=3 ;arg_num!=e; arg_num++) 
  {
    Value* arg=nullptr;
    int bitwidth=32;
    if(arg_num == 2)
    {
      bitwidth=rop.getReturnBitWidth();
      if(bitwidth!=0)
        arg=inst;
      else
        arg=nullptr;
    }
    else
    {
      bitwidth=rop.getOperandBitWidth(arg_num);
      if(bitwidth!=0)
        arg=inst->getOperand(arg_num);
      else
        arg=nullptr;
    } 
    if(bitwidth!=0)
    {
      //casting
      Type* argType=arg->getType();
      assert(argType!=nullptr);
      if((argType->isIntegerTy(bitwidth)==false) ||
        (argType!=int32Ty))
      {
        Type* newType =Type::getIntNTy(M.getContext(), bitwidth);
        assert(newType!=nullptr);
        auto sext=CastInst::CreateIntegerCast(arg, newType, true);
        assert(sext!=nullptr);
        insertList.push_back(std::pair<Instruction*,Instruction*>(insertPtr,sext));
        auto casting=CastInst::CreateIntegerCast(sext,int32Ty, false);
        assert(casting!=nullptr);
        insertList.push_back(std::pair<Instruction*,Instruction*>(sext,casting));
        insertPtr=casting;
        //errs()<<"before: "<<*arg<<"\n";
        arg=casting;
      }
      args.push_back(arg);
      //errs()<<*arg<<"\n";
    }
  }
  Function* ret=M.getFunction(StringRef(string("trace_ls")));
  if(ret==nullptr)
  {
    Type* int32Ty =Type::getInt32Ty(M.getContext());
    Type* voidTy =Type::getVoidTy(M.getContext());
    Type* argsTypes[]={int32Ty, int32Ty};
    FunctionType* trace=FunctionType::get(voidTy, ArrayRef<Type*>(argsTypes,2), false);
    ret=dyn_cast<Function>(M.getOrInsertFunction(string("trace_ls"),trace));
  }
  if(args.size()!=2)
  {
    args.resize(2);
  }
  auto newInst = CallInst::Create(ret, ArrayRef<Value*>(args));
  //errs()<<"NEW: "<<*newInst<<"\n";
  insertList.push_back(std::pair<Instruction*,Instruction*>(insertPtr,newInst));
  //errs()<<"END: \n";
}
// bool
// OptTracer::runOnModule(Module& M)
// {
//   errs()<<"OptTracer: "<<targetName<<"\n";
//   Function* target= getTargetFunc(M,targetName);
//   for(auto& cop : cOpInfo)
//   {
//     for(Function::iterator i = target->begin(), 
//         e = target->end(); i != e; ++i)
//     {
//       int bbid=get_bb_id(M,&*i);
//       insertList_ty  insertList; // (insertbefore, newInst)
//       if(bbid==cop.bbid)
//       {
//         auto m_op=findMatchedInst<true>(cop,&*i);
//         assert(cop.rtlid < rtlOpInfo.size());
//         createOptTracer(M,cop,rtlOpInfo[cop.rtlid],m_op,insertList);
//         for(auto i_pair : insertList)
//         {
//           i_pair.second->insertAfter(i_pair.first);
//         }
//         break;
//       }
//     }
//   }
//   return true;
// }

void createActTracer(Module& M,OpInfo& cop, RTLOpInfo& rop, Instruction* inst,
    insertList_ty& insertList)
{
  Type* int32Ty =Type::getInt32Ty(M.getContext());
  assert(int32Ty!=nullptr);
  Function* actTracer=getTracer(M,0 /*dont care*/,false);
  std::vector<Value*> args;
  args.push_back(ConstantInt::getSigned(int32Ty, cop.rtlid));
  args.push_back(ConstantInt::getSigned(int32Ty, cop.cstep));
  args.push_back(ConstantInt::getSigned(int32Ty, cop.opid));

  Instruction* insertPtr=inst;
  for(int arg_num=0, e=3 ;arg_num!=e; arg_num++) 
    // TODO: need to fix : only take 1 output 2 inputs, cannot support islsect
  {
    //casting
    Value* arg=nullptr;
    int bitwidth=32;
    if(arg_num == 2)
    {
      bitwidth=rop.getReturnBitWidth(); 
      if(bitwidth!=0)
        arg=inst;
      else
        arg=nullptr;
    }
    else
    {
      bitwidth=rop.getOperandBitWidth(arg_num);
      if(bitwidth!=0)
        arg=inst->getOperand(arg_num);
      else
        arg=nullptr;
    }
    if(bitwidth!=0)
    {
      Type* argType=arg->getType();
      assert(argType!=nullptr);
      if((argType->isIntegerTy(bitwidth)==false) ||
        (argType!=int32Ty))
      {
        Type* newType =Type::getIntNTy(M.getContext(), bitwidth);
        assert(newType!=nullptr);
        auto sext=CastInst::CreateIntegerCast(arg, newType, true);
        assert(sext!=nullptr);
        insertList.push_back(std::pair<Instruction*,Instruction*>(insertPtr,sext));
        auto casting=CastInst::CreateIntegerCast(sext,int32Ty, false);
        assert(casting!=nullptr);
        insertList.push_back(std::pair<Instruction*,Instruction*>(sext,casting));
        insertPtr=casting;
        arg=casting;
      }
    }
    else
    {
      arg=ConstantInt::getSigned(int32Ty,0);
    }
    args.push_back(arg);
  }
  auto newInst = CallInst::Create(actTracer, 
      ArrayRef<Value*>(args));
  insertList.push_back(std::pair<Instruction*,Instruction*>(insertPtr,newInst));
}
bool
ActTracer::runOnModule(Module& M)
{
//  errs()<<"ActTracer: "<<targetName<<"\n";
  Function* target= getTargetFunc(M,targetName);
  for(auto& cop : cOpInfo)
  {
    for(Function::iterator i = target->begin(), 
        e = target->end(); i != e; ++i)
    {
      int bbid=get_bb_id(M,&*i);
      insertList_ty  insertList; // (insertbefore, newInst)
      auto m_op=findMatchedInst<false>(cop.code,&*i);
      if(m_op!=nullptr)
      {
        cop.bbid=bbid;
        assert(cop.rtlid < rtlOpInfo.size());
        if(bb_mode==true)
        {
          createLSTracer(M,cop,rtlOpInfo[cop.rtlid],m_op,insertList);
        }
        else
        {
          createActTracer(M,cop,rtlOpInfo[cop.rtlid],m_op,insertList);
        }
        for(auto i_pair : insertList)
        {
          i_pair.second->insertAfter(i_pair.first);
        }
        break;
      }
    }
  }
  return true;
}
