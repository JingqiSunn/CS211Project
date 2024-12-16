`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2024 08:29:38 AM
// Design Name: 
// Module Name: standard_clock_generator_1
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


module standard_clock_generator_1(
    input clk_in,
    input reset,
    output reg standard_clock
    );
    //create a 1hz clock out of a 100mhz clock
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
                    if (accumulator == 26'b10111110101111000010000000)
                        begin
                            accumulator <= 26'b00000000000000000000000000;
                            standard_clock <= ~standard_clock;
                        end     
                end
        end
endmodule
