cmake_minimum_required(VERSION 2.8 FATAL_ERROR)
project(regressor)

set(REGRESSOR_INCLUDE_DIR ${PROJECT_SOURCE_DIR}
    CACHE INTERNAL "${PROJECT_NAME}: Include Directories" FORCE)
set(PARSE_CPP ${PROJECT_SOURCE_DIR}/parse.cpp
    CACHE INTERNAL "${PROJECT_NAME}: Include Directories" FORCE)
