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
#include "opinfo.h"
using namespace llvm;
struct BBTracer : public ModulePass
{
  static char ID; // pass identification
  BBTracer() : ModulePass(ID) {}
  virtual bool runOnModule(Module& M);
  void init(std::string _targetName,
      std::vector<BBInfo>* _bbInfo,
      bool _inv_mode)
  { 
    bbInfo.swap(*_bbInfo);
    targetName=_targetName;
    inv_mode=_inv_mode;
    
  }

  std::string targetName;
  virtual void getAnalysisUsage(AnalysisUsage &AU) const {
    // we need loopinfo pass before execution of this pass
    AU.setPreservesAll();
  }
  std::vector<BBInfo> bbInfo;
  bool inv_mode;
};
// struct PipelineInfo : public ModulePass
// {
//
//   static char ID; //pass identification
//   PipelineInfo() : ModulePass(ID) {}
//   virtual bool runOnModule(Module &M);
//   void init(std::string _targetName) { targetName=_targetName;}
//   virtual void getAnalysisUsage(AnalysisUsage &AU) const {
//     // we need loopinfo pass before execution of this pass
//     AU.addRequired<LoopInfo>();
//     AU.addRequired<BBTracer>();
//     AU.setPreservesAll();
//   }
//   std::string targetName;
// };
int get_bb_id(BasicBlock* bb);
// struct OptTracer : public ModulePass
// {
//   static char ID; //pass identification
//   OptTracer() : ModulePass(ID) {}
//   void init(std::string target, 
//       std::vector<OpInfo>* _cOpInfo,
//       std::vector<RTLOpInfo>* _rtlOpInfo)
//   {
//     targetName=target;
//     cOpInfo.swap(*_cOpInfo);
//     rtlOpInfo.swap(*_rtlOpInfo);
//   }
//   virtual bool runOnModule(Module &M);
//   virtual void getAnalysisUsage(AnalysisUsage &AU) const {
//     // We modified the program, but it only replaced the intrinsic functions to predefined one..
//     // So, we don't need to invalidate analysis data.
//     AU.setPreservesAll();
//     // BB Info is needed!!
//     AU.addRequired<BBTracer>();
//   }
//   std::vector<OpInfo> cOpInfo;
//   std::vector<RTLOpInfo> rtlOpInfo;
//   std::string targetName;
// };
struct ActTracer : public ModulePass
{
  static char ID; //pass identification
  ActTracer() : ModulePass(ID) {}
  void init(std::string target, 
      std::vector<OpInfo>* _cOpInfo,
      std::vector<RTLOpInfo>* _rtlOpInfo,
      bool _bb_mode)
  {
    targetName=target;
    cOpInfo.swap(*_cOpInfo);
    rtlOpInfo.swap(*_rtlOpInfo);
    bb_mode=_bb_mode;
   
  }
  virtual bool runOnModule(Module &M);
  virtual void getAnalysisUsage(AnalysisUsage &AU) const {
    // We modified the program, but it only replaced the intrinsic functions to predefined one..
    // So, we don't need to invalidate analysis data.
    AU.setPreservesAll();
    // BB Info is needed!!
    AU.addRequired<BBTracer>();
  }
  std::vector<OpInfo> cOpInfo;
  std::vector<RTLOpInfo> rtlOpInfo;
  std::string targetName;
  int bb_mode;
};
