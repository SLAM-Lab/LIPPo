cmake_minimum_required(VERSION 2.8 FATAL_ERROR)
project(dcp)
FILE(GLOB CPP_FILES ../src/*.cpp)
FILE(GLOB TARGET_BC "a.o.3.bc")

set(DESIGN dct)
FILE(GLOB DFG ${DESIGN}.adb.xml)
FILE(GLOB CDFG  ${DESIGN}.aemf)
FILE(GLOB RSC  ${DESIGN}.verbose.rpt.xml)

set(train_prefix "train")
set(valid_prefix "veri")
set(train_compile_flag "-D__TRAIN__")
set(valid_compile_flag "-D__VERI__")
set(threshold "0.1")
set(REGRESSORS "ls   bl   dt   gr")
 whitebox_pwr_model_gen(
 ${train_prefix} 
 ${valid_prefix} 
 ${train_compile_flag} 
 ${valid_compile_flag} 
 ${DCT_PIPE_ROKI_POWERFILE} 
 ${REGRESSORS}
 ${threshold}
 )

