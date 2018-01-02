cmake_minimum_required(VERSION 2.8 FATAL_ERROR)
project(bbn)
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
set(DESIGN apply_fixed_bilateral_filter) # desing name 
# Inputs from HLS
FILE(GLOB TARGET_BC ../src/a.o.3.bc) # input IR file 
FILE(GLOB DFG ../src/${DESIGN}.adb.xml) # dfg
FILE(GLOB CDFG  ../src/${DESIGN}.aemf)  # cdfg
FILE(GLOB RSC  ../src/${DESIGN}.verbose.rpt.xml) # resource info 

# prefix setup
set(train_prefix "train")
set(valid_prefix "veri")
# compile flag setup for train/valid
set(train_compile_flag "-D__TRAIN__")
set(valid_compile_flag "-D__VERI__")
# feature selection parameter (0.0: no feature selection, 0<=threshold<1.0)
set(threshold "0.0")
# regressor (dt: decision tree, ls: least squares, bl: Bayes Ridged linear, gr: gradient boost regresssor)
set(REGRESSOR "dt")

synth_graybox(
 ${TARGET_BC}
 ${train_prefix} 
 ${valid_prefix} 
 ${train_compile_flag} 
 ${valid_compile_flag} 
 ${BF_PIPE_TRAIN_POWERFILE}
 ${BF_PIPE_VERI_POWERFILE}
 ${REGRESSOR}
 ${threshold}
 )

