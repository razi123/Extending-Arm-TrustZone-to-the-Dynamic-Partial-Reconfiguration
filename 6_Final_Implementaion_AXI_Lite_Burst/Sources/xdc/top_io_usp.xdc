# GPIO_LED_0  DS38.2
set_property PACKAGE_PIN AG14 [get_ports led[0]] 
set_property IOSTANDARD LVCMOS33 [get_ports led[0]]

# GPIO_LED_1  DS37.2
set_property PACKAGE_PIN AF13 [get_ports led[1]]
set_property IOSTANDARD LVCMOS33 [get_ports led[1]]

# GPIO_LED_2  DS39.2
set_property PACKAGE_PIN AE13 [get_ports led[2]]
set_property IOSTANDARD LVCMOS33 [get_ports led[2]]

# GPIO_LED_3  DS40.2
set_property PACKAGE_PIN AJ14 [get_ports led[3]]
set_property IOSTANDARD LVCMOS33 [get_ports led[3]]



#GPIO_SW_N  
set_property PACKAGE_PIN AG15 [get_ports button_r]
set_property IOSTANDARD LVCMOS33 [get_ports button_r]

#GPIO_SW_E 
set_property PACKAGE_PIN AE14 [get_ports button_l]
set_property IOSTANDARD LVCMOS33 [get_ports button_l]

#GPIO_SW_C  SW15.3
set_property PACKAGE_PIN AG13 [get_ports button_c]
set_property IOSTANDARD LVCMOS33 [get_ports button_c]

#GPIO_SW_W 
set_property PACKAGE_PIN AF15 [get_ports button_u]
set_property IOSTANDARD LVCMOS33 [get_ports button_u]

# GPIO_SW_S  SW16.3
set_property PACKAGE_PIN AE15 [get_ports button_d]
set_property IOSTANDARD LVCMOS33 [get_ports button_d]

#SW0  GPIO_DIP_SW1  SW13.7
set_property PACKAGE_PIN AP14 [get_ports SW0]
set_property IOSTANDARD LVCMOS33 [get_ports SW0]

#SW1 GPIO_DIP_SW3  SW13.5
set_property PACKAGE_PIN AN13 [get_ports SW1]
set_property IOSTANDARD LVCMOS33 [get_ports SW1]


