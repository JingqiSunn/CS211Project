`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/25/2024 01:39:44 PM
// Design Name: 
// Module Name: main_state_switcher
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


module main_state_switcher(
    input edit_state_button,
    input P4,
    input P3,
    input P2,
    input R2,
    input M4,
    input N4,
    input R1,
    input clk,
    input standard_clock_1,
    input standard_clock_60,
    input reset,
    input level_1_button,
    input level_2_button,
    input level_3_button,
    input self_clean_button,
    input power_menu_button_long,
    input power_menu_button_short,
    output reg F6,
    output reg G4,
    output reg G3,
    output reg J4,
    output reg H4,
    output reg J3,
    output reg J2,
    output reg K2,
    output reg K1,
    output reg H6,
    output reg H5,
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
    
    reg [10:0] state, next_state;
    parameter 
    power_off_state           = 11'b00000000001,
    power_off_b_state         = 11'b00000000010,
    power_off_a_state         = 11'b00000000100,
    standby_state             = 11'b00000001000,
    level_3_state             = 11'b00000010000,
    level_2_state             = 11'b00000100000,
    level_1_state             = 11'b00001000000,
    self_clean_state          = 11'b00010000000,
    menu_state                = 11'b00100000000,
    edit_state                = 11'b01000000000,
    strong_standby_state      = 11'b10000000000;
    always @(negedge reset,posedge standard_clock_1)
        begin
            if (~reset)
                begin
                    state <= power_off_state;
                end
             else 
                begin
                    state <= next_state;
                end
        end
     always @(power_menu_button_short, power_menu_button_long, state)
        case (state)
            power_off_state: 
                if (next_state != state) 
                    begin
                        next_state <= next_state; 
                    end
                else if (power_menu_button_short == 0) 
                    begin
                        next_state <= power_off_state;
                    end
                else 
                    begin
                        next_state <= standby_state;
                    end
            standby_state:
                if (next_state != state)
                    begin
                        next_state <= next_state;
                    end    
                else if (power_menu_button_short == 0)
                    begin
                        next_state <= standby_state;
                    end
                else 
                    begin
                        next_state <= power_off_state;
                    end
            default: next_state <= power_off_state;
        endcase
     always @(state)
        begin
        {F6,G4,G3,J4,H4,J3,J2,K2,K1,H6,H5} = state;
        end     
    
    /*
    reg [10:0] state, next_state;
    
    parameter 
    power_off_state           = 11'b00000000001,
    power_off_b_state         = 11'b00000000010,
    power_off_a_state         = 11'b00000000100,
    standby_state             = 11'b00000001000,
    level_3_state             = 11'b00000010000,
    level_2_state             = 11'b00000100000,
    level_1_state             = 11'b00001000000,
    self_clean_state          = 11'b00010000000,
    menu_state                = 11'b00100000000,
    edit_state                = 11'b01000000000,
    strong_standby_state      = 11'b10000000000;
    
    always @(posedge standard_clock_1, negedge reset)
        begin
             if (~reset) 
                begin
                    state <= power_off_state;
                end
             else
                begin
                    state <= next_state;
                end
        end
    
    always @(state, 
             level_1_button, 
             level_2_button, 
             level_3_button, 
             self_clean_button, 
             power_menu_button_long,
             power_menu_button_short, 
             edit_state_button
             accumulator_self_clean, 
             clean_alarm, 
             level_3_accumulator, 
             power_off_on_time, 
             strong_standby_accumulator)
        begin
            case(state)
                power_off_state: 
                    if (next_state != state) 
                        begin
                            next_state <= next_state;
                        end
                    else if (power_menu_button_long) 
                        begin
                            next_state <= standby_state;
                        end
                    else 
                        begin
                            next_state <= power_off_state;
                        end
                standby_state:
                    begin
                        next_state <= power_off_state;
                    end
                default 
                    begin
                        next_state <= power_off_state;
                    end
             endcase
        end
        
        
        
        
        
    always @(power_menu_button_long)
        begin
            if (power_menu_button_long)
                begin
                    F6 = 1;
                end
            else 
                begin
                    F6 = 0;
                end
        end
    always @(power_menu_button_short)
        begin
            if (power_menu_button_short)
                begin
                    G4 = 1;
                end
            else 
                begin
                    G4 = 0;
                end
        end
    always @(standard_clock_1)
        begin
            if (standard_clock_1)
                begin
                    G3 = 1;
                end
            else 
                begin
                    G3 = 0;
                end
        end
    always @(standard_clock_60)
        begin
            if (standard_clock_60)
                begin
                    J4 = 1;
                end
            else 
                begin
                    J4 = 0;
                end
        end
    always @(state)
        if (state == power_off_state)
            begin
                K2 = 1;
            end
        else 
            begin
                K2 = 0;
            end
    always @(state)
        if (state == standby_state)
            begin
                J2 = 1;
            end
        else 
            begin
                J2 = 0;
            end
    */
endmodule