# set_param general.maxThreads 24
# Set the working directory path to below mentioned path

cd C:/Users/khazi/Documents/Master_Thesis/prc_lab_usp-2018.3_awprot_0

 #####################################
  #Generating the dcp  for each RM
 #####################################
file mkdir Synth


read_verilog Sources/rModule_leds/leftshift/rModule_leds.v
synth_design -mode out_of_context -flatten_hierarchy rebuilt -top rModule_leds -part xczu9eg-ffvb1156-2-e
write_checkpoint Synth/leftshift.dcp -force
report_utilization -file Synth/leftshift.rpt
close_design

read_verilog Sources/rModule_leds/rightshift/rModule_leds.v
synth_design -mode out_of_context -flatten_hierarchy rebuilt -top rModule_leds -part xczu9eg-ffvb1156-2-e
write_checkpoint Synth/rightshift.dcp -force
report_utilization -file Synth/rightshift.rpt

close_design
close_project