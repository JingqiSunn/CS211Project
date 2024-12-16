`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2024 08:31:22 AM
// Design Name: 
// Module Name: standard_clock_generator_60
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


module standard_clock_generator_60(
    input clk,
    input reset,
    output standard_clock_1,
    output reg standard_clock_60
    );
    //get a one minute clock out of a 1 second one
    wire fake_reset = 1;
    reg [5:0] accumulator;
    standard_clock_generator_1(.clk_in(clk),.reset(fake_reset),.standard_clock(standard_clock_1));
    always @(posedge standard_clock_1, negedge reset)
        begin
            if (~reset)
                begin
                    standard_clock_60 <= 1;
                    accumulator <= 6'b000000;
                end
            else 
                begin
                    accumulator <= accumulator + 1;
                    if (accumulator == 6'b111100)
                        begin
                            accumulator <= 6'b000000;
                            standard_clock_60 <= ~standard_clock_60;
                        end     
                end
        end
endmodule