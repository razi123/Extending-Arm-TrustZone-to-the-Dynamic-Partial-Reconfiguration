# TESTBENCH SIMULATION
This project contains a Source folder and 3 tickle files, create.tcl, synth_module.tcl and gen_bitstream.tcl
The Source folder contains, sub folders App, ip_repo, reconfig_modules, rModule_leds, Static, xdc

App - SDK source code in C, It loads the bitstreams from SD card to DDR memory in PS, It configures the PRC, gives user interface to pass the trigger to PRC. 
rModule_leds - Verilog code for Leftshift and Right shift LEDs
Static - Awprot source code in Vhdl, top file in Verilog 

Awprot source code has Axi4-lite and AXI4 protocol, The Axi4-lite is responsible for PRC configuration,  however, AXI4 reads the Bitstreams from the DDR memory and verifies if the FAR(Frame Address Register) for secure region is present in the Bitstream. If FAR found then it considers it as a secure Bitstream and AXI-lite will configure the PRC otherwise it will send error response to PS.



# How to execute the code
If u extract this project in C:/projects/ then skip Step1, directly go to Step2 otherwise follow Step1 and then Step2

# Step1:
You have to update the path at 3 locations,

1. In create.tcl file at line number 6 and 60
2. In synth_module.tcl file at line number 4
3. In gen_bitstream.tcl file at line number 5


# Step2:

Open the Vivado 2018.3, in the Tcl console write
1. Source create.tcl
2. Source synth_module.tcl
3. Source gen_bitstream.tcl









# Errors
In gen_bitstream.tcl step I get this error

Here is the error I got in gen_bitstream.tcl step, 
ERROR: [Opt 31-67] Problem: A LUT6 cell in the design is missing a connection on input pin I0, which is used by the LUT equation. This pin has either been left unconnected in the design or the connection was removed due to the trimming of unused logic. The LUT cell name is: system_wrapper_i/system_i/axi_interconnect_0/s01_mmu/inst/register_slice_inst/ar.ar_pipe/m_valid_i_i_1. Resolution: Please review the preceding OPT INFO messages that detail what has been trimmed in the design to determine if the removal of unused logic is causing this error. If opt_design is being specified directly, it will need to be rerun with opt_design -verbose to generate detailed INFO messages about trimming.
