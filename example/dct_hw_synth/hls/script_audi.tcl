############################################################
## This file is generated automatically by Vivado HLS.
## Please DO NOT edit it.
## Copyright (C) 2014 Xilinx Inc. All rights reserved.
############################################################
open_project audi
set_top dct
add_files ../src/dct.cpp
add_files -tb ../src/test_dct.cpp -cflags "-DAUDI"
open_solution "solution1"
set_part {xc7z020clg484-1}
create_clock -period 15 -name default
set_clock_uncertainty 1
config_bind -effort medium -min_op mul,add
source "directives.tcl"
csim_design
csynth_design
cosim_design -setup -tool vcs
export_design -format ip_catalog
exit
