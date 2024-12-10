`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2024 01:44:01 PM
// Design Name: 
// Module Name: next_state_machine
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


module next_state_machine(
    input [27:0] level_3_timer_standard,
    input [27:0] self_clean_timer_standard,
    input [27:0] strong_standby_timer_standard,
    input power_menu_button_three,
    input the_left_right_signal,
    input the_right_left_signal,
    input reset ,
    input [11:0] state, 
    input power_menu_button_short, 
    input power_menu_button_long, 
    input level_1_button, 
    input level_2_button, 
    input level_3_button, 
    input self_clean_button, 
    input edit_state_button, 
    input show_work_time_state_button,
    input already_use_level_3,
    input [5:0] left_right,
    input [2:0] state_in_edit_state,
    input [27:0] self_clean_timer,
    input [27:0] level_3_timer,
    input [27:0] strong_standby_timer,
    input [27:0] total_working_time,
    output reg already_use_level_3_next,
    output reg [5:0] left_right_next,
    output reg [2:0] state_in_edit_state_next,
    output reg [27:0] self_clean_timer_next,
    output reg [27:0] level_3_timer_next,
    output reg [27:0] strong_standby_timer_next,
    output reg [27:0] total_working_time_next,
    output reg [11:0] next_state
    );
    
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
   
    always @(reset ,state, power_menu_button_short, power_menu_button_long, level_1_button, level_2_button, level_3_button, self_clean_button, edit_state_button, show_work_time_state_button, power_menu_button_three)
        begin
            if (~reset)
                begin
                    already_use_level_3_next <= 1'b0;
                    left_right_next <= 28'b0;
                    state_in_edit_state_next <= change_self_clean;
                    self_clean_timer_next <= 28'b0;
                    level_3_timer_next <= 28'b0;
                    strong_standby_timer_next <= 28'b0;
                    total_working_time_next <= 28'b0;
                    next_state <= power_off_state;
                end
            else    
                begin
                    case (state)
                        power_off_state: 
                            begin
                                already_use_level_3_next <= 1'b0;
                                left_right_next <= 28'b0;
                                state_in_edit_state_next <= change_self_clean;
                                self_clean_timer_next <= 28'b0;
                                level_3_timer_next <= 28'b0;
                                strong_standby_timer_next <= 28'b0;
                                total_working_time_next <= total_working_time;
                                if (next_state != state) 
                                    begin
                                        next_state <= next_state; 
                                    end
                                else if (the_left_right_signal == 1)
                                    begin
                                        next_state <= standby_state;
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
                                already_use_level_3_next <= already_use_level_3;
                                left_right_next <= 28'b0;
                                state_in_edit_state_next <= change_self_clean;
                                self_clean_timer_next <= 28'b0;
                                level_3_timer_next <= 28'b0;
                                strong_standby_timer_next <= 28'b0;
                                total_working_time_next <= total_working_time;
                                if (next_state != state)
                                    begin
                                        next_state <= next_state;
                                    end  
                                else if (the_right_left_signal == 1)
                                    begin
                                        next_state <= power_off_state;
                                    end  
                                else if (show_work_time_state_button == 1)
                                    begin
                                        next_state <= show_current_working_state; 
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
                                already_use_level_3_next <= already_use_level_3;
                                left_right_next <= 28'b0;
                                state_in_edit_state_next <= change_self_clean;
                                self_clean_timer_next <= 28'b0;
                                level_3_timer_next <= 28'b0;
                                strong_standby_timer_next <= 28'b0;
                                total_working_time_next <= total_working_time;
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
                                already_use_level_3_next <= already_use_level_3;
                                left_right_next <= 28'b0;
                                state_in_edit_state_next <= change_self_clean;
                                self_clean_timer_next <= 28'b0;
                                level_3_timer_next <= 28'b0;
                                strong_standby_timer_next <= 28'b0;
                                total_working_time_next <= total_working_time;
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
                                already_use_level_3_next <= already_use_level_3;
                                left_right_next <= 28'b0; 
                                state_in_edit_state_next <= change_self_clean;
                                self_clean_timer_next <= 28'b0;
                                level_3_timer_next <= 28'b0;
                                strong_standby_timer_next <= 28'b0;
                                total_working_time_next <= total_working_time;
                                if (next_state != state)
                                    begin
                                        next_state <= next_state;
                                    end
                                else if (the_right_left_signal == 1)
                                    begin
                                        next_state <= power_off_state;
                                    end 
                                else if (power_menu_button_three == 1'b1)
                                    begin
                                        next_state <= power_off_state;
                                    end
                                else if (level_1_button == 1)
                                    begin
                                        next_state <= level_1_state;
                                    end
                                else if (level_2_button == 1)
                                    begin
                                        next_state <= level_2_state;
                                    end
                                else if (level_3_button == 1 && already_use_level_3 == 1'b0)
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
                        show_current_working_state:
                            begin
                                already_use_level_3_next <= already_use_level_3;
                                left_right_next <= 28'b0; 
                                state_in_edit_state_next <= change_self_clean;
                                self_clean_timer_next <= 28'b0;
                                level_3_timer_next <= 28'b0;
                                strong_standby_timer_next <= 28'b0;
                                total_working_time_next <= total_working_time;
                                if (next_state != state)
                                    begin
                                        next_state <= next_state;
                                    end
                                else if (the_right_left_signal == 1)
                                    begin
                                        next_state <= power_off_state;
                                    end 
                                else if (power_menu_button_three == 1'b1)
                                    begin
                                        next_state <= power_off_state;
                                    end
                                else if (show_work_time_state_button == 0)
                                    begin
                                        next_state <= standby_state;
                                    end
                                else
                                    begin
                                        next_state <= show_current_working_state;
                                    end
                            end
                        edit_state:
                            begin
                                already_use_level_3_next <= already_use_level_3;
                                left_right_next <= 28'b0;
                                self_clean_timer_next <= 28'b0;
                                level_3_timer_next <= 28'b0;
                                strong_standby_timer_next <= 28'b0;
                                total_working_time_next <= total_working_time;
                                if (next_state != state)
                                    begin
                                        next_state <= next_state;
                                        state_in_edit_state_next <= change_self_clean;
                                    end
                                else if (the_right_left_signal == 1)
                                    begin
                                        next_state <= power_off_state;
                                        state_in_edit_state_next <= change_self_clean;
                                    end 
                                else if (power_menu_button_three == 1'b1)
                                    begin
                                        next_state <= power_off_state;
                                        state_in_edit_state_next <= change_self_clean;
                                    end
                                if (state_in_edit_state_next != state_in_edit_state)
                                    begin
                                        next_state <= next_state;
                                        state_in_edit_state_next <= state_in_edit_state_next;
                                    end
                                else if (edit_state_button == 0)
                                    begin
                                        next_state <= standby_state;
                                        state_in_edit_state_next <= change_self_clean;
                                    end
                                else if (level_3_button == 1)
                                    begin
                                        next_state <= edit_state;
                                        if (state_in_edit_state != change_clock)
                                            begin
                                                state_in_edit_state_next <= state_in_edit_state + 1;
                                            end
                                        else 
                                            begin
                                                state_in_edit_state_next <= change_self_clean;
                                            end
                                    end
                                else if (level_1_button == 1)
                                    begin
                                        next_state <= edit_state;
                                        if (state_in_edit_state != change_self_clean)
                                            begin
                                                state_in_edit_state_next <= state_in_edit_state - 1;
                                            end
                                        else 
                                            begin
                                                state_in_edit_state_next <= change_clock;
                                            end
                                    end
                                else 
                                    begin
                                        next_state <= edit_state;
                                        state_in_edit_state_next <= state_in_edit_state;
                                    end
                            end
                        level_1_state:
                            begin
                                already_use_level_3_next <= already_use_level_3;
                                left_right_next <= 28'b0;
                                state_in_edit_state_next <= change_self_clean;
                                self_clean_timer_next <= 28'b0;
                                level_3_timer_next <= 28'b0;
                                strong_standby_timer_next <= 28'b0;
                                total_working_time_next <= total_working_time + 1;
                                if (next_state != state)
                                    begin
                                        next_state <= next_state;
                                    end
                                else if (the_right_left_signal == 1)
                                    begin
                                        next_state <= power_off_state;
                                    end 
                                else if (power_menu_button_three == 1'b1)
                                    begin
                                        next_state <= power_off_state;
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
                                already_use_level_3_next <= already_use_level_3;
                                left_right_next <= 28'b0;
                                state_in_edit_state_next <= change_self_clean;
                                self_clean_timer_next <= 28'b0;
                                level_3_timer_next <= 28'b0;
                                strong_standby_timer_next <= 28'b0;
                                total_working_time_next <= total_working_time + 1;
                                if (next_state != state)
                                    begin
                                        next_state <= next_state;
                                    end
                                else if (the_right_left_signal == 1)
                                    begin
                                        next_state <= power_off_state;
                                    end 
                                else if (power_menu_button_three == 1'b1)
                                    begin
                                        next_state <= power_off_state;
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
                                left_right_next <= 28'b0;
                                state_in_edit_state_next <= change_self_clean;
                                self_clean_timer_next <= 28'b0;
                                strong_standby_timer_next <= 28'b0;
                                total_working_time_next <= total_working_time + 1;
                                begin
                                    if (next_state != state)
                                        begin
                                            next_state <= next_state;
                                            level_3_timer_next <= 28'b0;
                                            already_use_level_3_next <= 1'b1;
                                        end
                                    else if (the_right_left_signal == 1)
                                        begin
                                            next_state <= power_off_state;
                                            level_3_timer_next <= 28'b0;
                                            already_use_level_3_next <= 1'b0;
                                        end 
                                    else if (power_menu_button_three == 1'b1)
                                        begin
                                            next_state <= power_off_state;
                                            level_3_timer_next <= 28'b0;
                                            already_use_level_3_next <= 1'b0;
                                        end
                                    else if (power_menu_button_short == 1)
                                        begin
                                            next_state <= strong_standby_state;
                                            level_3_timer_next <= 28'b0;
                                            already_use_level_3_next <= 1'b1;
                                        end
                                    else if (level_3_timer != level_3_timer_standard)
                                        begin
                                            next_state <= level_3_state;
                                            level_3_timer_next <= level_3_timer + 1;
                                            already_use_level_3_next <= 1'b1;
                                        end
                                    else 
                                        begin
                                            next_state <= level_2_state;
                                            level_3_timer_next <= 28'b0;
                                            already_use_level_3_next <= 1'b0;
                                        end
                                end
                            end
                        self_clean_state:
                            begin
                                already_use_level_3_next <= already_use_level_3;
                                left_right_next <= 28'b0;
                                state_in_edit_state_next <= change_self_clean;
                                level_3_timer_next <= 28'b0;
                                strong_standby_timer_next <= 28'b0;
                                total_working_time_next <= 28'b0;
                                if (next_state != state)
                                    begin
                                        next_state <= next_state;
                                        self_clean_timer_next <= 28'b0;
                                    end
                                else if (the_right_left_signal == 1)
                                    begin
                                        next_state <= power_off_state;
                                        self_clean_timer_next <= 28'b0;
                                    end 
                                else if (power_menu_button_three == 1'b1)
                                    begin
                                        next_state <= power_off_state;
                                        self_clean_timer_next <= 28'b0;
                                    end
                                else if (self_clean_timer != self_clean_timer_standard)
                                    begin
                                        next_state <= self_clean_state;
                                        self_clean_timer_next <= self_clean_timer + 1;
                                    end
                                else 
                                    begin
                                        next_state <= standby_state;
                                        self_clean_timer_next <= 28'b0;
                                    end
                            end
                        strong_standby_state:
                            begin
                                already_use_level_3_next <= already_use_level_3;
                                left_right_next <= 28'b0;
                                state_in_edit_state_next <= change_self_clean;
                                self_clean_timer_next <= 28'b0;
                                level_3_timer_next <= 28'b0;
                                total_working_time_next <= total_working_time;
                                
                                if (next_state != state)
                                    begin
                                        next_state <= next_state;
                                        strong_standby_timer_next <= 28'b0;
                                    end
                                else if (the_right_left_signal == 1)
                                    begin
                                        next_state <= power_off_state;     
                                        strong_standby_timer_next <= 28'b0;
                                    end 
                                else if (power_menu_button_three == 1'b1)
                                    begin
                                        next_state <= power_off_state;
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
                                already_use_level_3_next <= already_use_level_3;
                                left_right_next <= 28'b0;
                                state_in_edit_state_next <= change_self_clean;
                                self_clean_timer_next <= 28'b0;
                                level_3_timer_next <= 28'b0;
                                strong_standby_timer_next <= 28'b0;
                                total_working_time_next <= total_working_time;
                                next_state <= power_off_state;
                            end
                    endcase 
                end
        end
endmodule
