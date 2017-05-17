#pragma once
#include "CycleActTraceSim.h"

typedef CycleActTraceSim TraceSim;
unique_ptr<TraceSim> buildTraceSim(unique_ptr<FuncInfo>& funcInfo, string pfilename);

