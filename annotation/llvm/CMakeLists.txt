cmake_minimum_required(VERSION 2.8.8)
project(SimpleProject)
find_package(Boost 1.50.0 REQUIRED COMPONENTS regex)
if(Boost_FOUND)
  message(STATUS "Found BOOST")
  include_directories(${Boost_INCLUDE_DIRS})
endif()

find_package(LLVM REQUIRED CONFIG)

message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

# Set your project compile flags.
# E.g. if using the C++ header files
# you will need to enable C++11 support
# for your compiler.
SET(CMAKE_CXX_FLAGS  "-fPIC -std=c++11 -O0 -g")
include_directories(${LLVM_INCLUDE_DIRS})
add_definitions(${LLVM_DEFINITIONS})

# Now build our tools
add_executable(simple-tool  opinfo.cpp main.cpp postOpt.cpp preOpt.cpp)
set_source_files_properties(main.cpp  PROPERIES COMPILE_FLAGS -fno-rtti)
set_source_files_properties(postOpt.cpp  PROPERIES COMPILE_FLAGS -fno-rtti)
set_source_files_properties(preOpt.cpp  PROPERIES COMPILE_FLAGS -fno-rtti)

# Find the libraries that correspond to the LLVM components
# that we wish to use
llvm_map_components_to_libnames(llvm_libs analysis asmparser asmprinter bitreader bitwriter codegen core debuginfo engine executionengine instcombine instrumentation interpreter ipa ipo irreader jit lineeditor linker lto mc mcanalysis mcdisassembler mcjit mcparser native nativecodegen objcarcopts object option runtimedyld scalaropts selectiondag tablegen target transformutils vectorize )

# Link against LLVM libraries
target_link_libraries(simple-tool ${llvm_libs} ${Boost_LIBRARIES})
