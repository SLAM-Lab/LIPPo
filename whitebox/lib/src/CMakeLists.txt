cmake_minimum_required(VERSION 2.8 FATAL_ERROR)
project(whitebox_trace_cpp)
set(WHITEBOX_TRACE_CPP ${PROJECT_SOURCE_DIR}/power.cpp ${PROJECT_SOURCE_DIR}/funcinfo.cpp ${PROJECT_SOURCE_DIR}/trace.cpp
    CACHE INTERNAL "${PROJECT_NAME}: trace cpp" FORCE)
