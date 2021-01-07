# set_param general.maxThreads 24
# Set the working directory path to below mentioned path
#cd C:/Users/khazi/bitstream-awprot/prc_lab_usp-2019.1/
cd C:/Users/khazi/Documents/Master_Thesis/prc_lab_usp-2018.3_awprot_0/

 #####################################
 # Floorplan design 
 #####################################
 file mkdir Implement
 file mkdir Bitstreams

open_checkpoint Synth/top_synth.dcp

read_checkpoint -cell reconfig_leds 															Synth/leftshift.dcp
set_property HD.RECONFIGURABLE 1 [get_cells reconfig_leds]
read_xdc Sources/xdc/fplan_usp.xdc
read_xdc Sources/xdc/top_io_usp.xdc

 #####################################
 # Create First Configuration 
 ##################################### 

opt_design 
place_design 
route_design

write_checkpoint -force Implement/static_left_led.dcp 
report_utilization -file Implement/static_left_led.rpt 
#write_debug_probes -force filename.ltx

 #####################################
 #Lock with Blackbox 
 #####################################

update_design -cells reconfig_leds -black_box
lock_design -level routing
write_checkpoint -force Implement/static_black_box.dcp
report_utilization -file Implement/static_black_box.rpt

 #####################################
 # Create Second Configuration 
 #####################################
 
read_checkpoint -cell reconfig_leds 															Synth/rightshift.dcp 
opt_design 
place_design 
route_design
write_checkpoint -force Implement/static_right_led.dcp 
report_utilization -file Implement/static_right_led.rpt 
close_project


 #####################################
 # Create Blanking Configuration 
 #####################################
 
open_checkpoint Implement/static_black_box.dcp
update_design -buffer_ports -cell reconfig_leds 
opt_design
place_design
route_design
write_checkpoint -force Implement/static_blank_blank.dcp
report_utilization -file Implement/static_blank_blank.rpt 
close_project


 #####################################
 # PR Verify 
 #####################################
 
pr_verify -initial Implement/static_left_led.dcp -additional {Implement/static_right_led.dcp Implement/static_blank_blank.dcp} 
close_project


 #####################################
 # Bitstream Generation 
 #####################################
 
# Generate the bitstreams for the first configuration
open_checkpoint Implement/static_left_led.dcp
write_bitstream -cell reconfig_leds 											Bitstreams/left.bit -force
write_cfgmem -format BIN -interface SMAPx32 -disablebitswap -loadbit "up 0 Bitstreams/left.bit" Bitstreams/left.bin -force
close_project 

#Generate the bitstreams for the second configuration
open_checkpoint Implement/static_right_led.dcp 
write_bitstream -cell reconfig_leds 											Bitstreams/right.bit -force
write_cfgmem -format BIN -interface SMAPx32 -disablebitswap -loadbit "up 0 Bitstreams/right.bit" Bitstreams/right.bin -force
close_project 

#Generate the bitstreams with black boxes
open_checkpoint Implement/static_blank_blank.dcp 
write_bitstream -file Bitstreams/static_blank_blank.bit -no_partial_bitfile -force
write_bitstream -cell reconfig_leds 															Bitstreams/bled.bit -force
write_cfgmem -format BIN -interface SMAPx32 -disablebitswap -loadbit "up 0 Bitstreams/bled.bit" Bitstreams/bled.bin -force
close_project 
