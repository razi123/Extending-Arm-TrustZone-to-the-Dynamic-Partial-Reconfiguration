`timescale 1ns / 1ps
module led_control(clk, rst, en );


input clk;
output rst;
output en;

/*
*******************************************
* Signals
*******************************************
*/


reg clk_en;
reg [24:0] div_counter;
wire rst;
wire en;



/*
*******************************************
* Main
*******************************************
*/



assign en = clk_en;



/* Divide the clock to get a slow clock */
always @(posedge clk)
begin
    if (rst) begin
        clk_en <= 0;
        div_counter <= 0;
    end else begin
        div_counter <= div_counter + 1;
        if (div_counter == 0) 
            clk_en <= 1;
        else
            clk_en <= 0;
	end
end

endmodule