
create_pblock pb_X36
resize_pblock pb_X36 -add SLICE_X36Y59:SLICE_X36Y59
add_cells_to_pblock pb_X36 [get_cells [list reconfig_leds]] -clear_locs
