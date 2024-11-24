`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2024 10:34:19 AM
// Design Name: 
// Module Name: main
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


module main(
    input P5,
    input P4,
    input P3,
    input P2,
    input R2,
    input M4,
    input N4,
    input R1,
    input P17,
    input P15,
    input V1,
    input R15,
    input R11,
    input U4,
    input R17,
    output F6,
    output G4,
    output G3,
    output J4,
    output H4,
    output J3,
    output J2,
    output K2,
    output K1,
    output H6,
    output H5,
    output J5,
    output K6,
    output L1,
    output M1,
    output K3,
    output B4,
    output A4,
    output A3,
    output B1,
    output A1,
    output B3,
    output B2,
    output D5,
    output D4,
    output E3,
    output D3,
    output F4,
    output F3,
    output E2,
    output D2,
    output H2,
    output G2,
    output C2,
    output C1,
    output H1,
    output G1,
    output F1,
    output E1,
    output G6
    );
    wire standard_clock_1;
    wire standard_clock_60;
    standard_clock_generator_60 standard_clock_generator_60_1(
    .clk(P17),
    .reset(P15),
    .standard_clock_1(standard_clock_1),
    .standard_clock_60(standard_clock_60)
    );
    state_switcher state_switcher_1(
    .P5(P5),
    .P4(P4),
    .P3(P3),
    .P2(P2),
    .R2(R2),
    .M4(M4),
    .N4(N4),
    .R1(R1),
    .standard_clock_1(standard_clock_1),
    .standard_clock_60(standard_clock_60),
    .P15(P15),
    .V1(V1),
    .R15(R15),
    .R11(R11),
    .U4(U4),
    .R17(R17),
    .F6(F6),
    .G4(G4),
    .G3(G3),
    .J4(J4),
    .H4(H4),
    .J3(J3),
    .J2(J2),
    .K2(K2),
    .K1(K1),
    .H6(H6),
    .H5(H5),
    .J5(J5),
    .K6(K6),
    .L1(L1),
    .M1(M1),
    .K3(K3),
    .B4(B4),
    .A4(A4),
    .A3(A3),
    .B1(B1),
    .A1(A1),
    .B3(B3),
    .B2(B2),
    .D5(D5),
    .D4(D4),
    .E3(E3),
    .D3(D3),
    .F4(F4),
    .F3(F3),
    .E2(E2),
    .D2(D2),
    .H2(H2),
    .G2(G2),
    .C2(C2),
    .C1(C1),
    .H1(H1),
    .G1(G1),
    .F1(F1),
    .E1(E1),
    .G6(G6)
    );
endmodule
