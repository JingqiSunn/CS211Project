`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/12/2024 09:01:59 PM
// Design Name: 
// Module Name: Clock_generator_read_uart
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


module Clock_generator_read_uart(
    input clk_in,
    input reset,
    output reg standard_clock
    );
    reg [25:0] accumulator;
    initial 
        begin
            standard_clock = 1;
        end
    always @(posedge clk_in, negedge reset)
        begin
            if (~reset)
                begin
                    standard_clock <= 1;
                    accumulator <= 26'b00000000000000000000000000;
                end
            else 
                begin
                    accumulator <= accumulator + 1;
                    if (accumulator == 5208)
                        begin
                            accumulator <= 26'b00000000000000000000000000;
                            standard_clock <= ~standard_clock;
                        end     
                end
        end
endmodule