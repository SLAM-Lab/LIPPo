LIPPo: Learning-Based IP Power Modeling
=======================================

This repository incorporates the source code of activity annotation 
tools, power model synthesis tools, and a prediction library [1].


Building and installing:
------------------------

Build requirements:
* Clang-3.5
* LLVM-3.5-dev
* Python2.7
* scikit-learn verion 0.18 
* g++4.8 (OpenMP supports)
* CMake version 2.8.0 or higher
* Boost C++ library

Build:
1. Pull source code
2. Create empty project directory
3. Go to created directoy
4. % cmake ../source_directory 
5. % make all

Running:
--------

1. % cd example
2. % ctest


Directories:
-----------
```
+-- annotation/          -- Annotation toolset
|  +-- python/             - HLS metadata parsing tool
|  +-- llvm/               - Annotation tool
+-- regressor/           -- C++ regressor library (prediction part)
+-- whitebox/            -- White-box power synthesis framework
|  +-- lib/                - Resource-level activity computation library
|  +-- learn/              - Cycle-level power learning tool
|  +-- script/             - CMake script 
+-- graybox/             -- Gray-box power synthesis framework
|  +-- lib/                - Basic block I/O activity computation library
|  +-- learn/              - Block-level power learning tool
|  +-- script/             - CMake script 
+-- blackbox/            -- Black-box power synthesis framework
|  +-- lib/                - External I/O activity computation library
|  +-- learn/              - Invocation-level power learning tool
|  +-- script/             - CMake script 
+-- example/             -- Example 
   +-- dct/                - Pipelined DCT power modeling example
   |   +-- whitebox/          - Whitebox power model synthesis
   |   +-- graybox/           - Graybox power model synthesis
   |   +-- blackbox/          - Blackbox power model synthesis
   |   +-- src/               - Input files for power modeling and test files
   |   +-- powerfile/         - Gate-level measured power traces
   +-- dct_hw_synth/       - Pipelined DCT hardware synthesis and gate-level power measurements example
   |   +-- hls/               - High-level synthesis 
   |   +-- verilog/           - Verilog test
   |   +-- synth/             - Logic synthesis 
   |   +-- gate/              - Gate-level simulation
   |   +-- power/             - Gate-level power measurement
   +-- hdr/                - Pipelined HDR power modeling example
   |   +-- whitebox/          - Whitebox power model synthesis
   |   +-- graybox/           - Graybox power model synthesis
   |   +-- blackbox/          - Blackbox power model synthesis
   |   +-- src/               - Input files for power modeling and test files
   |   +-- powerfile/         - Gate-level measured power traces
   +-- bf_pp/              - Pipelined biliteral filter power modeling example
   |   +-- whitebox/          - Whitebox power model synthesis
   |   +-- graybox/           - Graybox power model synthesis
   |   +-- blackbox/          - Blackbox power model synthesis
   |   +-- src/               - Input files for power modeling and test files
   |   +-- powerfile/         - Gate-level measured power traces
   +-- bf_np/              - Non-Pipelined biliteral filter power modeling example
   |   +-- whitebox/          - Whitebox power model synthesis
   |   +-- graybox/           - Graybox power model synthesis
   |   +-- blackbox/          - Blackbox power model synthesis
   |   +-- src/               - Input files for power modeling and test files
   |   +-- powerfile/         - Gate-level measured power traces
   +-- Gemm/               - Matrix multiplier power modeling data files
   +-- Quant/              - Quantizer power modeling data files
```   

References
----------
[1] D. Lee, A. Gerstlauer, "Learning-Based, Fine-Grain Power Modeling of System-Level Hardware IPs", 
    ACM Transactions on Design Automation of Electronic Systems (TODAES), 2018 (accepted for publication)

---
If you have any questions, please contact:
  Dongwook Lee (dongwook.lee@utexas.edu)
