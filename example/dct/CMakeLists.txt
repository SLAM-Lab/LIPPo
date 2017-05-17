project(dct)
enable_testing()
include(CTest)
set(DCT_PIPE_ROKI_POWERFILE ${PROJECT_SOURCE_DIR}/powerfile/roki_pwr1.out
  CACHE INTERNAL "" FORCE)
set(DCT_PIPE_AUDI_POWERFILE ${PROJECT_SOURCE_DIR}/powerfile/audi_pwr1.out
  CACHE INTERNAL "" FORCE)
add_subdirectory(whitebox)
add_subdirectory(graybox)
add_subdirectory(blackbox)
