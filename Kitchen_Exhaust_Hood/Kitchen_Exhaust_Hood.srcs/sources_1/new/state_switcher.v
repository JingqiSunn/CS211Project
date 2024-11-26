`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2024 11:25:14 AM
// Design Name: 
// Module Name: state_switcher
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


module state_switcher(
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
    reg [9:0] accumulator_self_clean_standard;
    reg [15:0] clean_alarm_standard;
    reg [9:0] level_3_accumulator_standard;
    reg [9:0] strong_standby_accumulator_standard;
    reg [3:0] power_off_on_time_standard;
    reg [9:0] accumulator_self_clean_standard_next;
    reg [15:0] clean_alarm_standard_next;
    reg [9:0] level_3_accumulator_standard_next;
    reg [9:0] strong_standby_accumulator_standard_next;
    reg [3:0] power_off_on_time_standard_next;
    reg [9:0] accumulator_self_clean;
    reg [15:0] clean_alarm;
    reg [9:0] level_3_accumulator;
    reg [9:0] strong_standby_accumulator;
    reg [3:0] power_off_on_time;
    reg [9:0] accumulator_self_clean_next;
    reg [15:0] clean_alarm_next;
    reg [9:0] level_3_accumulator_next;
    reg [9:0] strong_standby_accumulator_next;
    reg [3:0] power_off_on_time_next;
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
                    accumulator_self_clean_standard = 10'b0000111100;
                    clean_alarm_standard = 16'b1000110010100000;
                    level_3_accumulator_standard = 10'b0000111100;
                    strong_standby_accumulator = 10'b0000111100;
                    power_off_on_time_standard = 4'b0101;
                    accumulator_self_clean <= 10'b0;
                    clean_alarm <= 16'b0;
                    level_3_accumulator <= 10'b0;
                    strong_standby_accumulator <= 10'b0;
                    power_off_on_time <= 4'b0;
                end
             else
                begin
                    state <= next_state;
                    accumulator_self_clean <= accumulator_self_clean_next;
                    clean_alarm <= clean_alarm_next;
                    level_3_accumulator <= level_3_accumulator_next;
                    strong_standby_accumulator <= strong_standby_accumulator_next;
                    power_off_on_time <= power_off_on_time_next;
                    accumulator_self_clean_standard <= accumulator_self_clean_standard_next;
                    clean_alarm_standard <= clean_alarm_standard_next;
                    level_3_accumulator_standard <= level_3_accumulator_standard_next;
                    strong_standby_accumulator_standard <= strong_standby_accumulator_standard_next;
                    power_off_on_time_standard <= power_off_on_time_standard_next;
                end
        end
     
     always @(state, level_1_button, level_2_button, level_3_button, self_clean_button, power_menu_button_long,power_menu_button_short, edit_state_button,accumulator_self_clean, clean_alarm, level_3_accumulator, power_off_on_time, strong_standby_accumulator)
        begin
            case(state)
                power_off_state: 
                    if (power_menu_button_short) 
                        begin
                            next_state <= standby_state;
                            accumulator_self_clean_next <= accumulator_self_clean;
                            clean_alarm_next <= clean_alarm;
                            level_3_accumulator_next <= level_3_accumulator;
                            strong_standby_accumulator_next <= strong_standby_accumulator;
                            power_off_on_time_next <= power_off_on_time;
                        end      
                    else 
                        begin
                            next_state <= power_off_state;
                            accumulator_self_clean_next <= accumulator_self_clean;
                            clean_alarm_next <= clean_alarm;
                            level_3_accumulator_next <= level_3_accumulator;
                            strong_standby_accumulator_next <= strong_standby_accumulator;
                            power_off_on_time_next <= power_off_on_time;
                        end
                standby_state: 
                    if (power_menu_button_long) 
                        begin
                            next_state <= power_off_b_state;
                            accumulator_self_clean_next <= accumulator_self_clean;
                            clean_alarm_next <= clean_alarm;
                            level_3_accumulator_next <= level_3_accumulator;
                            strong_standby_accumulator_next <= strong_standby_accumulator;
                            power_off_on_time_next <= power_off_on_time;
                        end
                     else if (power_menu_button_short)
                        begin
                            next_state <= menu_state;
                            accumulator_self_clean_next <= accumulator_self_clean;
                            clean_alarm_next <= clean_alarm;
                            level_3_accumulator_next <= level_3_accumulator;
                            strong_standby_accumulator_next <= strong_standby_accumulator;
                            power_off_on_time_next <= power_off_on_time;
                        end
                     else if (edit_state_button) 
                        begin
                            next_state <= edit_state;
                            accumulator_self_clean_next <= accumulator_self_clean;
                            clean_alarm_next <= clean_alarm;
                            level_3_accumulator_next <= level_3_accumulator;
                            strong_standby_accumulator_next <= strong_standby_accumulator;
                            power_off_on_time_next <= power_off_on_time;
                        end
                     else 
                        begin
                            next_state <= standby_state;
                            accumulator_self_clean_next <= accumulator_self_clean;
                            clean_alarm_next <= clean_alarm;
                            level_3_accumulator_next <= level_3_accumulator;
                            strong_standby_accumulator_next <= strong_standby_accumulator;
                            power_off_on_time_next <= power_off_on_time;
                        end
                power_off_b_state: 
                    if (power_menu_button_long) 
                        begin
                           next_state <= power_off_a_state;
                           accumulator_self_clean_next <= accumulator_self_clean;
                           clean_alarm_next <= clean_alarm;
                           level_3_accumulator_next <= level_3_accumulator;
                           strong_standby_accumulator_next <= strong_standby_accumulator;
                           power_off_on_time_next <= power_off_on_time; 
                        end
                     else 
                        begin
                            next_state <= standby_state;
                            accumulator_self_clean_next <= accumulator_self_clean;
                            clean_alarm_next <= clean_alarm;
                            level_3_accumulator_next <= level_3_accumulator;
                            strong_standby_accumulator_next <= strong_standby_accumulator;
                            power_off_on_time_next <= power_off_on_time; 
                        end                     
                power_off_a_state: 
                    if (power_menu_button_long) 
                        begin
                            next_state <= power_off_state;
                            accumulator_self_clean_next <= accumulator_self_clean;
                            clean_alarm_next <= clean_alarm;
                            level_3_accumulator_next <= level_3_accumulator;
                            strong_standby_accumulator_next <= strong_standby_accumulator;
                            power_off_on_time_next <= power_off_on_time;
                        end
                     else 
                        begin
                            next_state <= standby_state;
                            accumulator_self_clean_next <= accumulator_self_clean;
                            clean_alarm_next <= clean_alarm;
                            level_3_accumulator_next <= level_3_accumulator;
                            strong_standby_accumulator_next <= strong_standby_accumulator;
                            power_off_on_time_next <= power_off_on_time;
                        end
                     
                menu_state: 
                    if (level_1_button) 
                        begin
                            next_state <= level_1_state;
                            accumulator_self_clean_next <= accumulator_self_clean;
                            clean_alarm_next <= clean_alarm;
                            level_3_accumulator_next <= level_3_accumulator;
                            strong_standby_accumulator_next <= strong_standby_accumulator;
                            power_off_on_time_next <= power_off_on_time;
                        end
                    else if (level_2_button)
                        begin
                            next_state <= level_2_state;
                            accumulator_self_clean_next <= accumulator_self_clean;
                            clean_alarm_next <= clean_alarm;
                            level_3_accumulator_next <= level_3_accumulator;
                            strong_standby_accumulator_next <= strong_standby_accumulator;
                            power_off_on_time_next <= power_off_on_time;
                        end
                    else if (level_3_button) 
                        begin
                            next_state <= level_3_state;
                            accumulator_self_clean_next <= accumulator_self_clean;
                            clean_alarm_next <= clean_alarm;
                            level_3_accumulator_next <= level_3_accumulator;
                            strong_standby_accumulator_next <= strong_standby_accumulator;
                            power_off_on_time_next <= power_off_on_time;
                        end
                    else if (self_clean_state) 
                        begin
                            next_state <= self_clean_state; 
                            accumulator_self_clean_next <= accumulator_self_clean;
                            clean_alarm_next <= clean_alarm;
                            level_3_accumulator_next <= level_3_accumulator;
                            strong_standby_accumulator_next <= strong_standby_accumulator;
                            power_off_on_time_next <= power_off_on_time;
                        end
                    else 
                        begin
                            next_state <= menu_state;
                            accumulator_self_clean_next <= accumulator_self_clean;
                            clean_alarm_next <= clean_alarm;
                            level_3_accumulator_next <= level_3_accumulator;
                            strong_standby_accumulator_next <= strong_standby_accumulator;
                            power_off_on_time_next <= power_off_on_time;
                        end
                    
                self_clean_state: 
                if (accumulator_self_clean == accumulator_self_clean_standard)
                    begin
                        next_state <= standby_state;
                        accumulator_self_clean_next <= 10'b0;
                        clean_alarm_next <= 16'b0;
                        level_3_accumulator_next <= level_3_accumulator;
                        strong_standby_accumulator_next <= strong_standby_accumulator;
                        power_off_on_time_next <= power_off_on_time;
                    end
                 else 
                    begin
                        next_state <= self_clean_state;
                        accumulator_self_clean_next <= accumulator_self_clean;
                        clean_alarm_next <= clean_alarm;
                        level_3_accumulator_next <= level_3_accumulator;
                        strong_standby_accumulator_next <= strong_standby_accumulator;
                        power_off_on_time_next <= power_off_on_time;
                    end
                edit_state:
                    if (~edit_state_button)
                        begin
                            next_state = standby_state;
                            accumulator_self_clean_next <= accumulator_self_clean;
                            clean_alarm_next <= clean_alarm;
                            level_3_accumulator_next <= level_3_accumulator;
                            strong_standby_accumulator_next <= strong_standby_accumulator;
                            power_off_on_time_next <= power_off_on_time;
                        end
                    else 
                        begin
                            next_state = edit_state;
                            accumulator_self_clean_next <= accumulator_self_clean;
                            clean_alarm_next <= clean_alarm;
                            level_3_accumulator_next <= level_3_accumulator;
                            strong_standby_accumulator_next <= strong_standby_accumulator;
                            power_off_on_time_next <= power_off_on_time; 
                        end
                level_1_state:
                    if (power_menu_button_short)
                        begin
                            next_state = standby_state;
                            accumulator_self_clean_next <= accumulator_self_clean;
                            clean_alarm_next <= clean_alarm + 1;
                            level_3_accumulator_next <= level_3_accumulator;
                            strong_standby_accumulator_next <= strong_standby_accumulator;
                            power_off_on_time_next <= power_off_on_time;
                        end
                     else if (level_2_button)
                        begin
                            next_state = level_2_state;
                            accumulator_self_clean_next <= accumulator_self_clean;
                            clean_alarm_next <= clean_alarm + 1;
                            level_3_accumulator_next <= level_3_accumulator;
                            strong_standby_accumulator_next <= strong_standby_accumulator;
                            power_off_on_time_next <= power_off_on_time;
                        end
                     else 
                        begin
                            next_state = level_1_state;
                            accumulator_self_clean_next <= accumulator_self_clean;
                            clean_alarm_next <= clean_alarm + 1;
                            level_3_accumulator_next <= level_3_accumulator;
                            strong_standby_accumulator_next <= strong_standby_accumulator;
                            power_off_on_time_next <= power_off_on_time;
                        end
                 level_2_state:
                    if (power_menu_button_short)
                        begin
                            next_state = standby_state;
                            accumulator_self_clean_next <= accumulator_self_clean;
                            clean_alarm_next <= clean_alarm + 1;
                            level_3_accumulator_next <= level_3_accumulator;
                            strong_standby_accumulator_next <= strong_standby_accumulator;
                            power_off_on_time_next <= power_off_on_time;
                        end
                     else if (level_1_button)
                        begin
                            next_state = level_1_state;
                            accumulator_self_clean_next <= accumulator_self_clean;
                            clean_alarm_next <= clean_alarm + 1;
                            level_3_accumulator_next <= level_3_accumulator;
                            strong_standby_accumulator_next <= strong_standby_accumulator;
                            power_off_on_time_next <= power_off_on_time;
                        end
                     else 
                        begin
                            next_state = level_2_state;
                            accumulator_self_clean_next <= accumulator_self_clean;
                            clean_alarm_next <= clean_alarm + 1;
                            level_3_accumulator_next <= level_3_accumulator;
                            strong_standby_accumulator_next <= strong_standby_accumulator;
                            power_off_on_time_next <= power_off_on_time;
                        end
                 level_3_state:
                    if (level_3_accumulator == level_3_accumulator_standard)
                        begin
                            next_state = level_2_state;
                            accumulator_self_clean_next <= accumulator_self_clean;
                            clean_alarm_next <= clean_alarm + 1;
                            level_3_accumulator_next <= 10'b0;
                            strong_standby_accumulator_next <= strong_standby_accumulator;
                            power_off_on_time_next <= power_off_on_time;
                        end    
                    else if (power_menu_button_short)
                        begin
                            next_state = strong_standby_state;
                            accumulator_self_clean_next <= accumulator_self_clean;
                            clean_alarm_next <= clean_alarm;
                            level_3_accumulator_next <= 10'b0;
                            strong_standby_accumulator_next <= strong_standby_accumulator;
                            power_off_on_time_next <= power_off_on_time;
                        end
                     else 
                        begin
                            next_state = level_3_state;
                            accumulator_self_clean_next <= accumulator_self_clean;
                            clean_alarm_next <= clean_alarm + 1;
                            level_3_accumulator_next <= level_3_accumulator + 1;
                            strong_standby_accumulator_next <= strong_standby_accumulator;
                            power_off_on_time_next <= power_off_on_time;
                        end
                strong_standby_state:
                    if (strong_standby_accumulator == strong_standby_accumulator_standard)
                        begin
                            next_state = standby_state;
                            accumulator_self_clean_next <= accumulator_self_clean;
                            clean_alarm_next <= clean_alarm;
                            level_3_accumulator_next <= level_3_accumulator;
                            strong_standby_accumulator_next <= 10'b0;
                            power_off_on_time_next <= power_off_on_time;    
                        end
                     else 
                        begin
                            next_state = strong_standby_state;
                            accumulator_self_clean_next <= accumulator_self_clean;
                            clean_alarm_next <= clean_alarm;
                            level_3_accumulator_next <= level_3_accumulator;
                            strong_standby_accumulator_next <= strong_standby_accumulator + 1;
                            power_off_on_time_next <= power_off_on_time;  
                        end
                 default :
                    begin
                            next_state = state;
                            accumulator_self_clean_next <= accumulator_self_clean;
                            clean_alarm_next <= clean_alarm;
                            level_3_accumulator_next <= level_3_accumulator;
                            strong_standby_accumulator_next <= strong_standby_accumulator;
                            power_off_on_time_next <= power_off_on_time;
                    end
            endcase
        end
    
    always @(state)
        begin
            case(state)
                power_off_state: 
                    begin
                        F6 = 0;
                        G4 = 0;
                        G3 = 0;
                        J4 = 0;
                        H4 = 0;
                        J3 = 0;
                        J2 = 0;
                        K2 = 1;
                        H5 = 0;
                    end
                standby_state:
                    begin
                        F6 = 0;
                        G4 = 0;
                        G3 = 0;
                        J4 = 0;
                        H4 = 0;
                        J3 = 0;
                        J2 = 1;
                        K2 = 0;
                        H5 = 0;
                    end
                level_1_state:
                    begin
                        F6 = 0;
                        G4 = 0;
                        G3 = 0;
                        J4 = 0;
                        H4 = 0;
                        J3 = 1;
                        J2 = 0;
                        K2 = 0;
                        H5 = 0;
                    end
                level_2_state:
                    begin
                        F6 = 0;
                        G4 = 0;
                        G3 = 0;
                        J4 = 0;
                        H4 = 1;
                        J3 = 0;
                        J2 = 0;
                        K2 = 0;
                        H5 = 0;
                    end
                level_3_state:
                    begin
                        F6 = 0;
                        G4 = 0;
                        G3 = 0;
                        J4 = 1;
                        H4 = 0;
                        J3 = 0;
                        J2 = 0;
                        K2 = 0;
                        H5 = 0;
                    end
                 self_clean_state:
                    begin
                        F6 = 0;
                        G4 = 0;
                        G3 = 1;
                        J4 = 0;
                        H4 = 0;
                        J3 = 0;
                        J2 = 0;
                        K2 = 0;
                        H5 = 0;
                    end
                 menu_state:
                    begin
                        F6 = 0;
                        G4 = 1;
                        G3 = 0;
                        J4 = 0;
                        H4 = 0;
                        J3 = 0;
                        J2 = 0;
                        K2 = 0;
                        H5 = 0;
                    end
                 strong_standby_state:
                    begin
                        F6 = 1;
                        G4 = 0;
                        G3 = 0;
                        J4 = 0;
                        H4 = 0;
                        J3 = 0;
                        J2 = 0;
                        K2 = 0;
                        H5 = 0;
                    end
                  power_off_b_state:
                    begin
                        F6 = 0;
                        G4 = 0;
                        G3 = 0;
                        J4 = 0;
                        H4 = 0;
                        J3 = 0;
                        J2 = 0;
                        K2 = 0;
                        H5 = 1;
                    end
                  default:
                    begin
                        F6 = 0;
                        G4 = 0;
                        G3 = 0;
                        J4 = 0;
                        H4 = 0;
                        J3 = 0;
                        J2 = 0;
                        K2 = 0;
                        H5 = 0;
                    end
            endcase
        end
        
    always @(power_menu_button_long,power_menu_button_short)
        begin
            if (power_menu_button_long) 
                begin
                    K1 = 1;
                    H6 = 0;
                end
            if (power_menu_button_short) 
                begin
                    K1 = 0;
                    H6 = 1;
                end
            else 
                begin
                    K1 = 0;
                    H6 = 0;
                end
        end
endmodule
