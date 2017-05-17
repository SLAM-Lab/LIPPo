#include <stdlib.h>
#include <iostream>
#include "llvm/Support/SourceMgr.h"
#include "llvm/IRReader/IRReader.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Pass.h"
#include "llvm/PassManager.h"
#include "llvm/Bitcode/ReaderWriter.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Transforms/Scalar.h"
#include "llvm/Target/TargetLibraryInfo.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Support/CommandLine.h"
#include "preOpt.h"
#include "postOpt.h"
#include "opinfo.h"
using namespace llvm;
int main(int argc,char* argv[])
{
  if(argc < 3)
  {
    errs() << "Expected an arguement - IR file name\n";
    exit(1);
  }
 /* SMDiagnostic Err;
  std::cout<<argv[1]<<std::endl;
  Module *Mod = ParseIRFile(argv[1], Err, getGlobalContext());

  Err.print(argv[0],errs());
  raw_fd_ostream out(argv[2],ErrInfo,llvm::sys::fs::F_None);
//  StringMap<llvm::cl::Option*> opts;
//  llvm::cl::getRegisteredOptions(opts);
  cl::ParseCommandLineOptions (argc-3, &argv[3]);*/
  SMDiagnostic Err;
  Module *Mod = ParseIRFile(argv[2], Err, getGlobalContext());
  std::string ErrInfo="";
  raw_fd_ostream out(argv[3],ErrInfo,llvm::sys::fs::F_None);
  std::string targetFuncName; 
  vector<BBInfo>* bbInfo = readBBInfoFile(argv[6]);
  vector<OpInfo>* copInfo = readOpInfoFile(argv[4], targetFuncName);
  vector<RTLOpInfo>* rtlInfo= readRTLOpInfoFile(argv[5]);
  bool bb_mode=false;
  bool inv_mode=false;
  if(string(argv[1])=="--bb")
  {
    bb_mode=true;
    //cout<<"BB: "<<bb_mode<<"\n";
  }
  if(string(argv[1])=="--inv")
  {
    bb_mode=true;
    inv_mode=true;
  }

  
  errs()<<"Target function: "<<targetFuncName<<"\n";
  if (Mod)
  {
    PassManager PM;
    PM.add(new LoopInfo());
    auto bb= new BBTracer();
    bb->init(targetFuncName,bbInfo,inv_mode);
    PM.add(bb);

//   auto pp= new PipelineInfo();
//   pp->init(targetFuncName);
//   PM.add(pp);
    auto actTrace=new ActTracer();
    actTrace->init(targetFuncName,copInfo,rtlInfo,bb_mode); //consumed info (swaped)
    PM.add(actTrace);
//  if(bb==true)
//  {
//      auto optTrace=new OptTracer();
//      optTrace->init(targetFuncName,copInfo,rtlInfo); //consumed info (swaped)
//    PM.add(optTrace);
//  }else
//  {
//    auto actTrace=new ActTracer();
//    actTrace->init(targetFuncName,copInfo,rtlInfo); //consumed info (swaped)
//    PM.add(actTrace);
//  }
    PM.add(new pre_opt());
    PM.run(*Mod);
    WriteBitcodeToFile(Mod,out);
  }
  else
  {
    std::cout<<"Mod is null"<<std::endl;
  }

}
