#!/bin/bash
vpd2vcd roki.vpd roki.vcd
pt_shell -f roki_script.tcl
rm roki.vcd 
vpd2vcd audi.vpd audi.vcd
pt_shell -f audi_script.tcl
rm audi.vcd
