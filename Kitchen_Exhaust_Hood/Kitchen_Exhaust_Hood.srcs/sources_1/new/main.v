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
    wire level_1_button, level_2_button, level_3_button, self_clean_button, power_menu_button;
    debounce debounce_1(.clk(P17), .reset(P15), .button_in(R17), .button_out(power_menu_button));
    debounce debounce_2(.clk(P17), .reset(P15), .button_in(V1), .button_out(level_1_button));
    debounce debounce_3(.clk(P17), .reset(P15), .button_in(R15), .button_out(level_2_button));
    debounce debounce_4(.clk(P17), .reset(P15), .button_in(R11), .button_out(level_3_button));
    debounce debounce_5(.clk(P17), .reset(P15), .button_in(U4), .button_out(self_clean_button));
    wire standard_clock_1;
    wire standard_clock_60;
    standard_clock_generator_60 standard_clock_generator_60_1(
    .clk(P17),
    .reset(P15),
    .standard_clock_1(standard_clock_1),
    .standard_clock_60(standard_clock_60)
    );
    wire power_menu_button_long;
    wire power_menu_button_short;
    button_touch_length_checker button_touch_length_checker_1(
    .target_button(power_menu_button),
    .clk(P17),
    .reset(P15),
    .whether_long_touch(power_menu_button_long),
    .whether_short_touch(power_menu_button_short)
    );
    main_state_switcher main_state_switcher_1(
    .edit_state_button(P5),
    .P4(P4),
    .P3(P3),
    .P2(P2),
    .R2(R2),
    .M4(M4),
    .N4(N4),
    .R1(R1),
    .clk(P17),
    .standard_clock_1(standard_clock_1),
    .standard_clock_60(standard_clock_60),
    .reset(P15),
    .level_1_button(level_1_button),
    .level_2_button(level_2_button),
    .level_3_button(level_3_button),
    .self_clean_button(self_clean_button),
    .power_menu_button_long(power_menu_button_long),
    .power_menu_button_short(power_menu_button_short),
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
