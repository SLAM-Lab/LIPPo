cmake_minimum_required(VERSION 2.8 FATAL_ERROR)
project(dcp) # project name
enable_testing()
include(CTest)

SET(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -O3  -fPIC -std=c++11 ") # compile flags 
find_package(Boost 1.50.0 REQUIRED COMPONENTS regex)
if(Boost_FOUND)
  message(STATUS "Found BOOST")
  include_directories(${Boost_INCLUDE_DIRS})
endif()
include_directories(${GRAYBOX_INCLUDE_DIRS} ${REGRESSOR_INCLUDE_DIR}) # Include files for whitebox lib and regression lib

FILE(GLOB CPP_FILES ../src/*.cpp) # test files
set(DESIGN dct) # desing name 
# Inputs from HLS
FILE(GLOB TARGET_BC ../src/a.o.3.bc) # input IR file 
FILE(GLOB DFG ../src/${DESIGN}.adb.xml) # dfg
FILE(GLOB CDFG  ../src/${DESIGN}.aemf)  # cdfg
FILE(GLOB RSC  ../src/${DESIGN}.verbose.rpt.xml) # resource info 

# prefix setup
set(train_prefix "roki")
set(valid_prefix "audi")
# compile flag setup for train/valid
set(train_compile_flag "-DROKI")
set(valid_compile_flag "-DAUDI")
# feature selection parameter (0.0: no feature selection, 0<=threshold<1.0)
set(threshold "0.1")
# regressor (dt: decision tree, ls: least squares, bl: Bayes Ridged linear, gr: gradient boost regresssor)
set(REGRESSOR "dt")

# whitebox power model synthesis
#  DCT_PIPE_ROKI_POWERFILE : power file for roki
#  DCT_PIPE_AUDI_POWERFILE : power file for audi
synth_whitebox(
 ${TARGET_BC}
 ${train_prefix} 
 ${valid_prefix} 
 ${train_compile_flag} 
 ${valid_compile_flag} 
 ${DCT_PIPE_ROKI_POWERFILE}
 ${DCT_PIPE_AUDI_POWERFILE}
 ${REGRESSOR}
 ${threshold}
 )

