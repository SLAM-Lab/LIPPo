Learning-Based, Fine-Grain Power Modeling of System-Level Hardware IPs
======================================================================

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
|  +-- python/              - HLS metadata parsing tool
|  +-- llvm/                - annotation tool
+-- regressor/           -- C++ regressor library (prediction part)
+-- whitebox/            -- White-box power synthesis framework
|  +-- lib/                 - resource-level activity computation library
|  +-- learn/               - cycle-level power learning tool
|  +-- script/              - CMake script 
+-- graybox/             -- Gray-box power synthesis framework
|  +-- lib/                 - basic block I/O activity computation library
|  +-- learn/               - block-level power learning tool
|  +-- script/              - CMake script 
+-- blackbox/            -- Black-box power synthesis framework
|  +-- lib/                 - external I/O activity computation library
|  +-- learn/               - invocation-level power learning tool
|  +-- script/              - CMake script 
+-- example/             -- Example 
    +-- dct_power_model/    - pipelined DCT power modeling example
    |   +-- whitebox/       - whitebox power model synthesis
    |   +-- graybox/        - graybox power model synthesis
    |   +-- blackbox/       - blackbox power model synthesis
    |   +-- src/            - input files for power modeling and test files
    |   +-- powerfile/      - gate-level measured power traces
    +-- dct_hw_synth/    -- Pipelined DCT hardware synthesis and gate-level power measurements example
        +-- hls/            - high-level synthesis 
        +-- verilog/        - verilog test
        +-- synth/          - logic synthesis 
        +-- gate/           - gate-level simulation
        +-- power/          - gate-level power measurement
```   

References
----------
[1] D. Lee, A. Gerstlauer, "Learning-Based, Fine-Grain Power Modeling of
    System-Level Hardware IPs", TODAES, 2017 (Under review)

If you have any questions, please contact:
  Dongwook Lee (dongwook.lee@utexas.edu)
