project(hdr)
set(HDR_PIPE_SH_POWERFILE ${PROJECT_SOURCE_DIR}/powerfile/small_house_pwr1.out
  CACHE INTERNAL "" FORCE)
set(HDR_PIPE_CH_POWERFILE ${PROJECT_SOURCE_DIR}/powerfile/small_church_pwr1.out
  CACHE INTERNAL "" FORCE)
add_subdirectory(whitebox)
add_subdirectory(graybox)
add_subdirectory(blackbox)
