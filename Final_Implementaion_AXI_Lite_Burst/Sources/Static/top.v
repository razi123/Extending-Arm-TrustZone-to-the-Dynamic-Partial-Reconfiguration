//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.2 (win64) Build 2258646 
//Date        : Wed Mar  6 15:16:51 2019
//Host        : kalpitha running 64-bit major release  (build 9200)
//Command     : generate_target system_wrapper.bd
//Design      : system_wrapper
//Purpose     : IP block netlist
//------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module top
   (led);
    //button_u,   // left_shift_trigger - trigger 0
    //button_d);  // right_shift_trigger
	
  //input button_u;
  //input button_d;
  output [3:0] led;
  
  wire pl_clk0;
  wire pl_resetn0;
  wire ICAP_csib;
  wire [31:0]ICAP_i;
  wire [31:0]ICAP_o;
  wire ICAP_rdwrb;
  wire led_rst; 
  wire led_shift_en;
  wire ICAP_avail;
  wire ICAP_prdone;
  wire ICAP_prerror;
    
  
system_wrapper system_wrapper_i
       (.ICAP_avail(ICAP_avail),
        .ICAP_csib(ICAP_csib),
        .ICAP_i(ICAP_i),
        .ICAP_o(ICAP_o),
        .ICAP_prdone(ICAP_prdone),
        .ICAP_prerror(ICAP_prerror),
        .ICAP_rdwrb(ICAP_rdwrb),
        .icap_clk(pl_clk0),
        .icap_reset(pl_resetn0),
        .pl_clk0(pl_clk0),
        .pl_resetn0(pl_resetn0));

		
	
ICAPE3 #(
		.DEVICE_ID(32'h03628093), // Specifies the pre-programmed Device ID value to be used for simulation purposes.//zcu102
		.ICAP_AUTO_SWITCH("DISABLE"), // Enable switch ICAP using sync word
		.SIM_CFG_FILE_NAME("NONE") // Specifies the Raw Bitstream (RBT) file to be parsed by the simulation model
		)
		ICAPE3_inst (
		.AVAIL(ICAP_avail), // 1-bit output: Availability status of ICAP
		.O(ICAP_o), // 32-bit output: Configuration data output bus
		.PRDONE(ICAP_prdone), // 1-bit output: Indicates completion of Partial Reconfiguration
		.PRERROR(ICAP_prerror), // 1-bit output: Indicates Error during Partial Reconfiguration
		.CLK(pl_clk0), // 1-bit input: Clock input
		.CSIB(ICAP_csib), // 1-bit input: Active-Low ICAP enable
		.I(ICAP_i), // 32-bit input: Configuration data input bus
		.RDWRB(ICAP_rdwrb) // 1-bit input: Read/Write Select input
);

led_control led_control_inst
    (
      .clk(pl_clk0), 
     // .reset(button_c), 
     // .button_start(SW0), 
     //.button_stop(SW1), 
      .rst(~pl_resetn0), 
      .en(led_shift_en)
      );

rModule_leds reconfig_leds
    (
      .clk(pl_clk0), 
      .reset(~pl_resetn0),
      .en(led_shift_en),
      .led(led)
    );

endmodule