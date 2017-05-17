#pragma once
#include "BBActTraceSim.h"

typedef BBActTraceSim TraceSim;
unique_ptr<TraceSim> buildTraceSim(unique_ptr<FuncInfo>& funcInfo, string pfilename);

