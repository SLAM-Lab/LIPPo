####################################################
# Dongwook Lee, 05/30/2013
####################################################
#gui_start
set power_enable_analysis TRUE
set power_analysis_mode time_based
set_app_var link_library /home/polaris/dlee/.local/synopsys_db/NangateOpenCellLibrary.db 
read_verilog ../synth/gate/dct-final.v -hdl_compiler 
current_design dct
set design dct
link_design -keep_sub_designs
#read_sdc ../synth/gate/dct-final.sdc 
read_vcd -strip_path apatb_dct_top/AESL_inst_dct  audi.vcd
set_power_analysis_options -waveform_interval 5 -waveform_format out -waveform_output audi_pwr1
update_power
report_power -verbose -hierarchy > power_report.rpt
exit
