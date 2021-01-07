 ###################################
 # Open Vivado GUI
 ####################################
set_param general.maxThreads 24

cd C:/projects/prc_usp_axi_burst/awprot_working/
set prj_local prj
create_project $prj_local ./$prj_local -part xczu9eg-ffvb1156-2-e
set_property board_part xilinx.com:zcu102:part0:3.2 [current_project]

set_property ip_repo_paths  ./Sources/ip_repo [current_project]
update_ip_catalog
create_bd_design "system"
update_compile_order -fileset sources_1

# Instantiate ZynqMp

create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.2 zynq_ultra_ps_e_0
apply_bd_automation -rule xilinx.com:bd_rule:zynq_ultra_ps_e -config {apply_board_preset "1" }  [get_bd_cells zynq_ultra_ps_e_0]
set_property -dict [list CONFIG.PSU__USE__M_AXI_GP1 {0} CONFIG.PSU__USE__S_AXI_GP2 {1}] [get_bd_cells zynq_ultra_ps_e_0]


# Create Axi-Interconnect
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0
set_property -dict [list CONFIG.NUM_MI {1}] [get_bd_cells axi_interconnect_0]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP0_FPD]


# Create PRC on ultrascale+ board
create_bd_cell -type ip -vlnv xilinx.com:ip:prc:1.3 prc_0
set_property -dict [list CONFIG.ALL_PARAMS {HAS_AXI_LITE_IF 1 RESET_ACTIVE_LEVEL 0 CP_FIFO_DEPTH 32 CP_FIFO_TYPE lutram CDC_STAGES 2 VS {rp_shift {ID 0 NAME rp_shift RM {left {ID 0 NAME left BS {0 {ID 0 ADDR 83886080 SIZE 0 CLEAR 0}}} right {ID 1 NAME right BS {0 {ID 0 ADDR 100663296 SIZE 0 CLEAR 0}}} b_led {ID 2 NAME b_led BS {0 {ID 0 ADDR 117440512 SIZE 0 CLEAR 0}}}} POR_RM left RMS_ALLOCATED 4}} CP_FAMILY ultrascale_plus DIRTY 1} CONFIG.GUI_CDC_STAGES {2} CONFIG.GUI_VS_NEW_NAME {rp_shift} CONFIG.GUI_VS_NUM_RMS_ALLOCATED {4} CONFIG.GUI_SELECT_RM {2} CONFIG.GUI_RM_NEW_NAME {b_led} CONFIG.GUI_BS_ADDRESS_0 {0x7000000} CONFIG.GUI_SELECT_TRIGGER_1 {1} CONFIG.GUI_SELECT_TRIGGER_2 {2} CONFIG.GUI_SELECT_TRIGGER_3 {0}] [get_bd_cells prc_0]
set_property -dict [list CONFIG.ALL_PARAMS {HAS_AXI_LITE_IF 1 RESET_ACTIVE_LEVEL 0 CP_FIFO_DEPTH 32 CP_FIFO_TYPE lutram CDC_STAGES 2 VS {rp_shift {ID 0 NAME rp_shift RM {left {ID 0 NAME left BS {0 {ID 0 ADDR 83886080 SIZE 693472 CLEAR 0}}} right {ID 1 NAME right BS {0 {ID 0 ADDR 100663296 SIZE 693472 CLEAR 0}}} b_led {ID 2 NAME b_led BS {0 {ID 0 ADDR 117440512 SIZE 693472 CLEAR 0}}}} POR_RM left RMS_ALLOCATED 4 HAS_POR_RM 1 NUM_TRIGGERS_ALLOCATED 4}} CP_FAMILY ultrascale_plus DIRTY 2} CONFIG.GUI_VS_NUM_TRIGGERS_ALLOCATED {4} CONFIG.GUI_VS_HAS_POR_RM {1} CONFIG.GUI_SELECT_RM {2} CONFIG.GUI_RM_NEW_NAME {b_led} CONFIG.GUI_BS_ADDRESS_0 {0x7000000} CONFIG.GUI_BS_SIZE_0 {693472}] [get_bd_cells prc_0]


connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins prc_0/m_axi_mem]

# Create Pins
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:icap_rtl:1.0 ICAP
connect_bd_intf_net [get_bd_intf_pins prc_0/ICAP] [get_bd_intf_ports ICAP]
create_bd_port -dir I -type clk icap_clk
connect_bd_net [get_bd_pins /prc_0/icap_clk] [get_bd_ports icap_clk]

create_bd_port -dir I icap_reset
connect_bd_net [get_bd_pins /prc_0/icap_reset] [get_bd_ports icap_reset]
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0
set_property name logic_1 [get_bd_cells xlconstant_0]
set_property -dict [list CONFIG.CONST_VAL {1}] [get_bd_cells logic_1]

connect_bd_net -net [get_bd_nets logic_1_dout] [get_bd_pins prc_0/vsm_rp_shift_rm_shutdown_ack] [get_bd_pins logic_1/dout]

# clock and reset pin going to top
create_bd_port -dir O pl_clk0
connect_bd_net [get_bd_ports pl_clk0] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
create_bd_port -dir O pl_resetn0
connect_bd_net [get_bd_ports pl_resetn0] [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]

#awprot
add_files -norecurse C:/projects/prc_usp_axi_burst/awprot_working/Sources/Static/awprot.vhd
update_compile_order -fileset sources_1
create_bd_cell -type module -reference awprot awprot_0

connect_bd_net [get_bd_pins awprot_0/aclk_0] [get_bd_pins axi_interconnect_0/ACLK]
connect_bd_net [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins awprot_0/aresetn_0]
connect_bd_intf_net [get_bd_intf_pins awprot_0/M00_axi_0] [get_bd_intf_pins prc_0/s_axi_reg]

set_property -dict [list CONFIG.FREQ_HZ {99990005}] [get_bd_intf_pins awprot_0/S00_AXI_REG_0]
set_property -dict [list CONFIG.FREQ_HZ {99990005}] [get_bd_intf_pins awprot_0/M00_axi_0]



# Run Connection Automation
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD" Clk "Auto" }  [get_bd_intf_pins prc_0/s_axi_reg]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)" }  [get_bd_pins zynq_ultra_ps_e_0/saxihp0_fpd_aclk]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)" }  [get_bd_pins axi_interconnect_0/ACLK]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)" }  [get_bd_pins axi_interconnect_0/S00_ACLK]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)} Clk_slave {Auto} Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)} Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} Slave {/awprot_0/S00_AXI_REG_0} intc_ip {/ps8_0_axi_periph} master_apm {0}}  [get_bd_intf_pins awprot_0/S00_AXI_REG_0]
set_property -dict [list CONFIG.ENABLE_ADVANCED_OPTIONS {1} CONFIG.M00_SECURE {1}] [get_bd_cells ps8_0_axi_periph]
save_bd_design

regenerate_bd_layout
update_compile_order -fileset sources_1


# Make Wrapper
make_wrapper -files [get_files $prj_local/$prj_local.srcs/sources_1/bd/system/system.bd] -top
add_files -norecurse $prj_local/$prj_local.srcs/sources_1/bd/system/hdl/system_wrapper.v
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
generate_target all [get_files  ./$prj_local/$prj_local.srcs/sources_1/bd/system/system.bd]
import_files -norecurse {./Sources/Static/rp_led.v ./Sources/Static/led_control.v ./Sources/Static/top.v}
update_compile_order -fileset sources_1

# Disabling source management mode.  This is to allow the top design properties to be set without GUI intervention.
set_property source_mgmt_mode None [current_project]
set_property top top [current_fileset]

# Re-enabling previously disabled source management mode.
set_property source_mgmt_mode All [current_project]
update_compile_order -fileset sources_1
# Run synthesis and wait until synthesis is completed.Then click on Cancel.
launch_runs synth_1 -jobs 4
wait_on_run synth_1

open_run synth_1 -name synth_1
wait_on_run synth_1
file mkdir Synth
write_checkpoint Synth/top_synth.dcp  -force
report_utilization -file Synth/top_synth.rpt  -force

# Exporting design for SDK
file mkdir $prj_local/$prj_local.sdk
write_hwdef -force  -file  $prj_local/$prj_local.sdk/top.hdf
update_compile_order -fileset sources_1

close_project
