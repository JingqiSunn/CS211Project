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
    input light_mode_button,
    input clk,
    input standard_clock_1,
    input standard_clock_60,
    input reset,
    input level_1_button,
    input level_2_button,
    input level_3_button,
    input self_clean_button,
    input power_menu_button,
    input power_menu_button_long,
    input power_menu_button_short,
    input power_menu_button_three,
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
    output reg M1,
    output reg K3,
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
    wire the_left_right_signal;
    wire clock_for_edit;
    standard_clock_generator_edit standard_clock_generator_edit_1(
    .clk_in(clk),
    .reset(reset),
    .standard_clock(clock_for_edit)
    );
    reg [10:0] state, next_state;
    reg [2:0] state_in_edit_state, state_in_edit_state_next;
    reg [2:0] state_in_hour_minute_second, state_in_hour_minute_second_next;
    
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
    
    reg [27:0] current_time;
    reg [27:0] current_time_next;
    reg [27:0] current_time_edit;
    
    reg [27:0] total_working_time;
    reg [27:0] total_working_time_next;
    reg [27:0] total_working_time_standard;
    reg [27:0] total_working_time_standard_next;
    
    reg [5:0] left_right, left_right_next;
    reg [5:0] left_right_standard, left_right_standard_next;
    
    
    reg [5:0] content_0, content_1, content_2,content_3, content_4, content_5, content_6, content_7;
    wire [5:0] hour_0, hour_1, minute_0, minute_1, second_0, second_1;
    wire [5:0] self_clean_hour_0_useless, self_clean_hour_1_useless, self_clean_minute_0, self_clean_minute_1, self_clean_second_0, self_clean_second_1; 
    wire [5:0] self_clean_edit_hour_0_useless, self_clean_edit_hour_1_useless, self_clean_edit_minute_0, self_clean_edit_minute_1, self_clean_edit_second_0, self_clean_edit_second_1; 
    wire [5:0] level_3_hour_0_useless, level_3_hour_1_useless, level_3_minute_0, level_3_minute_1, level_3_second_0, level_3_second_1; 
    wire [5:0] strong_standby_hour_0_useless, strong_standby_hour_1_useless, strong_standby_minute_0, strong_standby_minute_1, strong_standby_second_0, strong_standby_second_1;    
    wire [5:0] total_working_time_hour_0, total_working_time_hour_1, total_working_time_minute_0, total_working_time_minute_1, total_working_time_second_0, total_working_time_second_1; 
    wire [5:0] left_right_edit_hour_0_useless, left_right_edit_hour_1_useless, left_right_edit_minute_0_useless, left_right_edit_minute_1_useless, left_right_edit_second_0, left_right_edit_second_1;    
    wire [5:0] total_working_standard_edit_hour_0, total_working_standard_edit_hour_1, total_working_standard_edit_minute_0, total_working_standard_edit_minute_1, total_working_standard_edit_second_0_useless, total_working_standard_edit_second_1_useless;   
    wire [5:0] strong_standby_standard_edit_hour_0_useless, strong_standby_standard_edit_hour_1_useless, strong_standby_standard_edit_minute_0, strong_standby_standard_edit_minute_1, strong_standby_standard_edit_second_0, strong_standby_standard_edit_second_1;   
    wire [5:0] level_3_standard_edit_hour_0_useless, level_3_standard_edit_hour_1_useless, level_3_standard_edit_minute_0, level_3_standard_edit_minute_1, level_3_standard_edit_second_0, level_3_standard_edit_second_1;   
      
    
    
    parameter 
    power_off_state                 = 11'b000000000001,
    power_off_a_state               = 11'b000000000010,
    power_off_b_state               = 11'b000000000100,
    standby_state                   = 11'b000000001000,
    level_3_state                   = 11'b000000010000,
    level_2_state                   = 11'b000000100000,
    level_1_state                   = 11'b000001000000,
    self_clean_state                = 11'b000010000000,
    menu_state                      = 11'b000100000000,
    edit_state                      = 11'b001000000000,
    strong_standby_state            = 11'b010000000000,     
    change_self_clean               = 3'b001,
    change_left_right               = 3'b010,
    change_work_time_standard       = 3'b011,
    change_strong_standby_standard  = 3'b100,
    change_level_3_standard         = 3'b101,
    change_clock                    = 3'b110,
    hour                            = 3'b100,
    minute                          = 3'b010,
    second                          = 3'b001;
    
    
   
    second_time_switcher second_time_switcher_for_clock(
    .total_seconds(current_time), 
    .hour_0(hour_0),          
    .hour_1(hour_1),         
    .minute_0(minute_0), 
    .minute_1(minute_1),       
    .second_0(second_0),        
    .second_1(second_1)  
    );
    
    second_time_switcher second_time_switcher_for_self_clean(
    .total_seconds(self_clean_timer_standard - self_clean_timer), 
    .hour_0(self_clean_hour_0_useless),          
    .hour_1(self_clean_hour_1_useless),         
    .minute_0(self_clean_minute_0), 
    .minute_1(self_clean_minute_1),       
    .second_0(self_clean_second_0),        
    .second_1(self_clean_second_1)  
    );
    
    second_time_switcher second_time_switcher_for_self_clean_edit(
    .total_seconds(self_clean_timer_standard), 
    .hour_0(self_clean_edit_hour_0_useless),          
    .hour_1(self_clean_edit_hour_1_useless),         
    .minute_0(self_clean_edit_minute_0), 
    .minute_1(self_clean_edit_minute_1),       
    .second_0(self_clean_edit_second_0),        
    .second_1(self_clean_edit_second_1)  
    );
    
    second_time_switcher second_time_switcher_for_level_3(
    .total_seconds(level_3_timer_standard - level_3_timer), 
    .hour_0(level_3_hour_0_useless),          
    .hour_1(level_3_hour_1_useless),         
    .minute_0(level_3_minute_0), 
    .minute_1(level_3_minute_1),       
    .second_0(level_3_second_0),        
    .second_1(level_3_second_1)  
    );
    
    second_time_switcher second_time_switcher_for_strong_standby(
    .total_seconds(strong_standby_timer_standard - strong_standby_timer), 
    .hour_0(strong_standby_hour_0_useless),          
    .hour_1(strong_standby_hour_1_useless),         
    .minute_0(strong_standby_minute_0), 
    .minute_1(strong_standby_minute_1),       
    .second_0(strong_standby_second_0),        
    .second_1(strong_standby_second_1)  
    );
    
    second_time_switcher second_time_switcher_for_total_working_time(
    .total_seconds(total_working_time), 
    .hour_0(total_working_time_hour_0),          
    .hour_1(total_working_time_hour_1),         
    .minute_0(total_working_time_minute_0), 
    .minute_1(total_working_time_minute_1),       
    .second_0(total_working_time_second_0),        
    .second_1(total_working_time_second_1)  
    );
    
    second_time_switcher second_time_switcher_for_left_right(
    .total_seconds({22'b0,left_right_standard}), 
    .hour_0(left_right_edit_hour_0_useless),          
    .hour_1(left_right_edit_hour_1_useless),         
    .minute_0(left_right_edit_minute_0_useless), 
    .minute_1(left_right_edit_minute_1_useless),       
    .second_0(left_right_edit_second_0),        
    .second_1(left_right_edit_second_1)  
    );
    
    second_time_switcher second_time_switcher_for_total_working_time_standard(
    .total_seconds(total_working_time_standard), 
    .hour_0(total_working_standard_edit_hour_0),          
    .hour_1(total_working_standard_edit_hour_1),         
    .minute_0(total_working_standard_edit_minute_0), 
    .minute_1(total_working_standard_edit_minute_1),       
    .second_0(total_working_standard_edit_second_0_useless),        
    .second_1(total_working_standard_edit_second_1_useless)  
    );
    
    second_time_switcher second_time_switcher_for_strong_standby_standard(
    .total_seconds(strong_standby_timer_standard), 
    .hour_0(strong_standby_standard_edit_hour_0_useless),          
    .hour_1(strong_standby_standard_edit_hour_1_useless),         
    .minute_0(strong_standby_standard_edit_minute_0), 
    .minute_1(strong_standby_standard_edit_minute_1),       
    .second_0(strong_standby_standard_edit_second_0),        
    .second_1(strong_standby_standard_edit_second_1)  
    );
    
    second_time_switcher second_time_switcher_for_level_3_edit(
    .total_seconds(level_3_timer_standard), 
    .hour_0(level_3_standard_edit_hour_0_useless),          
    .hour_1(level_3_standard_edit_hour_1_useless),         
    .minute_0(level_3_standard_edit_minute_0), 
    .minute_1(level_3_standard_edit_minute_1),       
    .second_0(level_3_standard_edit_second_0),        
    .second_1(level_3_standard_edit_second_1)  
    );
    always @(posedge standard_clock_1, negedge reset)
        begin
             if (~reset) 
                begin
                    state <= power_off_state;
                    state_in_edit_state <= change_self_clean;
                    self_clean_timer <= 28'b0;
                    self_clean_timer_standard <= 28'b0000000000000000000000000100;
                    level_3_timer <= 28'b0;
                    level_3_timer_standard <= 28'b0000000000000000000000001000;
                    strong_standby_timer <= 28'b0;
                    strong_standby_timer_standard <= 28'b0000000000000000000000001000;
                    current_time <= 28'b0;
                    total_working_time <= 28'b0;
                    total_working_time_standard <= 28'b0000000000000000000000000010;
                    state_in_hour_minute_second <= second;
                    left_right <= 6'b0;
                    left_right_standard <= 6'b000101;
                end
             else
                begin
                    state <= next_state;
                    state_in_edit_state <= state_in_edit_state_next;
                    self_clean_timer <= self_clean_timer_next;
                    self_clean_timer_standard <= self_clean_timer_standard_next;
                    level_3_timer <= level_3_timer_next;
                    level_3_timer_standard <= level_3_timer_standard_next;
                    strong_standby_timer <= strong_standby_timer_next;
                    strong_standby_timer_standard <= strong_standby_timer_standard_next;
                    if (current_time != current_time_edit && current_time_edit == 28'b0000000000010101000110000000)
                        begin
                            current_time <= 28'b0;
                        end
                    else if (current_time != current_time_edit)
                        begin
                            current_time <= current_time_edit;
                        end
                    else if (current_time_next == 28'b0000000000010101000110000000)
                        begin
                            current_time <= 28'b0;
                        end
                    else
                        begin
                            current_time <= current_time_next;
                        end
                    if (total_working_time_next == total_working_time_standard + 1 )
                        begin
                            total_working_time <= total_working_time;
                        end
                    else 
                        begin
                            total_working_time <= total_working_time_next;
                        end
                    total_working_time_standard <= total_working_time_standard_next;
                    state_in_hour_minute_second <= state_in_hour_minute_second_next;
                    left_right <= left_right_next;
                    left_right_standard <= left_right_standard_next;
                end
        end
     
     
     left_right_signal left_right_signal_1(
        .reset(reset),
        .target_time(left_right_standard),
        .clk(clk),
        .standard_clock(standard_clock_1),
        .left_button(level_1_button),
        .right_button(level_3_button),
        .left_right_signal_out(the_left_right_signal)
    ); 
    
    
     always @(state, power_menu_button_short, power_menu_button_long, level_1_button, level_2_button, level_3_button, self_clean_button, edit_state_button)
        case (state)
            power_off_state: 
                begin
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
                    else if (edit_state_button == 1)
                        begin
                            next_state <= edit_state; 
                        end
                    else if (the_left_right_signal == 1)
                        begin
                            next_state <= power_off_state;
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
                            end
                        else if (power_menu_button_three == 1'b1)
                            begin
                                next_state <= power_off_state;
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
                    left_right_next <= 28'b0;
                    state_in_edit_state_next <= change_self_clean;
                    self_clean_timer_next <= 28'b0;
                    level_3_timer_next <= 28'b0;
                    strong_standby_timer_next <= 28'b0;
                    total_working_time_next <= total_working_time;
                    next_state <= power_off_state;
                end
        endcase
    always @(posedge clock_for_edit)
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
                                        self_clean_timer_standard_next <= self_clean_timer_standard + 1;
                                        level_3_timer_standard_next <= level_3_timer_standard;
                                        strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                        total_working_time_standard_next <= total_working_time_standard;
                                    end
                                else if (state_in_hour_minute_second == second && power_menu_button == 1)
                                    begin
                                        state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                        self_clean_timer_standard_next <= self_clean_timer_standard - 1;
                                        level_3_timer_standard_next <= level_3_timer_standard;
                                        strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                        total_working_time_standard_next <= total_working_time_standard;
                                    end
                                else if ((state_in_hour_minute_second == minute || state_in_hour_minute_second == hour) && self_clean_button == 1)
                                    begin
                                        state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                        self_clean_timer_standard_next <= self_clean_timer_standard + 60;
                                        level_3_timer_standard_next <= level_3_timer_standard;
                                        strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                        total_working_time_standard_next <= total_working_time_standard;
                                    end
                                else if ((state_in_hour_minute_second == minute || state_in_hour_minute_second == hour) && power_menu_button == 1)
                                    begin
                                        state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                        self_clean_timer_standard_next <= self_clean_timer_standard - 60;
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
                                        left_right_standard_next <= left_right_standard + 1;
                                    end
                                else if (power_menu_button == 1)
                                    begin
                                        state_in_hour_minute_second_next <= second;
                                        self_clean_timer_standard_next <= self_clean_timer_standard;
                                        level_3_timer_standard_next <= level_3_timer_standard;
                                        strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                        total_working_time_standard_next <= total_working_time_standard;
                                        left_right_standard_next <= left_right_standard - 1;
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
                                        total_working_time_standard_next <= total_working_time_standard + 3600;
                                    end
                                else if (state_in_hour_minute_second == hour && power_menu_button == 1)
                                    begin
                                        state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                        self_clean_timer_standard_next <= self_clean_timer_standard;
                                        level_3_timer_standard_next <= level_3_timer_standard;
                                        strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                        total_working_time_standard_next <= total_working_time_standard - 3600;
                                    end
                                else if ((state_in_hour_minute_second == minute || state_in_hour_minute_second == second) && self_clean_button == 1)
                                    begin
                                        state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                        self_clean_timer_standard_next <= self_clean_timer_standard;
                                        level_3_timer_standard_next <= level_3_timer_standard;
                                        strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                        total_working_time_standard_next <= total_working_time_standard + 60;
                                    end
                                else if ((state_in_hour_minute_second == minute || state_in_hour_minute_second == second) && power_menu_button == 1)
                                    begin
                                        state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                        self_clean_timer_standard_next <= self_clean_timer_standard;
                                        level_3_timer_standard_next <= level_3_timer_standard;
                                        strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                        total_working_time_standard_next <= total_working_time_standard - 60;
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
                                        strong_standby_timer_standard_next <= strong_standby_timer_standard + 1;
                                        total_working_time_standard_next <= total_working_time_standard;
                                    end
                                else if (state_in_hour_minute_second == second && power_menu_button == 1)
                                    begin
                                        state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                        self_clean_timer_standard_next <= self_clean_timer_standard;
                                        level_3_timer_standard_next <= level_3_timer_standard;
                                        strong_standby_timer_standard_next <= strong_standby_timer_standard - 1;
                                        total_working_time_standard_next <= total_working_time_standard;
                                    end
                                else if ((state_in_hour_minute_second == minute || state_in_hour_minute_second == hour) && self_clean_button == 1)
                                    begin
                                        state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                        self_clean_timer_standard_next <= self_clean_timer_standard;
                                        level_3_timer_standard_next <= level_3_timer_standard;
                                        strong_standby_timer_standard_next <= strong_standby_timer_standard + 60;
                                        total_working_time_standard_next <= total_working_time_standard;
                                    end
                                else if ((state_in_hour_minute_second == minute || state_in_hour_minute_second == hour) && power_menu_button == 1)
                                    begin
                                        state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                        self_clean_timer_standard_next <= self_clean_timer_standard;
                                        level_3_timer_standard_next <= level_3_timer_standard;
                                        strong_standby_timer_standard_next <= strong_standby_timer_standard - 60;
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
                                        level_3_timer_standard_next <= level_3_timer_standard + 1;
                                        strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                        total_working_time_standard_next <= total_working_time_standard;
                                    end
                                else if (state_in_hour_minute_second == second && power_menu_button == 1)
                                    begin
                                        state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                        self_clean_timer_standard_next <= self_clean_timer_standard;
                                        level_3_timer_standard_next <= level_3_timer_standard - 1;
                                        strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                        total_working_time_standard_next <= total_working_time_standard;
                                    end
                                else if ((state_in_hour_minute_second == minute || state_in_hour_minute_second == hour) && self_clean_button == 1)
                                    begin
                                        state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                        self_clean_timer_standard_next <= self_clean_timer_standard;
                                        level_3_timer_standard_next <= level_3_timer_standard + 60;
                                        strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                        total_working_time_standard_next <= total_working_time_standard;
                                    end
                                else if ((state_in_hour_minute_second == minute || state_in_hour_minute_second == hour) && power_menu_button == 1)
                                    begin
                                        state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                        self_clean_timer_standard_next <= self_clean_timer_standard;
                                        level_3_timer_standard_next <= level_3_timer_standard - 60;
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
                                        current_time_edit <= current_time + 1;
                                    end
                                else if (state_in_hour_minute_second == second && power_menu_button == 1)
                                    begin
                                        state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                        self_clean_timer_standard_next <= self_clean_timer_standard;
                                        level_3_timer_standard_next <= level_3_timer_standard;
                                        strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                        total_working_time_standard_next <= total_working_time_standard;
                                        current_time_edit <= current_time - 1;
                                    end
                                else if (state_in_hour_minute_second == minute && self_clean_button == 1)
                                    begin
                                        state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                        self_clean_timer_standard_next <= self_clean_timer_standard;
                                        level_3_timer_standard_next <= level_3_timer_standard;
                                        strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                        total_working_time_standard_next <= total_working_time_standard;
                                        current_time_edit <= current_time + 60;
                                    end
                                else if (state_in_hour_minute_second == minute && power_menu_button == 1)
                                    begin
                                        state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                        self_clean_timer_standard_next <= self_clean_timer_standard;
                                        level_3_timer_standard_next <= level_3_timer_standard;
                                        strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                        total_working_time_standard_next <= total_working_time_standard;
                                        current_time_edit <= current_time - 60;
                                    end
                                else if (state_in_hour_minute_second == hour && self_clean_button == 1)
                                    begin
                                        state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                        self_clean_timer_standard_next <= self_clean_timer_standard;
                                        level_3_timer_standard_next <= level_3_timer_standard;
                                        strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                        total_working_time_standard_next <= total_working_time_standard;
                                        current_time_edit <= current_time + 3600;
                                    end
                                else if (state_in_hour_minute_second == hour && power_menu_button == 1)
                                    begin
                                        state_in_hour_minute_second_next <= state_in_hour_minute_second;
                                        self_clean_timer_standard_next <= self_clean_timer_standard;
                                        level_3_timer_standard_next <= level_3_timer_standard;
                                        strong_standby_timer_standard_next <= strong_standby_timer_standard;
                                        total_working_time_standard_next <= total_working_time_standard;
                                        current_time_edit <= current_time - 3600;
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
      
    always @(standard_clock_1)
        begin
            if (state_in_edit_state == change_clock)
                begin
                    current_time_next <= current_time;
                end
            else if (current_time_next == current_time)
                begin
                    current_time_next <= current_time + 1;
                end
            else 
                begin
                    current_time_next <= current_time_next;
                end
        end
    
    always @(posedge clk)
        begin
            case(state)
                standby_state:
                    begin
                        content_0 <= hour_0;
                        content_1 <= hour_1;
                        content_2 <= 6'b100100;
                        content_3 <= minute_0;
                        content_4 <= minute_1;
                        content_5 <= 6'b100100;
                        content_6 <= second_0;
                        content_7 <= second_1;
                    end
                self_clean_state:
                    begin
                        content_0 <= 6'b011100;
                        content_1 <= 6'b001100;
                        content_2 <= 6'b100101;
                        content_3 <= self_clean_minute_0;
                        content_4 <= self_clean_minute_1;
                        content_5 <= 6'b100100;
                        content_6 <= self_clean_second_0;
                        content_7 <= self_clean_second_1;
                    end
                level_3_state:
                    begin
                        content_0 <= 6'b010101;
                        content_1 <= 6'b000011;
                        content_2 <= 6'b100101;
                        content_3 <= level_3_minute_0;
                        content_4 <= level_3_minute_1;
                        content_5 <= 6'b100100;
                        content_6 <= level_3_second_0;
                        content_7 <= level_3_second_1;
                    end
                strong_standby_state:
                    begin
                        content_0 <= 6'b100000;
                        content_1 <= 6'b011101;
                        content_2 <= 6'b100101;
                        content_3 <= strong_standby_minute_0;
                        content_4 <= strong_standby_minute_1;
                        content_5 <= 6'b100100;
                        content_6 <= strong_standby_second_0;
                        content_7 <= strong_standby_second_1;
                    end
                level_1_state:
                    begin
                        content_0 <= hour_0;
                        content_1 <= hour_1;
                        content_2 <= 6'b100100;
                        content_3 <= minute_0;
                        content_4 <= minute_1;
                        content_5 <= 6'b100100;
                        content_6 <= second_0;
                        content_7 <= second_1;
                    end
                menu_state:
                    begin
                        content_0 <= hour_0;
                        content_1 <= hour_1;
                        content_2 <= 6'b100100;
                        content_3 <= minute_0;
                        content_4 <= minute_1;
                        content_5 <= 6'b100100;
                        content_6 <= second_0;
                        content_7 <= second_1;
                    end
                level_2_state:
                    begin
                        content_0 <= hour_0;
                        content_1 <= hour_1;
                        content_2 <= 6'b100100;
                        content_3 <= minute_0;
                        content_4 <= minute_1;
                        content_5 <= 6'b100100;
                        content_6 <= second_0;
                        content_7 <= second_1;
                    end
                power_off_a_state:
                    begin
                        content_0 <= hour_0;
                        content_1 <= hour_1;
                        content_2 <= 6'b100100;
                        content_3 <= minute_0;
                        content_4 <= minute_1;
                        content_5 <= 6'b100100;
                        content_6 <= second_0;
                        content_7 <= second_1;
                    end
                power_off_b_state:
                    begin
                        content_0 <= hour_0;
                        content_1 <= hour_1;
                        content_2 <= 6'b100100;
                        content_3 <= minute_0;
                        content_4 <= minute_1;
                        content_5 <= 6'b100100;
                        content_6 <= second_0;
                        content_7 <= second_1;
                    end
                edit_state:
                    begin
                        case(state_in_edit_state)
                            change_self_clean:
                                begin
                                    content_0 <= 6'b011100;
                                    content_1 <= 6'b001100;
                                    content_2 <= 6'b100101;
                                    content_3 <= self_clean_edit_minute_0;
                                    content_4 <= self_clean_edit_minute_1;
                                    content_5 <= 6'b100100;
                                    content_6 <= self_clean_edit_second_0;
                                    content_7 <= self_clean_edit_second_1;
                                end
                            change_left_right:
                                begin
                                    content_0 <= 6'b011000;
                                    content_1 <= 6'b001111;
                                    content_2 <= 6'b001111;
                                    content_3 <= 6'b100101;
                                    content_4 <= 6'b100101;
                                    content_5 <= 6'b100101;
                                    content_6 <= left_right_edit_second_0;
                                    content_7 <= left_right_edit_second_1;
                                end
                            change_work_time_standard:
                                begin
                                    content_0 <= 6'b001010;
                                    content_1 <= 6'b010110;
                                    content_2 <= 6'b100101;
                                    content_3 <= total_working_standard_edit_hour_0;
                                    content_4 <= total_working_standard_edit_hour_1;
                                    content_5 <= 6'b100100;
                                    content_6 <= total_working_standard_edit_minute_0;
                                    content_7 <= total_working_standard_edit_minute_1;
                                end
                            change_strong_standby_standard:
                                begin
                                    content_0 <= 6'b100000;
                                    content_1 <= 6'b011101;
                                    content_2 <= 6'b100101;
                                    content_3 <= strong_standby_standard_edit_minute_0;
                                    content_4 <= strong_standby_standard_edit_minute_1;
                                    content_5 <= 6'b100100;
                                    content_6 <= strong_standby_standard_edit_second_0;
                                    content_7 <= strong_standby_standard_edit_second_1;
                                end
                            change_level_3_standard:
                                begin
                                    content_0 <= 6'b010101;
                                    content_1 <= 6'b000011;
                                    content_2 <= 6'b100101;
                                    content_3 <= level_3_standard_edit_minute_0;
                                    content_4 <= level_3_standard_edit_minute_1;
                                    content_5 <= 6'b100100;
                                    content_6 <= level_3_standard_edit_second_0;
                                    content_7 <= level_3_standard_edit_second_1;
                                end
                            change_clock:
                                begin
                                    content_0 <= hour_0;
                                    content_1 <= hour_1;
                                    content_2 <= 6'b100100;
                                    content_3 <= minute_0;
                                    content_4 <= minute_1;
                                    content_5 <= 6'b100100;
                                    content_6 <= second_0;
                                    content_7 <= second_1;
                                end
                            default:
                                begin
                                    content_0 <= 6'b100101;
                                    content_1 <= 6'b100101;
                                    content_2 <= 6'b100101;
                                    content_3 <= 6'b100101;
                                    content_4 <= 6'b100101;
                                    content_5 <= 6'b100101;
                                    content_6 <= 6'b100101;
                                    content_7 <= 6'b100101;
                                end
                        endcase
                    end
                default:
                    begin
                        content_0 <= 6'b100101;
                        content_1 <= 6'b100101;
                        content_2 <= 6'b100101;
                        content_3 <= 6'b100101;
                        content_4 <= 6'b100101;
                        content_5 <= 6'b100101;
                        content_6 <= 6'b100101;
                        content_7 <= 6'b100101;
                    end
            endcase
        end
        
    scan_seg scan_seg_1(
    .rst_n(reset),
    .clk(clk),
    .n0(content_0),
    .n1(content_1),
    .n2(content_2),
    .n3(content_3),
    .n4(content_4),
    .n5(content_5),
    .n6(content_6),
    .n7(content_7),
    .seg_en({G2, C2, C1, H1, G1, F1, E1, G6}),
    .seg_out0({B4, A4, A3, B1, A1, B3, B2, D5}),
    .seg_out1({D4, E3, D3, F4, F3, E2, D2, H2})
    );
  
     always @(state)
        begin
            {F6, G4, G3, J4, H4, J3, J2, K2, K1, H6, H5} = state;
        end
     always @(the_left_right_signal)
        begin
            J5 = the_left_right_signal;
        end
     always @(total_working_time, total_working_time_standard)
        if (total_working_time == total_working_time_standard)
            begin
                K3 <= 1;
            end
        else 
            K3 <= 0;
     always @(light_mode_button)
        begin
            if (state == power_off_state)
                begin
                    M1 <= 1'b0;
                end
            else if (light_mode_button == 1)
                begin
                    M1 <= 1'b1;
                end
            else
                begin
                    M1 <= 1'b0;
                end
        end
endmodule