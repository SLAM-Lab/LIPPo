project(example)
enable_testing()
include(CTest)
add_subdirectory(dct_power_model)
FILE(COPY dct_hw_synth  DESTINATION ${CMAKE_CURRENT_BINARY_DIR})

