
# Clock and reset of PS, they get default (lvcmos18) which gives error,
# So we can assign it here
set_property PACKAGE_PIN AE15 [get_ports clk_pin]
set_property IOSTANDARD LVCMOS33 [get_ports clk_pin]
set_property PACKAGE_PIN AE14 [get_ports rst_pin]
set_property IOSTANDARD LVCMOS33 [get_ports rst_pin]

# leds of right_shift 
set_property IOSTANDARD LVCMOS33 [get_ports led_pin[0]]
set_property PACKAGE_PIN AJ15 [get_ports led_pin[0]]
set_property IOSTANDARD LVCMOS33 [get_ports led_pin[1]]
set_property PACKAGE_PIN AH13 [get_ports led_pin[1]]



