
create_pblock pb_X36_X38
resize_pblock pb_X36_X38 -add SLICE_X36Y59:SLICE_X38Y59
add_cells_to_pblock pb_X36_X38 [get_cells [list reconfig_leds]] -clear_locs
