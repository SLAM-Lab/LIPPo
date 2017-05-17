#!/bin/bash
bash copy.sh #<= latched input, modify tb
bash comp_vcs.sh
rm ../tv
ln -s ../testvector/roki_tv ../tv
sed '/AUTOTB_TRANSACTION_NUM/c\`define AUTOTB_TRANSACTION_NUM 3600' ../verilog/dct.autotb.v > dct.autotb.v
bash run_vcs.sh


