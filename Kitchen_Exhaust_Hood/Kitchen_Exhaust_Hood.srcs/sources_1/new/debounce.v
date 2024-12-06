`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2024 10:39:35 PM
// Design Name: 
// Module Name: debounce
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


module debounce(
    input wire clk,             
    input wire reset,          
    input wire button_in,      
    output reg button_out     
);
    parameter debounce_count_standard = 20'b11110100001001000000; 
    reg [19:0] debounce_counter;  
    reg button_in_d1;             
    
    
    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            debounce_counter <= 0;
            button_in_d1 <= 0;
            button_out <= 0;
        end else begin
            // Check if the input has been stable for a predefined period
            if (button_in == button_in_d1) begin
                // If the button input hasn't changed, increment the debounce counter
                if (debounce_counter < debounce_count_standard) begin
                    debounce_counter <= debounce_counter + 1;
                end else begin
                    // If the counter reaches the threshold, output the stable value
                    button_out <= button_in_d1;
                end
            end else begin
                // If the input changes, reset the debounce counter
                debounce_counter <= 0;
            end

            // Store the current button input for the next cycle
            button_in_d1 <= button_in;
        end
    end
endmodule

