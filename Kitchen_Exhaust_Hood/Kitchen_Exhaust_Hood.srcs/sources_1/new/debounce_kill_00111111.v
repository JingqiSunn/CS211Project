`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/13/2024 08:34:36 PM
// Design Name: 
// Module Name: debounce_kill_00111111
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


module debounce_kill_00111111(
    input wire clk,             
    input wire reset,          
    input wire button_in,      
    output reg button_out     
);
    parameter debounce_count_standard = 32000;
    reg [30:0] debounce_counter;  
    reg button_in_d1;             
    
    
    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            debounce_counter <= 0;
            button_in_d1 <= 1;
            button_out <= 1;
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
