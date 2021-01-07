
#create_pblock pb_X36
#resize_pblock pb_X36 -add SLICE_X36Y59:SLICE_X36Y59
#add_cells_to_pblock pb_X36 [get_cells [list reconfig_leds]] -clear_locs

create_pblock pb_X36
resize_pblock pb_X36 -add {SLICE_X62Y87:SLICE_X71Y107 DSP48E2_X12Y36:DSP48E2_X13Y41 RAMB18_X8Y36:RAMB18_X9Y41 RAMB36_X8Y18:RAMB36_X9Y20}
add_cells_to_pblock pb_X36 [get_cells [list reconfig_leds]] -clear_locs

create_pblock pb_X36_X37
resize_pblock pb_X36_X37 -add {SLICE_X62Y207:SLICE_X71Y227 DSP48E2_X12Y84:DSP48E2_X13Y89 RAMB18_X8Y84:RAMB18_X9Y89 RAMB36_X8Y42:RAMB36_X9Y44}
add_cells_to_pblock pb_X36_X37 [get_cells [list reconfig_leds]] -clear_locs
