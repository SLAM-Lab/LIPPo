#!/bin/bash
rm ../tv
ln -s ../testvector/roki_tv ../tv
sed '/AUTOTB_TRANSACTION_NUM/c\`define AUTOTB_TRANSACTION_NUM 3600' ../verilog/dct.autotb.v > dct.autotb.v
bash comp_vcs.sh
bash run_vcs.sh
mv dct_trace.vpd ../power/roki.vpd
rm ../tv
ln -s ../testvector/audi_tv ../tv
sed '/AUTOTB_TRANSACTION_NUM/c\`define AUTOTB_TRANSACTION_NUM 10800' ../verilog/dct.autotb.v > dct.autotb.v
bash comp_vcs.sh
bash run_vcs.sh
mv dct_trace.vpd ../power/audi.vpd
