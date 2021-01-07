`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.10.2017 17:11:03
// Design Name: 
// Module Name: led_switch
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//right shift of 3 leds 
module led_shift(
    input clk,
    input rst,
    output [1:0] led
    );
	
    reg[1:0] count;
    reg[1:0] led_driver;
	wire [1:0] led;
	
	
	assign led = led_driver ;
    always @(posedge clk or posedge rst)
        begin
            if(rst)
                begin
                    count <= 2'd0;
                    led_driver <= 2'b01;
                end    
            else
                begin    
                    if (count > 2'd2)
                        begin
                            led_driver <= {led_driver[0], led_driver[1]};
                            count <= 2'd0;
                        end
                    else
                        count <= count + 1;
                end
        end
		

endmodule
