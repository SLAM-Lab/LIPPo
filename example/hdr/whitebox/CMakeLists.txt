cmake_minimum_required(VERSION 2.8 FATAL_ERROR)
project(hcp)

SET(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -O3  -fPIC -std=c++11 ")
find_package(Boost 1.50.0 REQUIRED COMPONENTS regex)
if(Boost_FOUND)
  message(STATUS "Found BOOST")
  include_directories(${Boost_INCLUDE_DIRS})
endif()
include_directories(${WHITEBOX_INCLUDE_DIRS} ${REGRESSOR_INCLUDE_DIR})

FILE(GLOB CPP_FILES ../src/*.cpp)
FILE(GLOB TARGET_BC ../src/a.o.3.bc)

set(DESIGN computeWeightRGB_fxp)
FILE(GLOB TEST_FILE ../src/*_data )
FILE(COPY ${TEST_FILE}  DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
FILE(GLOB DFG ../src/${DESIGN}.adb.xml)
FILE(GLOB CDFG  ../src/${DESIGN}.aemf)
FILE(GLOB RSC  ../src/${DESIGN}.verbose.rpt.xml)


set(train_prefix "sh")
set(valid_prefix "ch")
set(train_compile_flag "-DSMALL_HOUSE")
set(valid_compile_flag "-DSMALL_CHURCH")
set(threshold "0.1")
set(REGRESSOR "dt")

synth_whitebox(
 ${TARGET_BC}
 ${train_prefix} 
 ${valid_prefix} 
 ${train_compile_flag} 
 ${valid_compile_flag} 
 ${HDR_PIPE_SH_POWERFILE} 
 ${HDR_PIPE_CH_POWERFILE} 
 ${REGRESSOR}
 ${threshold}
 )

