vivado_hls -f script_roki.tcl
vivado_hls -f script_audi.tcl
mkdir -p ../testvector
cp -r roki/solution1/sim/tv ../testvector/roki_tv
cp -r audi/solution1/sim/tv ../testvector/audi_tv

