# User Generated physical constraints 

create_pblock pblock_reconfig_leds
resize_pblock pblock_reconfig_leds -add {SLICE_X62Y87:SLICE_X71Y107 DSP48E2_X12Y36:DSP48E2_X13Y41 RAMB18_X8Y36:RAMB18_X9Y41 RAMB36_X8Y18:RAMB36_X9Y20}
add_cells_to_pblock pblock_reconfig_leds [get_cells [list reconfig_leds]] -clear_locs

# User Generated miscellaneous constraints 

create_pblock pblock_reconfig_leds_2
resize_pblock pblock_reconfig_leds_2 -add {SLICE_X62Y207:SLICE_X71Y227 DSP48E2_X12Y84:DSP48E2_X13Y89 RAMB18_X8Y84:RAMB18_X9Y89 RAMB36_X8Y42:RAMB36_X9Y44}
add_cells_to_pblock pblock_reconfig_leds_2 [get_cells [list reconfig_leds_2]] -clear_locs
