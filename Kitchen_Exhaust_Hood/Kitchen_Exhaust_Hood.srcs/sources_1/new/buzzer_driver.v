`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/11/2024 03:23:02 PM
// Design Name: 
// Module Name: buzzer_driver
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


module buzzer_driver (
    input wire clk,         // 100MHz
    input wire button1,     //after debouncing
    input wire button2,     //after debouncing
    input wire button3,
    input wire button4,
    input wire button5,
    input wire [11:0] state,
    output reg buzzer,       
    output  t1
    );
    
    parameter AUDIO_FREQ = 4000;        
    parameter BUZZER_DURATION = 100000; 

    assign t1=1'b0;
    reg [31:0] counter = 0;            
    reg [31:0] buzz_counter = 0;         
    reg audio_clk = 0;                  

    // frequency divisor
    always @(posedge clk) begin
        if (counter >= (100_000_000 / (2 * AUDIO_FREQ)) - 1) begin
            counter <= 0;
            audio_clk <= ~audio_clk; 
        end else begin
            counter <= counter + 1;
        end
    end


    always @(posedge clk) begin
        if ((state != 12'b000000000001)&&(button1 || button2 || button3 || button4 || button5)) begin
            buzz_counter <= BUZZER_DURATION; // æé®æäžåè®¡æ°åšå èœœæç»­æ¶éŽ
        end else if (buzz_counter > 0) begin
            buzz_counter <= buzz_counter - 1;
        end
    end


    always @(posedge clk) begin
        if (buzz_counter > 0)
            buzzer <= audio_clk;
        else
            buzzer <= 0;      
    end
endmodule