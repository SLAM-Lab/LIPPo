#!/bin/bash
cp ../hls/roki/solution1/sim/verilog/*.v .
# remove 'bx 
sed '/''bx/d' dct.v > _dct.v
mv _dct.v  dct.v
# set clock period to 5 ns
sed -e '/define AUTOTB_CLOCK_PERIOD/c\`define AUTOTB_CLOCK_PERIOD 5.0' -e '/AESL_clock = 0;/c\AESL_clock=1;' dct.autotb.v > _dct.autotb.v
mv _dct.autotb.v  dct.autotb.v
