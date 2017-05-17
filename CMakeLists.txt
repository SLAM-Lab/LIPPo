cmake_minimum_required(VERSION 2.8.10)

# You can tweak some common (for all subprojects) stuff here. For example:

set(CMAKE_DISABLE_IN_SOURCE_BUILD ON)
set(CMAKE_DISABLE_SOURCE_CHANGES  ON)

if ("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")
  message(SEND_ERROR "In-source builds are not allowed.")
endif ()

set(CMAKE_VERBOSE_MAKEFILE ON)
set(CMAKE_COLOR_MAKEFILE   ON)


# check build system!
include(FindPythonInterp)

if(PYTHONINTERP_FOUND)
  if(NOT ${PYTHON_VERSION_MAJOR} EQUAL 2)
    message( FATAL_ERROR "Check python version (<2.7)" )
  endif(NOT ${PYTHON_VERSION_MAJOR} EQUAL 2) 
else(PYTHONINTERP_FOUND)
  message( FATAL_ERROR "Cannot find python." )
endif(PYTHONINTERP_FOUND)

OPTION (USE_OpenMP "Use OpenMP" ON)
IF(USE_OpenMP)
  FIND_PACKAGE(OpenMP)
  IF(OPENMP_FOUND)
    SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
  ENDIF()
ENDIF()

add_subdirectory(annotation)
add_subdirectory(regressor)
add_subdirectory(whitebox)
add_subdirectory(graybox)
add_subdirectory(blackbox)
add_subdirectory(example)
