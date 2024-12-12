`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/12/2024 02:37:35 PM
// Design Name: 
// Module Name: state_one_hot_to_binary
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


module state_one_hot_to_binary(
    input [11:0] one_hot,
    output [7:0] binary
    );
    assign binary = 1*one_hot[0]+2*one_hot[1]+3*one_hot[2]+4*one_hot[3]+5*one_hot[4]+6*one_hot[5]+7*one_hot[6]+8*one_hot[7]+9*one_hot[8]+10*one_hot[9]+11*one_hot[10]+12*one_hot[11];
endmodule
