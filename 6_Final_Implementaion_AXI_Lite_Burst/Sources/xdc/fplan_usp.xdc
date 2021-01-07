# User Generated physical constraints

create_pblock pblock_rp_instance
resize_pblock pblock_rp_instance -add {SLICE_X39Y25:SLICE_X49Y47 DSP48E2_X7Y10:DSP48E2_X8Y17 RAMB18_X6Y10:RAMB18_X6Y17 RAMB36_X6Y5:RAMB36_X6Y8}
add_cells_to_pblock pblock_rp_instance [get_cells [list system_wrapper_i/system_i/math_0/inst/math_v1_0_S00_AXI_inst/rp_instance]] -clear_locs

create_pblock pblock_reconfig_leds
resize_pblock pblock_reconfig_leds -add {SLICE_X62Y87:SLICE_X71Y107 DSP48E2_X12Y36:DSP48E2_X13Y41 RAMB18_X8Y36:RAMB18_X9Y41 RAMB36_X8Y18:RAMB36_X9Y20}
add_cells_to_pblock pblock_reconfig_leds [get_cells [list reconfig_leds]] -clear_locs

# User Generated miscellaneous constraints 
