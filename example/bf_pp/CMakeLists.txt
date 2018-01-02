project(bf)
enable_testing()
include(CTest)
set(BF_PIPE_TRAIN_POWERFILE ${PROJECT_SOURCE_DIR}/powerfile/train_pwr.out
  CACHE INTERNAL "" FORCE)
set(BF_PIPE_VERI_POWERFILE ${PROJECT_SOURCE_DIR}/powerfile/veri_pwr.out_long
  CACHE INTERNAL "" FORCE)
add_subdirectory(whitebox)
add_subdirectory(graybox)
add_subdirectory(blackbox)
