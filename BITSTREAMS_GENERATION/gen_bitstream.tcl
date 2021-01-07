cd C:/Users/khazi/Documents/Master_Thesis/dpr_fine_grain

 #########################################
# Generating bitstream for different pblocks
 #########################################
# X36 - Single CLB does not work
open_checkpoint Checkpoint/top_synth.dcp 
read_xdc  Sources/pb_X36.xdc
opt_design 
place_design 
route_design
write_checkpoint -force Checkpoint/top_route_design.dcp 
write_bitstream -cell reconfig_leds -raw_bitfile -file Bitstreams/pb_X36.bit -force
#write_bitstream -file Bitstreams/staticright.bit -force
close_project


# X37 - Single CLB does not work
open_checkpoint Checkpoint/top_synth.dcp 
read_xdc  Sources/pb_X37.xdc
opt_design 
place_design 
route_design
write_checkpoint -force Checkpoint/top_route_design.dcp 
write_bitstream -cell reconfig_leds -raw_bitfile -file Bitstreams/pb_X37.bit -force
close_project


# X36 - X37 - CLB does not work
open_checkpoint Checkpoint/top_synth.dcp 
read_xdc  Sources/pb_X36_X37.xdc
opt_design 
place_design 
route_design
write_checkpoint -force Checkpoint/top_route_design.dcp 
write_bitstream -cell reconfig_leds -raw_bitfile -file Bitstreams/pb_X36_X37.bit -force
close_project


# X36 - 37 - X38 - CLB Works - but only 37 and 38 are considered in pblock.
open_checkpoint Checkpoint/top_synth.dcp 
read_xdc  Sources/pb_X36_X38.xdc
opt_design 
place_design 
route_design
write_checkpoint -force Checkpoint/top_route_design.dcp 
write_bitstream -cell reconfig_leds -raw_bitfile -file Bitstreams/pb_X36_X38.bit -force
close_project




