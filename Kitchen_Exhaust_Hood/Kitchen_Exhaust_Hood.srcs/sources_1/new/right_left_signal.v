`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2024 07:34:11 PM
// Design Name: 
// Module Name: left_right_signal
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


module right_left_signal(
    input reset,
    input [5:0] target_time,
    input standard_clock,
    input the_left_right_signal,
    input clk,
    input left_button,
    input right_button,
    output reg left_right_signal_out
//    output reg F6,
//    output reg G4,
//    output reg G3,
//    output reg J4,
//    output reg H4,
//    output reg J3,
//    output reg K3
    
    );
    reg left_right_signal_out_next;
    reg process_begin, process_begin_next;
    reg [5:0] current_time, current_time_next;
    
    reg check_clock;
    
    
    
    always @(posedge standard_clock, negedge reset)
        begin
            if (~reset)
                begin
                    left_right_signal_out <= 1'b0;
                    process_begin <= 1'b0;
                    current_time <= 6'b0;
                end
            else 
                begin
                    left_right_signal_out <= left_right_signal_out_next;
                    process_begin <= process_begin_next;
                    current_time <= current_time_next;
                end
        end


    always @(the_left_right_signal, left_button, right_button)
        begin
            if (process_begin == 1'b0 && right_button == 1'b1)
                begin
                    left_right_signal_out_next <= 1'b0;
                    process_begin_next <= 1'b1;
                    current_time_next <= current_time + 1;
                end
            else if (process_begin == 1'b1 && the_left_right_signal == 1'b1)
                begin
                    left_right_signal_out_next <= 1'b0;
                    process_begin_next <= 1'b0;
                    current_time_next <= 6'b0;
                end
            else if (process_begin == 1'b1 && left_button == 1'b1)
                begin
                    left_right_signal_out_next <= 1'b1;
                    process_begin_next <= 1'b0;
                    current_time_next <= 6'b111111;
                end
            else if (current_time == target_time)
                begin
                    left_right_signal_out_next <= 1'b0;
                    process_begin_next <= 1'b0;
                    current_time_next <= 6'b0;
                end
            else if (process_begin == 1'b1)
                begin
                    left_right_signal_out_next <= 1'b0;
                    process_begin_next <= 1'b1;
                    current_time_next <= current_time + 1;
                end
            else if (process_begin == 1'b0 && process_begin_next == 1'b1)
                begin
                    left_right_signal_out_next <= 1'b0;
                    process_begin_next <= 1'b1;
                    current_time_next <= current_time + 1;
                end
            else 
                begin
                    left_right_signal_out_next <= 1'b0;
                    process_begin_next <= 1'b0;
                    current_time_next <= 6'b0;
                end
        end        
//    always @(*)
//        begin
//            {F6,G4,G3,J4,H4,J3} <= current_time;
//            K3 <= process_begin;
//        end
endmodule
