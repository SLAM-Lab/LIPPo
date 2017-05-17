#include "preOpt.h"
char pre_opt::ID = 6;
static RegisterPass<pre_opt>
Y("pre_opt", "PowerModel World Pass (with getAnalysisUsage implemented)");
std::string getNewName(std::string name)
{
  std::string newName=name.substr(10);
  for(int i=0; i<newName.size(); i++)
  {
    if(newName[i]=='.')
    {
      newName[i]='_';
    }
  }
  return newName;

}
