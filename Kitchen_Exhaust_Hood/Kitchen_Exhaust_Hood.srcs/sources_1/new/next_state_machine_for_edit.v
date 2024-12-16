`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2024 03:06:48 PM
// Design Name: 
// Module Name: next_state_machine_for_edit
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


module next_state_machine_for_edit(
    input clock_for_edit,
    input reset,
    input level_2_button,
    input power_menu_button,
    input self_clean_button,
    input [27:0] current_time,
    input [5:0] left_right_standard,
    input [2:0] state_in_hour_minute_second,
    input [27:0] self_clean_timer_standard,
    input [27:0] level_3_timer_standard,
    input [27:0] strong_standby_timer_standard,
    input [27:0] total_working_time_standard,
    input [11:0] state,
    input [2:0] state_in_edit_state,
    output reg [27:0] current_time_edit,
    output reg [5:0] left_right_standard_next,
    output reg [2:0] state_in_hour_minute_second_next,
    output reg [27:0] self_clean_timer_standard_next,
    output reg [27:0] level_3_timer_standard_next,
    output reg [27:0] strong_standby_timer_standard_next,
    output reg [27:0] total_working_time_standard_next
    );
    
    //some parameters about state
    parameter 
    power_off_state                 = 12'b000000000001,
    power_off_a_state               = 12'b000000000010,
    power_off_b_state               = 12'b000000000100,
    standby_state                   = 12'b000000001000,
    level_3_state                   = 12'b000000010000,
    level_2_state                   = 12'b000000100000,
    level_1_state                   = 12'b000001000000,
    self_clean_state                = 12'b000010000000,
    menu_state                      = 12'b000100000000,
    edit_state                      = 12'b001000000000,
    strong_standby_state            = 12'b010000000000,  
    show_current_working_state      = 12'b100000000000,   
    change_self_clean               = 3'b001,
    change_left_right               = 3'b010,
    change_work_time_standard       = 3'b011,
    change_strong_standby_standard  = 3'b100,
    change_level_3_standard         = 3'b101,
    change_clock                    = 3'b110,
    hour                            = 3'b100,
    minute                          = 3'b010,
    second                          = 3'b001;    
    
    //update the state information in time
    always @(posedge clock_for_edit, negedge reset)
        begin
            if (~reset)
                begin
                    current_time_edit <= 28'b0;
                    left_right_standard_next <= 6'b000101;
                    state_in_hour_minute_second_next <= second;
                    self_clean_timer_standard_next <= 28'b0000000000000000000010110100;
                    level_3_timer_standard_next <= 28'b0000000000000000000000111100;
                    strong_standby_timer_standard_next <= 28'b0000000000000000000000111100;
                    total_working_time_standard_next <= 28'b0000000000001000110010100000;
                end
            else 
                begin
                    case(state)
                        edit_state:
                            case(state_in_edit_state)
                                change_self_clean:
                                    begin
                                        left_right_standard_next <= left_right_standard;
                                        current_time_edit <= current_time;
                                        if (self_clean_timer_standard_next != self_clean_timer_standard)
                                            begin
                                                state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                                self_clean_timer_standard_next <= self_clean_timer_standard_next;
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                total_working_time_standard_next <= total_working_time_standard;
                                            end
                                        else if (state_in_hour_minute_second_next != state_in_hour_minute_second)
                                            begin
                                                state_in_hour_minute_second_next <= state_in_hour_minute_second_next;
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                total_working_time_standard_next <= total_working_time_standard;
                                            end
                                        else if (level_2_button == 1)
                                            begin
                                                if (state_in_hour_minute_second == second)
                                                    begin   
                                                        state_in_hour_minute_second_next <= minute;
                                                    end
                                                else 
                                                    begin
                                                        state_in_hour_minute_second_next <= second;
                                                    end
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                total_working_time_standard_next <= total_working_time_standard;
                                            end
                                        else if (state_in_hour_minute_second == second && self_clean_button == 1)
                                            begin
                                                state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                                if (self_clean_timer_standard == 28'b0000000000000000111000001111)
                                                    begin
                                                        self_clean_timer_standard_next <= 28'b0;
                                                    end
                                                else 
                                                    begin
                                                        self_clean_timer_standard_next <= self_clean_timer_standard + 1;
                                                    end
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                total_working_time_standard_next <= total_working_time_standard;
                                            end
                                        else if (state_in_hour_minute_second == second && power_menu_button == 1)
                                            begin
                                                state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                                if (self_clean_timer_standard == 28'b0)
                                                    begin
                                                        self_clean_timer_standard_next <= 28'b0000000000000000111000001111;
                                                    end
                                                else 
                                                    begin
                                                        self_clean_timer_standard_next <= self_clean_timer_standard - 1;
                                                    end
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                total_working_time_standard_next <= total_working_time_standard;
                                            end
                                        else if ((state_in_hour_minute_second == minute || state_in_hour_minute_second == hour) && self_clean_button == 1)
                                            begin
                                                state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                                if (self_clean_timer_standard >= 3600 - 59)
                                                    begin
                                                        self_clean_timer_standard_next <= self_clean_timer_standard + 60 - 3600;
                                                    end
                                                else
                                                    begin
                                                        self_clean_timer_standard_next <= self_clean_timer_standard + 60;
                                                    end
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                total_working_time_standard_next <= total_working_time_standard;
                                            end
                                        else if ((state_in_hour_minute_second == minute || state_in_hour_minute_second == hour) && power_menu_button == 1)
                                            begin
                                                state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                                if (self_clean_timer_standard <= 59)
                                                    begin
                                                        self_clean_timer_standard_next <= self_clean_timer_standard + 3600 - 60;
                                                    end
                                                else
                                                    begin
                                                        self_clean_timer_standard_next <= self_clean_timer_standard - 60;
                                                    end
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                total_working_time_standard_next <= total_working_time_standard;
                                            end
                                        else 
                                            begin
                                                state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                total_working_time_standard_next <= total_working_time_standard;
                                            end
                                    end
                                change_left_right:
                                    begin
                                        current_time_edit <= current_time;
                                        if (self_clean_timer_standard_next != self_clean_timer_standard)
                                            begin
                                                state_in_hour_minute_second_next <= second;
                                                self_clean_timer_standard_next <= self_clean_timer_standard_next;
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                total_working_time_standard_next <= total_working_time_standard;
                                                left_right_standard_next <= left_right_standard;
                                            end
                                        else if (left_right_standard_next != left_right_standard)
                                            begin
                                                state_in_hour_minute_second_next <= second;
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                total_working_time_standard_next <= total_working_time_standard;
                                                left_right_standard_next <= left_right_standard_next;
                                            end
                                        else if (self_clean_button == 1)
                                            begin
                                                state_in_hour_minute_second_next <= second;
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                total_working_time_standard_next <= total_working_time_standard;
                                                if (left_right_standard == 59)
                                                    begin
                                                        left_right_standard_next <= 28'b0;
                                                    end
                                                else 
                                                    begin
                                                        left_right_standard_next <= left_right_standard + 1;
                                                    end
                                            end
                                        else if (power_menu_button == 1)
                                            begin
                                                state_in_hour_minute_second_next <= second;
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                total_working_time_standard_next <= total_working_time_standard;
                                                if (left_right_standard == 0)
                                                    begin
                                                        left_right_standard_next <= 59;
                                                    end
                                                else 
                                                    begin
                                                        left_right_standard_next <= left_right_standard - 1;
                                                    end
                                            end
                                        else 
                                            begin
                                                state_in_hour_minute_second_next <= second;
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                total_working_time_standard_next <= total_working_time_standard;
                                                left_right_standard_next <= left_right_standard;
                                            end
                                    end
                                change_work_time_standard:
                                    begin
                                        left_right_standard_next <= left_right_standard;
                                        current_time_edit <= current_time;
                                        if (total_working_time_standard_next != total_working_time_standard)
                                            begin
                                                state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                total_working_time_standard_next <= total_working_time_standard_next;
                                            end
                                        else if (state_in_hour_minute_second_next != state_in_hour_minute_second)
                                            begin
                                                state_in_hour_minute_second_next <= state_in_hour_minute_second_next;
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                total_working_time_standard_next <= total_working_time_standard;
                                            end
                                        else if (level_2_button == 1)
                                            begin
                                                if (state_in_hour_minute_second == second || state_in_hour_minute_second == minute)
                                                    begin   
                                                        state_in_hour_minute_second_next <= hour;
                                                    end
                                                else 
                                                    begin
                                                        state_in_hour_minute_second_next <= minute;
                                                    end
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                total_working_time_standard_next <= total_working_time_standard;
                                            end
                                        else if (state_in_hour_minute_second == hour && self_clean_button == 1)
                                            begin
                                                state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                if (total_working_time_standard >= 86400 - 3599)
                                                    begin
                                                        total_working_time_standard_next <= total_working_time_standard + 3600-86400;
                                                    end
                                                else
                                                    begin
                                                        total_working_time_standard_next <= total_working_time_standard + 3600;
                                                    end 
                                            end
                                        else if (state_in_hour_minute_second == hour && power_menu_button == 1)
                                            begin
                                                state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                if (total_working_time_standard <= 3599)
                                                    begin
                                                        total_working_time_standard_next <= total_working_time_standard + 86400 - 3600;
                                                    end
                                                else
                                                    begin
                                                        total_working_time_standard_next <= total_working_time_standard - 3600;
                                                    end 
                                            end
                                        else if ((state_in_hour_minute_second == minute || state_in_hour_minute_second == second) && self_clean_button == 1)
                                            begin
                                                state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                if (total_working_time_standard >= 86400 - 59)
                                                    begin
                                                        total_working_time_standard_next <= total_working_time_standard + 60 - 86400;
                                                    end
                                                else
                                                    begin
                                                        total_working_time_standard_next <= total_working_time_standard + 60;
                                                    end 
                                            end
                                        else if ((state_in_hour_minute_second == minute || state_in_hour_minute_second == second) && power_menu_button == 1)
                                            begin
                                                state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                if (total_working_time_standard <= 59)
                                                    begin
                                                        total_working_time_standard_next <= total_working_time_standard + 86400 - 60;
                                                    end
                                                else
                                                    begin
                                                        total_working_time_standard_next <= total_working_time_standard - 60;
                                                    end 
                                            end
                                        else 
                                            begin
                                                state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                total_working_time_standard_next <= total_working_time_standard;
                                            end
                                    end
                                change_strong_standby_standard:
                                    begin
                                        left_right_standard_next <= left_right_standard;
                                        current_time_edit <= current_time;
                                        if (strong_standby_timer_standard_next != strong_standby_timer_standard)
                                            begin
                                                state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard_next;
                                                total_working_time_standard_next <= total_working_time_standard;
                                            end
                                        else if (state_in_hour_minute_second_next != state_in_hour_minute_second)
                                            begin
                                                state_in_hour_minute_second_next <= state_in_hour_minute_second_next;
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                total_working_time_standard_next <= total_working_time_standard;
                                            end
                                        else if (level_2_button == 1)
                                            begin
                                                if (state_in_hour_minute_second == second)
                                                    begin   
                                                        state_in_hour_minute_second_next <= minute;
                                                    end
                                                else 
                                                    begin
                                                        state_in_hour_minute_second_next <= second;
                                                    end
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                total_working_time_standard_next <= total_working_time_standard;
                                            end
                                        else if (state_in_hour_minute_second == second && self_clean_button == 1)
                                            begin
                                                state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                if (strong_standby_timer_standard == 28'b0000000000000000111000001111)
                                                    begin
                                                        strong_standby_timer_standard_next <= 28'b0;
                                                    end
                                                else 
                                                    begin
                                                        strong_standby_timer_standard_next <= strong_standby_timer_standard + 1;
                                                    end
                                                total_working_time_standard_next <= total_working_time_standard;
                                            end
                                        else if (state_in_hour_minute_second == second && power_menu_button == 1)
                                            begin
                                                state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                if (strong_standby_timer_standard == 28'b0)
                                                    begin
                                                        strong_standby_timer_standard_next <= 28'b0000000000000000111000001111;
                                                    end
                                                else 
                                                    begin
                                                        strong_standby_timer_standard_next <= strong_standby_timer_standard - 1;
                                                    end
                                                total_working_time_standard_next <= total_working_time_standard;
                                            end
                                        else if ((state_in_hour_minute_second == minute || state_in_hour_minute_second == hour) && self_clean_button == 1)
                                            begin
                                                state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                if (strong_standby_timer_standard >= 3600 - 59)
                                                    begin
                                                        strong_standby_timer_standard_next <= strong_standby_timer_standard + 60 - 3600;
                                                    end
                                                else
                                                    begin
                                                        strong_standby_timer_standard_next <= strong_standby_timer_standard + 60;
                                                    end
                                                total_working_time_standard_next <= total_working_time_standard;
                                            end
                                        else if ((state_in_hour_minute_second == minute || state_in_hour_minute_second == hour) && power_menu_button == 1)
                                            begin
                                                state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                if (strong_standby_timer_standard <= 59)
                                                    begin
                                                        strong_standby_timer_standard_next <= strong_standby_timer_standard + 3600 - 60;
                                                    end
                                                else
                                                    begin
                                                        strong_standby_timer_standard_next <= strong_standby_timer_standard - 60;
                                                    end
                                                total_working_time_standard_next <= total_working_time_standard;
                                            end
                                        else 
                                            begin
                                                state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                total_working_time_standard_next <= total_working_time_standard;
                                            end
                                    end
                                change_level_3_standard:
                                    begin
                                        left_right_standard_next <= left_right_standard;
                                        current_time_edit <= current_time;
                                        if (level_3_timer_standard_next != level_3_timer_standard)
                                            begin
                                                state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                level_3_timer_standard_next <= level_3_timer_standard_next;
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                total_working_time_standard_next <= total_working_time_standard;
                                            end
                                        else if (state_in_hour_minute_second_next != state_in_hour_minute_second)
                                            begin
                                                state_in_hour_minute_second_next <= state_in_hour_minute_second_next;
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                total_working_time_standard_next <= total_working_time_standard;
                                            end
                                        else if (level_2_button == 1)
                                            begin
                                                if (state_in_hour_minute_second == second)
                                                    begin   
                                                        state_in_hour_minute_second_next <= minute;
                                                    end
                                                else 
                                                    begin
                                                        state_in_hour_minute_second_next <= second;
                                                    end
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                total_working_time_standard_next <= total_working_time_standard;
                                            end
                                        else if (state_in_hour_minute_second == second && self_clean_button == 1)
                                            begin
                                                state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                if (level_3_timer_standard == 28'b0000000000000000111000001111)
                                                    begin
                                                        level_3_timer_standard_next <= 28'b0;
                                                    end
                                                else 
                                                    begin
                                                        level_3_timer_standard_next <= level_3_timer_standard + 1;
                                                    end
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                total_working_time_standard_next <= total_working_time_standard;
                                            end
                                        else if (state_in_hour_minute_second == second && power_menu_button == 1)
                                            begin
                                                state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                if (level_3_timer_standard == 28'b0)
                                                    begin
                                                        level_3_timer_standard_next <= 28'b0000000000000000111000001111;
                                                    end
                                                else 
                                                    begin
                                                        level_3_timer_standard_next <= level_3_timer_standard - 1;
                                                    end
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                total_working_time_standard_next <= total_working_time_standard;
                                            end
                                        else if ((state_in_hour_minute_second == minute || state_in_hour_minute_second == hour) && self_clean_button == 1)
                                            begin
                                                state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                if (level_3_timer_standard >= 3600 - 59)
                                                    begin
                                                        level_3_timer_standard_next <= level_3_timer_standard + 60 - 3600;
                                                    end
                                                else
                                                    begin
                                                        level_3_timer_standard_next <= level_3_timer_standard + 60;
                                                    end
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                total_working_time_standard_next <= total_working_time_standard;
                                            end
                                        else if ((state_in_hour_minute_second == minute || state_in_hour_minute_second == hour) && power_menu_button == 1)
                                            begin
                                                state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                if (level_3_timer_standard <= 59)
                                                    begin
                                                        level_3_timer_standard_next <= level_3_timer_standard + 3600 - 60;
                                                    end
                                                else
                                                    begin
                                                        level_3_timer_standard_next <= level_3_timer_standard - 60;
                                                    end
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                total_working_time_standard_next <= total_working_time_standard;
                                            end
                                        else 
                                            begin
                                                state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                total_working_time_standard_next <= total_working_time_standard;
                                            end
                                    end
                                change_clock:
                                    begin
                                        left_right_standard_next <= left_right_standard;
                                        if (current_time_edit != current_time)
                                            begin
                                                state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                level_3_timer_standard_next <= level_3_timer_standard_next;
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                total_working_time_standard_next <= total_working_time_standard;
                                                current_time_edit <= current_time_edit;
                                            end
                                        else if (state_in_hour_minute_second_next != state_in_hour_minute_second)
                                            begin
                                                state_in_hour_minute_second_next <= state_in_hour_minute_second_next;
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                total_working_time_standard_next <= total_working_time_standard;
                                                current_time_edit <= current_time;
                                            end
                                        else if (level_2_button == 1)
                                            begin
                                                if (state_in_hour_minute_second == second)
                                                    begin   
                                                        state_in_hour_minute_second_next <= minute;
                                                    end
                                                else if (state_in_hour_minute_second == minute)
                                                    begin   
                                                        state_in_hour_minute_second_next <= hour;
                                                    end
                                                else
                                                    begin
                                                        state_in_hour_minute_second_next <= second;
                                                    end
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                total_working_time_standard_next <= total_working_time_standard;
                                                current_time_edit <= current_time;
                                            end
                                        else if (state_in_hour_minute_second == second && self_clean_button == 1)
                                            begin
                                                state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                total_working_time_standard_next <= total_working_time_standard;
                                                if (current_time == 86400-1)
                                                    begin
                                                        current_time_edit <= 28'b0;
                                                    end
                                                else
                                                    begin
                                                        current_time_edit <= current_time + 1;
                                                    end 
                                            end
                                        else if (state_in_hour_minute_second == second && power_menu_button == 1)
                                            begin
                                                state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                total_working_time_standard_next <= total_working_time_standard;
                                                if (current_time == 0)
                                                    begin
                                                        current_time_edit <= 86400-1;
                                                    end
                                                else
                                                    begin
                                                        current_time_edit <= current_time - 1;
                                                    end 
                                            end
                                        else if (state_in_hour_minute_second == minute && self_clean_button == 1)
                                            begin
                                                state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                total_working_time_standard_next <= total_working_time_standard;
                                                if (current_time >= 86400-59)
                                                    begin
                                                        current_time_edit <= current_time + 60 - 86400 ;
                                                    end
                                                else
                                                    begin
                                                        current_time_edit <= current_time + 60;
                                                    end 
                                            end
                                        else if (state_in_hour_minute_second == minute && power_menu_button == 1)
                                            begin
                                                state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                total_working_time_standard_next <= total_working_time_standard;
                                                if (current_time <= 59)
                                                    begin
                                                        current_time_edit <= current_time + 86400 - 60;
                                                    end
                                                else
                                                    begin
                                                        current_time_edit <= current_time - 60;
                                                    end 
                                            end
                                        else if (state_in_hour_minute_second == hour && self_clean_button == 1)
                                            begin
                                                state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                total_working_time_standard_next <= total_working_time_standard;
                                                if (current_time >= 86400-3599)
                                                    begin
                                                        current_time_edit <= current_time + 3600 - 86400 ;
                                                    end
                                                else
                                                    begin
                                                        current_time_edit <= current_time + 3600;
                                                    end 
                                            end
                                        else if (state_in_hour_minute_second == hour && power_menu_button == 1)
                                            begin
                                                state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                total_working_time_standard_next <= total_working_time_standard;
                                                if (current_time <= 3599)
                                                    begin
                                                        current_time_edit <= current_time + 86400 - 3600;
                                                    end
                                                else
                                                    begin
                                                        current_time_edit <= current_time - 3600;
                                                    end 
                                            end
                                        else 
                                            begin
                                                state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                                level_3_timer_standard_next <= level_3_timer_standard;
                                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                                total_working_time_standard_next <= total_working_time_standard;
                                                current_time_edit <= current_time;
                                            end
                                    end    
                                default:
                                    begin
                                        current_time_edit <= current_time;
                                        left_right_standard_next <= left_right_standard;
                                        state_in_hour_minute_second_next <= second;
                                        self_clean_timer_standard_next <= self_clean_timer_standard;
                                        level_3_timer_standard_next <= level_3_timer_standard;
                                        strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                        total_working_time_standard_next <= total_working_time_standard;
                                    end
                            endcase
                        default:
                            begin
                                current_time_edit <= current_time;
                                left_right_standard_next <= left_right_standard;
                                state_in_hour_minute_second_next <= second;
                                self_clean_timer_standard_next <= self_clean_timer_standard;
                                level_3_timer_standard_next <= level_3_timer_standard;
                                strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                total_working_time_standard_next <= total_working_time_standard;
                            end
                    endcase            
                end
        end
endmodule
