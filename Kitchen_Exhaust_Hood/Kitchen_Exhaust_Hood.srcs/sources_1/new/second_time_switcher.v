`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2024 01:17:35 PM
// Design Name: 
// Module Name: second_time_switcher
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


module second_time_switcher(
    input [27:0] total_seconds, 
    output reg [5:0] hour_0,          
    output reg [5:0] hour_1,         
    output reg [5:0] minute_0, 
    output reg [5:0] minute_1,       
    output reg [5:0] second_0,        
    output reg [5:0] second_1         
);
    
    reg [4:0] hours;   
    reg [5:0] minutes; 
    reg [5:0] seconds; 

    always @ (total_seconds)
    begin
        hours = total_seconds / 3600;              
        minutes = (total_seconds % 3600) / 60;    
        seconds = total_seconds % 60;        
        
        hour_0 = hours / 10;
        hour_1 = hours % 10; 

        minute_0 = minutes / 10;  
        minute_1 = minutes % 10;  

        second_0 = seconds / 10;  
        second_1 = seconds % 10;  
    end

endmodule

