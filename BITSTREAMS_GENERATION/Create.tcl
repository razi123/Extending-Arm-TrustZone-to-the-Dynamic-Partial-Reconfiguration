#C:/Xilinx/Vivado/2018.3/bin/vivado -mode tcl -source c:/workspace/Vivado/projects/dpr_ps_usp/Create.tcl
set_param general.maxThreads 24
cd C:/Users/khazi/Documents/Master_Thesis/dpr_fine_grain
 #########################################
# Create DCP for reconfigurable module
 #########################################
# the reconfigurable leds are right shifting 
file mkdir Synth
read_verilog Sources/led_shift.v
synth_design -mode out_of_context -flatten_hierarchy rebuilt -top led_shift -part xczu9eg-ffvb1156-2-e
write_checkpoint Synth/shift_synth.dcp -force
report_utilization -file Synth/shift_synth.rpt  -force

close_design
close_project

 #########################################
# Create DCP for Static design
 #########################################

file mkdir Checkpoint
file mkdir Bitstreams
set prj_local prj
create_project $prj_local ./$prj_local -part xczu9eg-ffvb1156-2-e
set_property board_part xilinx.com:zcu102:part0:3.1 [current_project]
set_property  ip_repo_paths  c:/Lab_Project/Lab0425/dpr_ps_usp/ip_repo [current_project]
import_files -norecurse {./Sources/rp_led.v ./Sources/top.v}
set_property  top top  [current_fileset]

launch_runs synth_1
wait_on_run synth_1
open_run synth_1 -name synth_1
wait_on_run synth_1
read_checkpoint -cell reconfig_leds									Synth/shift_synth.dcp
set_property HD.RECONFIGURABLE 1 [get_cells reconfig_leds]
read_xdc  Sources/io_planning.xdc 
write_checkpoint Checkpoint/top_synth.dcp  -force
report_utilization -file Checkpoint/top_synth.rpt  -force
close_project
