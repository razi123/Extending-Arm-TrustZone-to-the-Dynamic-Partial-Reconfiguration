 ###################################
 # Open Vivado GUI
 ####################################
 
set_param general.maxThreads 24

cd C:/projects/Master_Thesis_Simulation/Master_Thesis/TESTBENCH

set prj_local prj
create_project $prj_local ./$prj_local -part xczu9eg-ffvb1156-2-e
set_property board_part xilinx.com:zcu102:part0:3.2 [current_project]
set_property target_language VHDL [current_project]

# Add AWPROT 
add_files -norecurse C:/projects/Master_Thesis_Simulation/Master_Thesis/TESTBENCH/Sources/awprot_full.vhd
update_compile_order -fileset sources_1

# Add Testbench
set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse C:/projects/Master_Thesis_Simulation/Master_Thesis/TESTBENCH/Testbench/tb_axi_burst_lite.vhd
update_compile_order -fileset sim_1
