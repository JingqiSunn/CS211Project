`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2024 03:18:40 PM
// Design Name: 
// Module Name: standard_clock_generator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: This function can create a standard clock from the clc given by the FPGA, also it allows reset operation.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module standard_clock_generator(
    input clk_in,
    input reset,
    output reg standard_clock
    );
    reg [23:0] accumulator;
    initial 
        begin
            standard_clock = 0;
        end
    always @(posedge clk_in, posedge reset)
        begin
            if (reset)
                begin
                    standard_clock <= 0;
                    accumulator <= 24'b000000000000000000000000;
                end
            else 
                begin
                    accumulator <= accumulator + 1;
                    if (accumulator == 24'b100110001001011010000000)
                        begin
                            accumulator <= 24'b000000000000000000000000;
                            standard_clock <= ~standard_clock;
                        end     
                end
        end
endmodule
