// #####################################################
// #
// #  Partition-based Partial Reconfiguration Reference Design
// #
// #  Parimal Patel, Xilinx University Program, San Jose
// #  October 19, 2016
// #
// #  Targeted for Zynq Boards
// #
// #####################################################

module rModule_leds(clk, reset, en, led);

input clk;
input reset;
input en;
output [3:0] led;

/*
*******************************************
* Signals
*******************************************
*/

reg [3:0] led_reg;
wire [3:0] led;


/*
*******************************************
* Main
*******************************************
*/

assign led = led_reg;

/* Create the counter */
always @(posedge clk or posedge reset)
begin
    if (reset) 
        led_reg <= 4'b1000;
    else 
        if (en) begin
            case (led_reg)
                4'b0001 : led_reg <= 4'b1000;
                4'b0010 : led_reg <= 4'b0001;
                4'b0100 : led_reg <= 4'b0010;
                4'b1000 : led_reg <= 4'b0100;
                default : led_reg <= 4'b1000;        
            endcase
        end
end

        
endmodule
