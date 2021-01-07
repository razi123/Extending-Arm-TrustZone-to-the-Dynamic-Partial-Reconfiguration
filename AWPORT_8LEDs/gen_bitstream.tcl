# set_param general.maxThreads 24
# Set the working directory path to below mentioned path
#cd C:/Users/khazi/bitstream-awprot/prc_lab_usp-2019.1/
cd C:/projects/Master_Thesis/AWPORT_8LEDs

 #####################################
 # Floorplan design 
 #####################################
 file mkdir Implement
 file mkdir Bitstreams

open_checkpoint Synth/top_synth.dcp

read_checkpoint -cell reconfig_leds 															Synth/leftshift_0_to_3.dcp
set_property HD.RECONFIGURABLE 1 [get_cells reconfig_leds]
read_checkpoint -cell reconfig_leds_2 															Synth/leftshift_4_to_7.dcp
set_property HD.RECONFIGURABLE 1 [get_cells reconfig_leds_2]

read_xdc Sources/xdc/fplan_usp.xdc
read_xdc Sources/xdc/top_io_usp.xdc




 #####################################
 # Create First Configuration 
 ##################################### 

opt_design 
place_design 
route_design

write_checkpoint -force Implement/static_left_led_0_to_3.dcp 
report_utilization -file Implement/static_left_led_0_to_3.rpt 

write_checkpoint -force Implement/static_left_led_4_to_7.dcp 
report_utilization -file Implement/static_left_led_4_to_7.rpt 
#write_debug_probes -force filename.ltx

 #####################################
 #Lock with Blackbox 
 #####################################

update_design -cells reconfig_leds -black_box
update_design -cells reconfig_leds_2 -black_box
lock_design -level routing
write_checkpoint -force Implement/static_black_box.dcp
report_utilization -file Implement/static_black_box.rpt

 #####################################
 # Create Second Configuration 
 #####################################
 
read_checkpoint -cell reconfig_leds 															Synth/rightshift_0_to_3.dcp
read_checkpoint -cell reconfig_leds_2 															Synth/rightshift_4_to_7.dcp
 
opt_design 
place_design 
route_design
write_checkpoint -force Implement/static_right_led_0_to_3.dcp 
report_utilization -file Implement/static_right_led_0_to_3.rpt 

write_checkpoint -force Implement/static_right_led_4_to_7.dcp 
report_utilization -file Implement/static_right_led_4_to_7.rpt 
close_project


 #####################################
 # Create Blanking Configuration 
 #####################################
 
open_checkpoint Implement/static_black_box.dcp
update_design -buffer_ports -cell reconfig_leds 
update_design -buffer_ports -cell reconfig_leds_2

opt_design
place_design
route_design
write_checkpoint -force Implement/static_blank_blank.dcp
report_utilization -file Implement/static_blank_blank.rpt 

close_project


 #####################################
 # PR Verify 
 #####################################
 
pr_verify -initial Implement/static_left_led_0_to_3.dcp -additional {Implement/static_right_led_0_to_3.dcp Implement/static_blank_blank.dcp} 
close_project
pr_verify -initial Implement/static_left_led_4_to_7.dcp -additional {Implement/static_right_led_4_to_7.dcp Implement/static_blank_blank.dcp} 
close_project


 #####################################
 # Bitstream Generation 
 #####################################
 
# Generate the bitstreams for the first configuration
open_checkpoint Implement/static_left_led_0_to_3.dcp
write_bitstream -cell reconfig_leds 											Bitstreams/left_03.bit -force
write_cfgmem -format BIN -interface SMAPx32 -disablebitswap -loadbit "up 0 Bitstreams/left_03.bit" Bitstreams/left_03.bin -force
close_project 

open_checkpoint Implement/static_left_led_4_to_7.dcp
write_bitstream -cell reconfig_leds_2 											Bitstreams/left_47.bit -force
write_cfgmem -format BIN -interface SMAPx32 -disablebitswap -loadbit "up 0 Bitstreams/left_47.bit" Bitstreams/left_47.bin -force
close_project 

#Generate the bitstreams for the second configuration
open_checkpoint Implement/static_right_led_0_to_3.dcp 
write_bitstream -cell reconfig_leds 											Bitstreams/right_03.bit -force
write_cfgmem -format BIN -interface SMAPx32 -disablebitswap -loadbit "up 0 Bitstreams/right_03.bit" Bitstreams/right_03.bin -force
close_project 

open_checkpoint Implement/static_right_led_4_to_7.dcp 
write_bitstream -cell reconfig_leds_2											Bitstreams/right_47.bit -force
write_cfgmem -format BIN -interface SMAPx32 -disablebitswap -loadbit "up 0 Bitstreams/right_47.bit" Bitstreams/right_47.bin -force
close_project 

#Generate the bitstreams with black boxes
open_checkpoint Implement/static_blank_blank.dcp 
write_bitstream -file Bitstreams/static_blank_blank.bit -no_partial_bitfile -force
write_bitstream -cell reconfig_leds 															Bitstreams/bled_03.bit -force
write_cfgmem -format BIN -interface SMAPx32 -disablebitswap -loadbit "up 0 Bitstreams/bled_03.bit" Bitstreams/bled_03.bin -force
close_project 

open_checkpoint Implement/static_blank_blank.dcp 
write_bitstream -file Bitstreams/static_blank_blank.bit -no_partial_bitfile -force
write_bitstream -cell reconfig_leds_2 															Bitstreams/bled_47.bit -force
write_cfgmem -format BIN -interface SMAPx32 -disablebitswap -loadbit "up 0 Bitstreams/bled_47.bit" Bitstreams/bled_47.bin -force
close_project 



