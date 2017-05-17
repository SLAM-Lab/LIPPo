#pragma once
#include <memory>
class FuncInfo {public:};
inline
std::unique_ptr<FuncInfo> buildFuncInfo(
  const char* bbFileName,
  const char* opFilaName,
  const char* loopFileName
)
{
  return std::unique_ptr<FuncInfo>(new FuncInfo());
}
