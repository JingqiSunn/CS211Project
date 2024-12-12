`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/12/2024 08:56:40 PM
// Design Name: 
// Module Name: check_uart_in
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


module check_uart_in(
    input uart_rx,
    input reset,
    input clk,
    output reg whether_yes
    );
    
    wire checking_clock;
    reg whether_yes_next;
    reg counter, counter_next;
    Clock_generator_read_uart Clock_generator_read_uart_1(
        .clk_in(clk),
        .reset(reset),
        .standard_clock(checking_clock)
    );
    
    always @(posedge checking_clock, negedge reset)
        begin
            if (~reset)
                begin
                    counter <= 0;
                    whether_yes <= 0;
                end
            else 
                begin
                    counter <= counter_next;
                    whether_yes <= whether_yes_next;
                end
        end
       
    always @(posedge checking_clock)
        begin
            if (uart_rx == 0)
                begin
                    if (counter == 4)
                        begin
                            counter_next <= 4;
                            whether_yes_next <= 1;
                        end
                    else 
                        begin
                            counter_next <= counter + 1;
                            whether_yes_next <= 0;
                        end
                end
            else 
                begin
                   counter_next <= 0;
                   whether_yes_next <= 0; 
                end
        end
endmodule
