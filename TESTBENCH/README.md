# TESTBENCH SIMULATION
This project contains 3 folders, a Sources , Output and Testbench folder. A create.tcl that executes the project. 

Sources   - awprot_full.vhd 
Testbench - tb_axi_burst_lite.vhd and tb_axi_burst_lite_behav.wcfg
Output    - Simulation output .jpg

Note: use the simulation file tb_axi_burst_lite_behav.wcfg, as it contains the necessary signals to understand the task


Awprot source code has Axi4-lite and AXI4 protocol, The Axi4-lite is responsible for PRC configuration, whereas AXI4 reads the Bitstreams from the DDR memory and verifies 
if the FAR(Frame Address Register) for secure region is present in the Bitstream. 
If FAR found then it considers it as a secure Bitstream and AXI-lite will configure the PRC otherwise it will send error response to PS.

# How to execute the code
If u extract this project in C:/projects/ then skip Step1, directly go to Step2 otherwise follow Step1 and then Step2

# Step1:
You have to update the path at 3 locations,
1. In create.tcl file at line number 7, 15 and 20

# Step2:

Open the Vivado 2018.3, in the Tcl console write
1. Source create.tcl
2. File -> Simulation Waveform -> open configuration, and then add the .wcfg file in Testbench folder

