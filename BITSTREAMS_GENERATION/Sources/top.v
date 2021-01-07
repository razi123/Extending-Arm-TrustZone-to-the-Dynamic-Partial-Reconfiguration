//Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2014.3 (win64) Build 1034051 Fri Oct  3 17:14:12 MDT 2014
//Date        : Tue Nov 04 12:40:18 2014
//Host        : XSJPARIMALP30 running 64-bit Service Pack 1  (build 7601)
//Command     : generate_target system_wrapper.bd
//Design      : system_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps


module top 
   (clk_pin,
    led_pin,
    rst_pin); 
  output [1:0]led_pin;  
  input 	clk_pin;
  input		rst_pin;
  

rModule_leds reconfig_leds
    (
      .clk(clk_pin), 
      .rst(rst_pin),
      .led(led_pin)
    );
        
 
endmodule
