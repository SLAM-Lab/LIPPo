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

using namespace llvm;
using namespace std;

// remove/fill presuedo code of vivado functions

std::string getNewName(std::string name);
// pre_opt - The second implementation with getAnalysisUsage implemented.
struct pre_opt : public ModulePass {
  static char ID; // Pass identification, replacement for typeid
  pre_opt() : ModulePass(ID) {}

  virtual bool runOnModule(Module &M) {
    //++PowerModelCounter;
    //errs() << "PowerModel: ";
    std::vector<std::string> iselectName;
    std::vector<std::string> isetName;
    std::vector<Function*> iselectFunction;
    std::vector<Function*> isetFunction;
    std::vector<Function*> newSelectFunc;
    std::vector<Function*> newSetFunc;
    Function* select;
    Function* set;
    // 64 bit version
    Function* select64;
    Function* set64;
    // Find Function!
    for (Module::iterator i = M.begin(), e = M.end(); i != e; ++i)
    {
      std::string name=i->getName();
      if(name.compare(0,16 ,"llvm.part.select")==0)
      {
        iselectName.push_back(name);
      }
      if(name.compare(0,13 ,"llvm.part.set")==0)
      {
        isetName.push_back(name);
      }
    }
    //Create _select function
    if(iselectName.size()>0)
    {
      // 32 bit version
      {
        Type* int32Ty =Type::getInt32Ty(M.getContext());
        Type* argsTypes[]={int32Ty, int32Ty, int32Ty};
        FunctionType* sel=FunctionType::get(int32Ty, ArrayRef<Type*>(argsTypes,3), false);
        select=dyn_cast<Function>(M.getOrInsertFunction("_select",sel));
      }
      // 64 bit version
      {
        Type* int64Ty =Type::getInt64Ty(M.getContext());
        Type* argsTypes[]={int64Ty, int64Ty, int64Ty};
        FunctionType* sel=FunctionType::get(int64Ty, ArrayRef<Type*>(argsTypes,3), false);
        select64=dyn_cast<Function>(M.getOrInsertFunction("_select64",sel));
      }
    }
    //Create _set function
    if(isetName.size()>0)
    {
      {
        Type* int32Ty =Type::getInt32Ty(M.getContext());
        Type* argsTypes[]={int32Ty, int32Ty, int32Ty,int32Ty};
        FunctionType* sel=FunctionType::get(int32Ty, ArrayRef<Type*>(argsTypes,4), false);
        set=dyn_cast<Function>(M.getOrInsertFunction("_set",sel));
      }
      {
        Type* int64Ty =Type::getInt64Ty(M.getContext());
        Type* argsTypes[]={int64Ty, int64Ty, int64Ty,int64Ty};
        FunctionType* sel=FunctionType::get(int64Ty, ArrayRef<Type*>(argsTypes,4), false);
        set64=dyn_cast<Function>(M.getOrInsertFunction("_set64",sel));
      }
    }

    //Create Function
    for(int i=0;i<iselectName.size(); i++)
    {
      Function* sel=M.getFunction(iselectName[i]);
      iselectFunction.push_back(sel);
      FunctionType* selType=sel->getFunctionType();
      std::string newName=getNewName(iselectName[i]);
      Function* newSel=dyn_cast<Function>(M.getOrInsertFunction(newName,selType));
      newSelectFunc.push_back(newSel);
      //errs()<<newName<<"\n";
      Function::arg_iterator args = newSel->arg_begin();
      Value* v = args++;
      v->setName("v");
      Value* lo = args++;
      lo->setName("lo");
      Value* hi = args++;
      hi->setName("hi");
      BasicBlock* block=BasicBlock::Create(getGlobalContext(),"entry",newSel);
      IRBuilder<> builder(block);
      if(sel->getReturnType()->getIntegerBitWidth() <=32)
      {
        Type* int32Ty =Type::getInt32Ty(M.getContext());
        Value* selArgs[] = {
          builder.CreateZExtOrTrunc(v,int32Ty),
          builder.CreateZExtOrTrunc(lo,int32Ty),
          builder.CreateZExtOrTrunc(hi,int32Ty)};
        Value* call=builder.CreateCall(select,ArrayRef<Value*>(selArgs));
        Value* ret=builder.CreateZExtOrTrunc(call, v->getType());
        builder.CreateRet(ret);
      }
      else
      {
        Type* int64Ty =Type::getInt64Ty(M.getContext());
        Value* selArgs[] = {
          builder.CreateZExtOrTrunc(v,int64Ty),
          builder.CreateZExtOrTrunc(lo,int64Ty),
          builder.CreateZExtOrTrunc(hi,int64Ty)};
        Value* call=builder.CreateCall(select64,ArrayRef<Value*>(selArgs));
        Value* ret=builder.CreateZExtOrTrunc(call, v->getType());
        builder.CreateRet(ret);
      }

      /*        Value* castlo=builder.CreateZExtOrTrunc(lo, v->getType());
                Value* tmp = builder.CreateLShr( v, castlo, "tmp");
                Value* tmp2 = builder.CreateBinOp(Instruction::Sub,hi, lo,"tmp2");
                Type* int32Ty =Type::getInt32Ty(M.getContext());
                Value* tmp3 = builder.CreateBinOp(Instruction::Sub,ConstantInt::getSigned(int32Ty,31), tmp2,"tmp3");
                Value* mask = builder.CreateLShr( ConstantInt::getSigned(int32Ty, -1), tmp3, "mask");
                Value* castmask=builder.CreateZExtOrTrunc(mask, v->getType());
                Value* ret = builder.CreateBinOp(Instruction::And, tmp, castmask, "ret");*/


    }
    for(int i=0;i<isetName.size(); i++)
    {
      Function* sel=M.getFunction(isetName[i]);
      isetFunction.push_back(sel);
      FunctionType* selType=sel->getFunctionType();
      std::string newName=getNewName(isetName[i]);
      Function* newSel=dyn_cast<Function>(M.getOrInsertFunction(newName,selType));
      newSetFunc.push_back(newSel);
      //errs()<<newName<<"\n";
      Function::arg_iterator args = newSel->arg_begin();
      Value* v = args++;
      v->setName("v");
      Value* rep = args++;
      rep->setName("rep");
      Value* lo = args++;
      lo->setName("lo");
      Value* hi = args++;
      hi->setName("hi");
      BasicBlock* block=BasicBlock::Create(getGlobalContext(),"entry",newSel);
      IRBuilder<> builder(block);
      if(sel->getReturnType()->getIntegerBitWidth() <=32)
      {
        Type* int32Ty =Type::getInt32Ty(M.getContext());

        Value* selArgs[] = {
          builder.CreateZExtOrTrunc(v,int32Ty),
          builder.CreateZExtOrTrunc(rep,int32Ty),
          builder.CreateZExtOrTrunc(lo,int32Ty),
          builder.CreateZExtOrTrunc(hi,int32Ty)};
        Value* call=builder.CreateCall(set,ArrayRef<Value*>(selArgs));
        Value* ret=builder.CreateZExtOrTrunc(call, v->getType());
        builder.CreateRet(ret);
      }
      else
      {
        Type* int64Ty =Type::getInt64Ty(M.getContext());
        Value* selArgs[] = {
          builder.CreateZExtOrTrunc(v,int64Ty),
          builder.CreateZExtOrTrunc(rep,int64Ty),
          builder.CreateZExtOrTrunc(lo,int64Ty),
          builder.CreateZExtOrTrunc(hi,int64Ty)};
        Value* call=builder.CreateCall(set64,ArrayRef<Value*>(selArgs));
        Value* ret=builder.CreateZExtOrTrunc(call, v->getType());
        builder.CreateRet(ret);
      }


      /*        Value* castrep = builder.CreateZExtOrTrunc(rep, v->getType());
                Value* tmp2 = builder.CreateBinOp(Instruction::Sub,hi, lo,"tmp2");
                Value* tmp3 = builder.CreateBinOp(Instruction::Sub,ConstantInt::getSigned(int32Ty,31), tmp2,"tmp3");
                Value* mask_t = builder.CreateLShr(ConstantInt::getSigned(int32Ty, -1), tmp3, "mask_t");
                Value* mask = builder.CreateBinOp(Instruction::Shl,mask_t, hi, "mask");

                Value* castmask=builder.CreateZExtOrTrunc(mask, v->getType());
                Value* not_mask= builder.CreateNot(castmask, "not_mask");
                Value* nv = builder.CreateAnd(not_mask,v);
                Value* nrep = builder.CreateAnd(castmask,castrep);
                Value* ret = builder.CreateOr(nrep,nv);*/
    }
    //Update call sites
    for (Module::iterator i = M.begin(), e = M.end(); i != e; ++i)
    {
      for (Function::iterator j = i->begin(), ef = i->end(); j != ef; ++j)
      {;
        for (BasicBlock::iterator k = j->begin(), eb = j->end(); k != eb; ++k)
        {
          if(CallInst* callInst = dyn_cast<CallInst>(&*k))
          {
            for(int l=0; l<iselectFunction.size(); l++)
            {
              if(callInst->getCalledFunction()==iselectFunction[l])
              {
                callInst->setCalledFunction(newSelectFunc[l]);
              }
            }
            for(int l=0; l<isetFunction.size(); l++)
            {
              if(callInst->getCalledFunction()==isetFunction[l])
              {
                callInst->setCalledFunction(newSetFunc[l]);
              }
            }
          }
        }
      }
    }


    return false;
  }

  // We modified the program, but it only replaced the intrinsic functions to predefined one..
  // So, we don't need to invalidate analysis data.
  virtual void getAnalysisUsage(AnalysisUsage &AU) const {
    AU.setPreservesAll();
  }
};
