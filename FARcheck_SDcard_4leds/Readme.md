his project contains a Source folder and 3 tickle files, create.tcl, synth_module.tcl and gen_bitstream.tcl The Source folder contains, sub folders App, ip_repo, reconfig_modules, rModule_leds, Static, xdc

App - SDK source code in C, It loads the bitstreams from SD card to DDR memory in PS, It configures the PRC, gives user interface to pass the trigger to PRC. rModule_leds - Verilog code for Leftshift and Right shift LEDs Static - Awprot source code in Vhdl, top file in Verilog

Awprot source code has Axi4-lite and AXI4 protocol, The Axi4-lite is responsible for PRC configuration, however, AXI4 reads the Bitstreams from the DDR memory and verifies if the FAR(Frame Address Register) for secure region is present in the Bitstream. If FAR found then it considers it as a secure Bitstream and AXI-lite will configure the PRC otherwise it will send error response to PS.

How to execute the code
If u extract this project in C:/projects/ then skip Step1, directly go to Step2 otherwise follow Step1 and then Step2

Step1:
You have to update the path at 3 locations,

In create.tcl file at line number 6 and 60
In synth_module.tcl file at line number 4
In gen_bitstream.tcl file at line number 5
Step2:
Open the Vivado 2018.3, in the Tcl console write

Source create.tcl
Source synth_module.tcl
Source gen_bitstream.tcl