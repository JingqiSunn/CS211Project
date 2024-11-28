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
    output reg J5,
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
    
    reg [27:0] self_clean_timer;
    reg [27:0] self_clean_timer_next;
    reg [27:0] self_clean_timer_standard;
    reg [27:0] self_clean_timer_standard_next;
    
    reg [27:0] level_3_timer;
    reg [27:0] level_3_timer_next;
    reg [27:0] level_3_timer_standard;
    reg [27:0] level_3_timer_standard_next;
    
    reg [27:0] strong_standby_timer;
    reg [27:0] strong_standby_timer_next;
    reg [27:0] strong_standby_timer_standard;
    reg [27:0] strong_standby_timer_standard_next;
    
    
    
    
    parameter 
    power_off_state           = 11'b00000000001,
    power_off_a_state         = 11'b00000000010,
    power_off_b_state         = 11'b00000000100,
    standby_state             = 11'b00000001000,
    level_3_state             = 11'b00000010000,
    level_2_state             = 11'b00000100000,
    level_1_state             = 11'b00001000000,
    self_clean_state          = 11'b00010000000,
    menu_state                = 11'b00100000000,
    edit_state                = 11'b01000000000,
    strong_standby_state      = 11'b10000000000;
    
    
    assign K6 = level_1_button;
    assign L1 = level_2_button;
    assign M1 = level_3_button;
    assign K3 = self_clean_button;
    always @(posedge standard_clock_1, negedge reset)
        begin
             if (~reset) 
                begin
                    state <= power_off_state;
                    self_clean_timer <= 28'b0;
                    self_clean_timer_standard <= 28'b0000000000000000000000000100;
                    level_3_timer <= 28'b0;
                    level_3_timer_standard <= 28'b0000000000000000000000001000;
                    strong_standby_timer <= 28'b0;
                    strong_standby_timer_standard <= 28'b0000000000000000000000001000;
                end
             else
                begin
                    state <= next_state;
                    self_clean_timer <= self_clean_timer_next;
                    self_clean_timer_standard <= self_clean_timer_standard_next;
                    level_3_timer <= level_3_timer_next;
                    level_3_timer_standard <= level_3_timer_standard_next;
                    strong_standby_timer <= strong_standby_timer_next;
                    strong_standby_timer_standard <= strong_standby_timer_standard_next;
                end
        end
     always @(state, power_menu_button_short, power_menu_button_long, level_1_button, level_2_button, level_3_button, self_clean_button, edit_state_button)
        case (state)
            power_off_state: 
                begin
                    self_clean_timer_next <= 28'b0;
                    self_clean_timer_standard_next <= self_clean_timer_standard;
                    level_3_timer_next <= 28'b0;
                    level_3_timer_standard_next <= level_3_timer_standard;
                    strong_standby_timer_next <= 28'b0;
                    strong_standby_timer_standard_next <= strong_standby_timer_standard;
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
                end
            standby_state:
                begin
                    self_clean_timer_next <= 28'b0;
                    self_clean_timer_standard_next <= self_clean_timer_standard;
                    level_3_timer_next <= 28'b0;
                    level_3_timer_standard_next <= level_3_timer_standard;
                    strong_standby_timer_next <= 28'b0;
                    strong_standby_timer_standard_next <= strong_standby_timer_standard;
                    if (next_state != state)
                        begin
                            next_state <= next_state;
                        end    
                    else if (edit_state_button == 1)
                        begin
                            next_state <= edit_state; 
                        end
                    else if (power_menu_button_long == 1)
                        begin
                            next_state <= power_off_b_state;
                        end
                    else if (power_menu_button_short == 1)
                        begin
                            next_state = menu_state;
                        end
                    else 
                        begin
                            next_state <= standby_state;
                        end
                end
            power_off_b_state:
                begin
                    self_clean_timer_next <= 28'b0;
                    self_clean_timer_standard_next <= self_clean_timer_standard;
                    level_3_timer_next <= 28'b0;
                    level_3_timer_standard_next <= level_3_timer_standard;
                    strong_standby_timer_next <= 28'b0;
                    strong_standby_timer_standard_next <= strong_standby_timer_standard;
                    if (next_state != state)
                        begin
                            next_state <= next_state;
                        end
                    else if (power_menu_button_long == 1)
                        begin
                            next_state <= power_off_a_state;
                        end
                    else 
                        begin
                            next_state <= standby_state;
                        end
                end
            power_off_a_state:
                begin
                    self_clean_timer_next <= 28'b0;
                    self_clean_timer_standard_next <= self_clean_timer_standard;
                    level_3_timer_next <= 28'b0;
                    level_3_timer_standard_next <= level_3_timer_standard;
                    strong_standby_timer_next <= 28'b0;
                    strong_standby_timer_standard_next <= strong_standby_timer_standard;
                    if (next_state != state)
                        begin
                            next_state <= next_state;
                        end
                    else if (power_menu_button_long == 1)
                        begin
                            next_state <= power_off_state;
                        end
                    else 
                        begin
                            next_state <= standby_state;
                        end
                end
            menu_state:
                begin   
                    self_clean_timer_next <= 28'b0;
                    self_clean_timer_standard_next <= self_clean_timer_standard;
                    level_3_timer_next <= 28'b0;
                    level_3_timer_standard_next <= level_3_timer_standard;
                    strong_standby_timer_next <= 28'b0;
                    strong_standby_timer_standard_next <= strong_standby_timer_standard;
                    if (next_state != state)
                        begin
                            next_state <= next_state;
                        end
                    else if (level_1_button == 1)
                        begin
                            next_state <= level_1_state;
                        end
                    else if (level_2_button == 1)
                        begin
                            next_state <= level_2_state;
                        end
                    else if (level_3_button == 1)
                        begin
                            next_state <= level_3_state;
                        end
                    else if (self_clean_button == 1)
                        begin
                            next_state <= self_clean_state;
                        end
                    else
                        begin
                            next_state <= menu_state;
                        end
                end
            edit_state:
                begin
                    self_clean_timer_next <= 28'b0;
                    self_clean_timer_standard_next <= self_clean_timer_standard;
                    level_3_timer_next <= 28'b0;
                    level_3_timer_standard_next <= level_3_timer_standard;
                    strong_standby_timer_next <= 28'b0;
                    strong_standby_timer_standard_next <= strong_standby_timer_standard;
                    if (next_state != state)
                        begin
                            next_state <= next_state;
                        end
                    else if (edit_state_button == 0)
                        begin
                            next_state <= standby_state;
                        end
                    else 
                        begin
                            next_state <= edit_state;
                        end
                end
            level_1_state:
                begin
                    self_clean_timer_next <= 28'b0;
                    self_clean_timer_standard_next <= self_clean_timer_standard;
                    level_3_timer_next <= 28'b0;
                    level_3_timer_standard_next <= level_3_timer_standard;
                    strong_standby_timer_next <= 28'b0;
                    strong_standby_timer_standard_next <= strong_standby_timer_standard;
                    if (next_state != state)
                        begin
                            next_state <= next_state;
                        end
                    else if (level_2_button == 1) 
                        begin
                            next_state <= level_2_state;
                        end
                    else if (power_menu_button_short == 1)
                        begin
                            next_state <= standby_state;
                        end
                    else
                        begin
                            next_state <= level_1_state;
                        end
                end
            level_2_state:
                begin
                    self_clean_timer_next <= 28'b0;
                    self_clean_timer_standard_next <= self_clean_timer_standard;
                    level_3_timer_next <= 28'b0;
                    level_3_timer_standard_next <= level_3_timer_standard;
                    strong_standby_timer_next <= 28'b0;
                    strong_standby_timer_standard_next <= strong_standby_timer_standard;
                    if (next_state != state)
                        begin
                            next_state <= next_state;
                        end
                    else if (level_1_button == 1) 
                        begin
                            next_state <= level_1_state;
                        end
                    else if (power_menu_button_short == 1)
                        begin
                            next_state <= standby_state;
                        end
                    else
                        begin
                            next_state <= level_2_state;
                        end
                 end
            level_3_state:
                begin
                    self_clean_timer_next <= 28'b0;
                    self_clean_timer_standard_next <= self_clean_timer_standard;
                    strong_standby_timer_next <= 28'b0;
                    strong_standby_timer_standard_next <= strong_standby_timer_standard;
                    level_3_timer_standard_next <= level_3_timer_standard;
                    begin
                        if (next_state != state)
                            begin
                                next_state <= next_state;
                                level_3_timer_next <= 28'b0;
                            end
                        else if (power_menu_button_short == 1)
                            begin
                                next_state <= strong_standby_state;
                                level_3_timer_next <= 28'b0;
                            end
                        else if (level_3_timer != level_3_timer_standard)
                            begin
                                next_state <= level_3_state;
                                level_3_timer_next <= level_3_timer + 1;
                            end
                        else 
                            begin
                                next_state <= level_2_state;
                                level_3_timer_next <= 28'b0;
                            end
                    end
                end
            self_clean_state:
                begin
                    level_3_timer_next <= 28'b0;
                    level_3_timer_standard_next <= level_3_timer_standard;
                    strong_standby_timer_next <= 28'b0;
                    strong_standby_timer_standard_next <= strong_standby_timer_standard;
                    if (next_state != state)
                        begin
                            next_state <= next_state;
                            self_clean_timer_next <= 28'b0;
                            self_clean_timer_standard_next <= self_clean_timer_standard;
                        end
                    else if (self_clean_timer != self_clean_timer_standard)
                        begin
                            next_state <= self_clean_state;
                            self_clean_timer_next <= self_clean_timer + 1;
                            self_clean_timer_standard_next <= self_clean_timer_standard;
                        end
                    else 
                        begin
                            next_state <= standby_state;
                            self_clean_timer_next <= 28'b0;
                            self_clean_timer_standard_next <= self_clean_timer_standard;
                        end
                end
            strong_standby_state:
                begin
                    self_clean_timer_next <= 28'b0;
                    self_clean_timer_standard_next <= self_clean_timer_standard;
                    level_3_timer_next <= 28'b0;
                    level_3_timer_standard_next <= level_3_timer_standard;
                    strong_standby_timer_standard_next <= strong_standby_timer_standard;
                    if (next_state != state)
                        begin
                            next_state <= next_state;
                            strong_standby_timer_next <= 28'b0;
                        end
                    else if (strong_standby_timer != strong_standby_timer_standard)
                        begin
                            next_state <= strong_standby_state;
                            strong_standby_timer_next <= strong_standby_timer + 1;
                        end
                    else 
                        begin
                            next_state <= standby_state;
                            strong_standby_timer_next <= 28'b0;
                        end
                end
            default:
                begin
                    self_clean_timer_next <= 28'b0;
                    self_clean_timer_standard_next <= self_clean_timer_standard;
                    level_3_timer_next <= 28'b0;
                    level_3_timer_standard_next <= level_3_timer_standard;
                    strong_standby_timer_next <= 28'b0;
                    strong_standby_timer_standard_next <= strong_standby_timer_standard;
                    next_state <= power_off_state;
                end
        endcase
     always @(state)
        begin
            {F6, G4, G3, J4, H4, J3, J2, K2, K1, H6, H5} = state;
        end
endmodule