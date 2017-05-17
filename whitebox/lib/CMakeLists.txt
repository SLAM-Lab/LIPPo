cmake_minimum_required(VERSION 2.8 FATAL_ERROR)
project(WHITEBOX_LIBS)
set(WHITEBOX_INCLUDE_DIRS ${PROJECT_SOURCE_DIR}/src 
  CACHE INTERNAL "${PROJECT_NAME}: Include Directories" FORCE)
add_subdirectory(src)
