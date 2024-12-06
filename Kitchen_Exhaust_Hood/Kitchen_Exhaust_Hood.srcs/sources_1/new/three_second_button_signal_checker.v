`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2024 02:36:09 PM
// Design Name: 
// Module Name: button_touch_length_checker
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


module three_second_button_signal_checker(
    input target_button,
    input clk,
    input reset,
    output reg whether_long_touch,
    output reg whether_short_touch
    );
    reg [1:0] total_duration;  

    always @(posedge clk, negedge reset) 
    begin
        if (~reset)
            begin
               whether_long_touch <= 0;
               whether_short_touch <= 0;
               total_duration <= 2'b0; 
            end
        else 
            begin
                if (target_button && total_duration != 2'b10) 
                    begin
                        total_duration <= total_duration + 1;
                    end 
                else if (target_button && total_duration == 2'b10)
                    begin
                        whether_long_touch <= 1;
                        whether_short_touch <= 0;
                    end
                else if (~target_button)
                    begin
                        if (total_duration != 2'b0  && total_duration < 2'b10) 
                            begin
                                whether_long_touch <= 0;
                                whether_short_touch <= 1;
                            end 
                        else 
                            begin
                                whether_long_touch <= 0;
                                whether_short_touch <= 0;
                            end
                        total_duration <= 2'b0;
                    end
            end
        
    end
endmodule