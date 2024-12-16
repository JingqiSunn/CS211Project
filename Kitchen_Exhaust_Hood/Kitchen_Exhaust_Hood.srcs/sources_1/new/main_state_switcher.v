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
    input kill_11111111,
    input kill_01111111,
    input kill_00111111,
    input whether_manual_clean,
    input edit_state_button,
    input show_work_time_state_button,
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
    output reg K6,
    output reg L1,
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
    output G6,
    output H17,       
    output T1,
    output T4
    );
    
    //here we difine lots of parameters and regs, everything here are states
    wire clock_uart;
    wire [7:0] state_in_binary;
    wire the_left_right_signal;
    wire the_right_left_signal;
    wire clock_for_edit;
    standard_clock_generator_edit standard_clock_generator_edit_1(
    .clk_in(clk),
    .reset(reset),
    .standard_clock(clock_for_edit)
    );
    reg [11:0] state;
    wire [11:0] next_state;
    reg [2:0] state_in_edit_state;
    wire [2:0] state_in_edit_state_next;
    reg [2:0] state_in_hour_minute_second; 
    wire [2:0] state_in_hour_minute_second_next;
    
    reg [27:0] self_clean_timer;
    wire [27:0] self_clean_timer_next;
    reg [27:0] self_clean_timer_standard;
    wire [27:0] self_clean_timer_standard_next;
    
    reg [27:0] level_3_timer;
    wire [27:0] level_3_timer_next;
    reg [27:0] level_3_timer_standard;
    wire [27:0] level_3_timer_standard_next;
    
    reg [27:0] strong_standby_timer;
    wire [27:0] strong_standby_timer_next;
    reg [27:0] strong_standby_timer_standard;
    wire [27:0] strong_standby_timer_standard_next;
    
    
    reg [27:0] current_time;
    reg [27:0] current_time_next;
    wire [27:0] current_time_edit;
    
    reg [27:0] total_working_time;
    wire [27:0] total_working_time_next;
    reg [27:0] total_working_time_standard;
    wire [27:0] total_working_time_standard_next;
    
    reg [5:0] left_right; 
    wire [5:0] left_right_next;
    reg [5:0] left_right_standard;
    wire [5:0] left_right_standard_next;
    
    reg already_use_level_3;
    wire already_use_level_3_next; 
    
    
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
    
    //apply the buzzer driver
    buzzer_driver buzzer_driver_1(
      .clk(P17),     
      .state(state),       
      .button1(power_menu_button),     
      .button2(level_1_button),     
      .button3(level_2_button),
      .button4(level_3_button),
      .button5(self_clean_button),
      .buzzer(H17),       
      .t1(T1)
    );
   
   //get minitoring information
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
    
    //in this always block, lots of states are updated to next_state.
    always @(posedge standard_clock_1, negedge reset)
        begin
             if (~reset) 
                begin
                    state <= power_off_state;
                    state_in_edit_state <= change_self_clean;
                    self_clean_timer <= 28'b0;
                    self_clean_timer_standard <= 28'b0000000000000000000010110100;
                    level_3_timer <= 28'b0;
                    level_3_timer_standard <= 28'b0000000000000000000000111100;
                    strong_standby_timer <= 28'b0;
                    strong_standby_timer_standard <= 28'b0000000000000000000000111100;
                    current_time <= 28'b0;
                    total_working_time <= 28'b0;
                    total_working_time_standard <= 28'b0000000000001000110010100000;
                    state_in_hour_minute_second <= second;
                    left_right <= 6'b0;
                    left_right_standard <= 6'b000101;
                    already_use_level_3 <= 1'b0;
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
                    already_use_level_3 <= already_use_level_3_next;
                end
        end
     
     //create the signal to control turn on and turn off
     left_right_signal left_right_signal_1(
        .reset(reset),
        .target_time(left_right_standard),
        .clk(clk),
        .standard_clock(standard_clock_1),
        .the_right_left_signal(the_right_left_signal),
        .left_button(level_1_button),
        .right_button(level_3_button),
        .left_right_signal_out(the_left_right_signal)
    ); 
    
    right_left_signal right_left_signal_1(
        .reset(reset),
        .target_time(left_right_standard),
        .clk(clk),
        .standard_clock(standard_clock_1),
        .the_left_right_signal(the_left_right_signal),
        .left_button(level_1_button),
        .right_button(level_3_button),
        .left_right_signal_out(the_right_left_signal)
    ); 
    
    //generate next_state except edit and current time
    next_state_machine next_state_machine_1(
        .clk(clk),
        .kill_11111111(kill_11111111),
        .kill_01111111(kill_01111111),
        .kill_00111111(kill_00111111),
        .standard_clock_1(standard_clock_1),
        .whether_manual_clean(whether_manual_clean),
        .level_3_timer_standard(level_3_timer_standard),
        .self_clean_timer_standard(self_clean_timer_standard),
        .strong_standby_timer_standard(strong_standby_timer_standard),
        .power_menu_button_three(power_menu_button_three),
        .the_left_right_signal(the_left_right_signal),
        .the_right_left_signal(the_right_left_signal),
        .reset(reset) ,
        .state(state), 
        .power_menu_button_short(power_menu_button_short), 
        .power_menu_button_long(power_menu_button_long), 
        .level_1_button(level_1_button), 
        .level_2_button(level_2_button), 
        .level_3_button(level_3_button), 
        .self_clean_button(self_clean_button), 
        .edit_state_button(edit_state_button), 
        .show_work_time_state_button(show_work_time_state_button),
        .already_use_level_3(already_use_level_3),
        .left_right(left_right),
        .state_in_edit_state(state_in_edit_state),
        .self_clean_timer(self_clean_timer),
        .level_3_timer(level_3_timer),
        .strong_standby_timer(strong_standby_timer),
        .total_working_time(total_working_time),
        .already_use_level_3_next(already_use_level_3_next),
        .left_right_next(left_right_next),
        .state_in_edit_state_next(state_in_edit_state_next),
        .self_clean_timer_next(self_clean_timer_next),
        .level_3_timer_next(level_3_timer_next),
        .strong_standby_timer_next(strong_standby_timer_next),
        .total_working_time_next(total_working_time_next),
        .next_state(next_state)
    );
    
    //generate next_state for edit
    next_state_machine_for_edit next_state_machine_for_edit_1(
        .clock_for_edit(clock_for_edit),
        .reset(reset),
        .level_2_button(level_2_button),
        .power_menu_button(power_menu_button),
        .self_clean_button(self_clean_button),
        .current_time(current_time),
        .left_right_standard(left_right_standard),
        .state_in_hour_minute_second(state_in_hour_minute_second),
        .self_clean_timer_standard(self_clean_timer_standard),
        .level_3_timer_standard(level_3_timer_standard),
        .strong_standby_timer_standard(strong_standby_timer_standard),
        .total_working_time_standard(total_working_time_standard),
        .state(state),
        .state_in_edit_state(state_in_edit_state),
        .current_time_edit(current_time_edit),
        .left_right_standard_next(left_right_standard_next),
        .state_in_hour_minute_second_next(state_in_hour_minute_second_next),
        .self_clean_timer_standard_next(self_clean_timer_standard_next),
        .level_3_timer_standard_next(level_3_timer_standard_next),
        .strong_standby_timer_standard_next(strong_standby_timer_standard_next),
        .total_working_time_standard_next(total_working_time_standard_next)
    );
     
    //generate next_state for current time
    always @(standard_clock_1)
        begin
            if (state == power_off_state)
                begin
                    current_time_next <= 0;
                end
            else if (state_in_edit_state == change_clock)
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
    
    //monitor based on the state you are in
    always @(posedge clk)
        begin
            case(state)
                show_current_working_state:
                    begin
                        content_0 <= total_working_time_hour_0;
                        content_1 <= total_working_time_hour_1;
                        content_2 <= 6'b100100;
                        content_3 <= total_working_time_minute_0;
                        content_4 <= total_working_time_minute_1;
                        content_5 <= 6'b100100;
                        content_6 <= total_working_time_second_0;
                        content_7 <= total_working_time_second_1;
                    end
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
    
    //initiate the monitor
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
     
     //show the state light
     always @(state)
        begin
            {F6, G4, G3, J4, H4, J3, J2, K2, K1, H6, H5, J5} = state;
        end
        
        //update the total work time
     always @(total_working_time, total_working_time_standard)
        if (total_working_time == total_working_time_standard)
            begin
                K3 <= 1;
            end
        else 
            K3 <= 0;
            
     //light mode
     always @(light_mode_button)
        begin
            if (state == power_off_state)
                begin
                    M1 <= 1'b0;
                    K6 <= 1'b0;
                    L1 <= 1'b0;
                end
            else if (light_mode_button == 1)
                begin
                    M1 <= 1'b1;
                    K6 <= 1'b1;
                    L1 <= 1'b1;
                end
            else
                begin
                    M1 <= 1'b0;
                    K6 <= 1'b0;
                    L1 <= 1'b0;
                end
        end
    
    //prepare data for uart_tx
    state_one_hot_to_binary state_one_hot_to_binary_1(
        .one_hot(state),
        .binary(state_in_binary)
    );
    
    Clock_generator_uart Clock_generator_uart_1(
        .clk_in(clk),
        .reset(reset),
        .standard_clock(clock_uart)
    );
    
    //data for uart_tx
    reg [7:0] data, data_next;
    reg [27:0] state_in_transfer, state_in_transfer_next;
    parameter
    for_state               = 1,
    for_over_work           = 2,
    for_work_second_1       = 3,
    for_work_second_0       = 4,
    for_work_minute_1       = 5,
    for_work_minute_0       = 6,
    for_work_hour_1         = 7,
    for_work_hour_0         = 8,
    for_second_1            = 9,
    for_second_0            = 10,
    for_minute_1            = 11,
    for_minute_0            = 12,
    for_hour_1              = 13,
    for_hour_0              = 14;
    
    //update data to transport
    always @(posedge clock_uart, negedge reset)
        begin
            if (~reset)
                begin
                    data <= state_in_binary;
                    state_in_transfer <= for_state;
                end
            else 
                begin
                    data <= data_next;
                    state_in_transfer <= state_in_transfer_next;
                end
        end
    
    //prepare the next_data
    always @(posedge clk)
        begin
            case (state_in_transfer)
                for_state:
                     begin
                        data_next <= {7'b0001000, K3};
                        state_in_transfer_next <= for_over_work; 
                     end
                for_over_work:
                     begin
                        data_next <= {4'b0010, total_working_time_second_1[3:0]};
                        state_in_transfer_next <= for_work_second_1; 
                     end
                for_work_second_1:
                     begin
                        data_next <= {4'b0011, total_working_time_second_0[3:0]};
                        state_in_transfer_next <= for_work_second_0; 
                     end
                for_work_second_0:
                     begin
                        data_next <= {4'b0100, total_working_time_minute_1[3:0]};
                        state_in_transfer_next <= for_work_minute_1; 
                     end
                for_work_minute_1:
                     begin
                        data_next <= {4'b0101, total_working_time_minute_0[3:0]};
                        state_in_transfer_next <= for_work_minute_0; 
                     end
                for_work_minute_0:
                     begin
                        data_next <= {4'b0110, total_working_time_hour_1[3:0]};
                        state_in_transfer_next <= for_work_hour_1; 
                     end
                for_work_hour_1:
                     begin
                        data_next <= {4'b0111, total_working_time_hour_0[3:0]};
                        state_in_transfer_next <= for_work_hour_0; 
                     end
                for_work_hour_0:
                     begin
                        data_next <= {4'b1000, second_1[3:0]};
                        state_in_transfer_next <= for_second_1; 
                     end
                for_second_1:
                     begin
                        data_next <= {4'b1001, second_0[3:0]};
                        state_in_transfer_next <= for_second_0; 
                     end
                for_second_0:
                     begin
                        data_next <= {4'b1010, minute_1[3:0]};
                        state_in_transfer_next <= for_minute_1; 
                     end
                for_minute_1:
                     begin
                        data_next <= {4'b1011, minute_0[3:0]};
                        state_in_transfer_next <= for_minute_0; 
                     end
                for_minute_0:
                     begin
                        data_next <= {4'b1100, hour_1[3:0]};
                        state_in_transfer_next <= for_hour_1; 
                     end
                for_hour_1:
                     begin
                        data_next <= {4'b1101, hour_0[3:0]};
                        state_in_transfer_next <= for_hour_0; 
                     end
                for_hour_0:
                     begin
                        data_next <= state_in_binary;
                        state_in_transfer_next <= for_state; 
                     end
                default:
                     begin
                        data_next <= state_in_binary;
                        state_in_transfer_next <= for_state; 
                     end
            endcase
        end
    uart_tx uart_tx_1 (
       .clk_100(clk),
       .rst_n(reset),
       .state(data), 
       .tx(T4) 
    );
   
    
endmodule