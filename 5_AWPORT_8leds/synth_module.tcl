# set_param general.maxThreads 24
# Set the working directory path to below mentioned path

cd C:/projects/Master_Thesis/AWPORT_8LEDs

 #####################################
  #Generating the dcp  for each RM
 #####################################
file mkdir Synth


read_verilog Sources/rModule_leds/leftshift/rModule_leds.v
synth_design -mode out_of_context -flatten_hierarchy rebuilt -top rModule_leds -part xczu9eg-ffvb1156-2-e
write_checkpoint Synth/leftshift_0_to_3.dcp -force
report_utilization -file Synth/leftshift_0_to_3.rpt
close_design

read_verilog Sources/rModule_leds/rightshift/rModule_leds.v
synth_design -mode out_of_context -flatten_hierarchy rebuilt -top rModule_leds -part xczu9eg-ffvb1156-2-e
write_checkpoint Synth/rightshift_0_to_3.dcp -force
report_utilization -file Synth/rightshift_0_to_3.rpt
close_design


read_verilog Sources/rModule_leds/leftshift/rModule_leds_2.v
synth_design -mode out_of_context -flatten_hierarchy rebuilt -top rModule_leds_2 -part xczu9eg-ffvb1156-2-e
write_checkpoint Synth/leftshift_4_to_7.dcp -force
report_utilization -file Synth/leftshift_4_to_7.rpt
close_design

read_verilog Sources/rModule_leds/rightshift/rModule_leds_2.v
synth_design -mode out_of_context -flatten_hierarchy rebuilt -top rModule_leds_2 -part xczu9eg-ffvb1156-2-e
write_checkpoint Synth/rightshift_4_to_7.dcp -force
report_utilization -file Synth/rightshift_4_to_7.rpt

close_design






close_project

#0x08000000
#0x05000000
