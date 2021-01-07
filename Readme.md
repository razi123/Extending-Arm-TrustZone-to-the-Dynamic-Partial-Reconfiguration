# Master Thesis

# 1_AWPROT_lite_4leds
AWPROT module has only axi-lite with 4 leds configured 
awprot[2:0] = "000"
Error = 0

On board : LEDS[0:3]
1 - Left led shift
2 - Right led shift
3 - Blank led

# 2_AWPROT_Unsecure_010
AWPROT module has only axi-lite protocol with LEDS[0:3] shift
awprot[2:0] = "010"
Error = 1
Prints waiting for PRC to shutdown

# 3_FARcheck_SDcard_4leds
AWPROT module has only AXI-lite protocol with LEDS[0:3] shift
awprot[2:0] = "000"
Error = 0

Reads all the Bitstreams from the SD Card before writing to DDR memory, If FAR found then returns XST_SUCCESS and then writes the Bitstream to DDR memory

On board : LEDS[0:3]
1 - Left led shift
2 - Right led shift
3 - Blank led

# 5_AWPORT_8leds
AWPROT module has only AXI-lite  protocol with 8 leds configured, LEDS[0:3] shift if configured in secure region and LEDS[4:7] shift if configured in unsecure region
awprot[2:0] = "000"
Error = 0

On board : LEDS[0:3]
1 - Left led shift
2 - Right led shift
3 - Blank led

On board : LEDS[4:7]
4 - Left led shift
5 - Right led shift
6 - Blank led

# 6_Final_Implementaion_AXI_Lite_Burst
AWPROT module has both AXI-lite write and AXI4 read protocol.
AXI-lite configures the PRC module if awprot = 000, as soon as the SW_Trigger is received the control switches to AXI4 read protocol wile the AXI-lite is still in waiting state.
AXI4 reads the Bitstreams from the DDR memory and if the FAR found then the it gives the control to AXI-Lite which will trigger the PRC. IF FAR is not found during the AXI4 read process then
it gives control to AXI-Lite which will give error response to PS.  
 
awprot[2:0] = "000"
Error = 0

On board : LEDS[0:3]
1 - Left led shift
2 - Right led shift
3 - Blank led

# 7_TESTBENCH
Same operation as 6, Simulation works fine as per the requirement.


# BITSTREAMS
Has Bistreams for the ZCU102 floorplan 

# BITSTREAM_GENERATION
contains a dpr_fine_grain example that generates the bitstreams for all the ZCU102 floor plan.

# PYTHON_SCRIPT_FAR_GEN 
Python script that parces the Bitstreaams and creates a binary file containing the FARs
Later it converts all the binary FARs into Hexadecimal FARs file. 
 



