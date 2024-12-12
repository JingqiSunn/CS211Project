`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/11/2024 05:56:39 PM
// Design Name: 
// Module Name: uart_tx
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




module uart_tx (
   input wire clk_100,
   input wire rst_n,
   input wire [7:0] state,  
   output reg tx
);
    wire clk_50;

    Clock_Creator_50hz Clock_Creator_50hz_1(
    .clk_in(clk_100),
    .reset(rst_n),
    .standard_clock(clk_50)
    );
    
    //Rate is 9600
    reg tx_next;
    reg just_next;
    
//    assign just_next_clock = just_next;
    
    wire [27:0] counter_standard = 2604;
    wire [12:0] rest_counter_standard = 2;   
    wire [9:0] data_pack = {1'b1,state, 1'b0};
    
    reg [27:0] counter, counter_next;
    reg whether_read_data_pack, whether_read_data_pack_next;
    reg [27:0] location_in_data_pack, location_in_data_pack_next; 
    reg [12:0] rest_counter, rest_counter_next;
    
//    assign whether_read = whether_read_data_pack;
//    assign rest_counter_light = rest_counter[1:0];
    
    always @(posedge clk_50, negedge rst_n)
        if (~rst_n)
            begin
                tx <= 1;
                counter <= 0;
                whether_read_data_pack <= 0;
                location_in_data_pack <= 0;
                rest_counter <= 0; 
            end
        else
            begin
                tx <= tx_next;
                counter <= counter_next;
                whether_read_data_pack <= whether_read_data_pack_next;
                location_in_data_pack <= location_in_data_pack_next;
                rest_counter <= rest_counter_next; 
            end
            
            
    always @(posedge clk_100)
        begin
            if (counter != counter_next)
                begin
                    counter_next <= counter_next;
                    just_next <= just_next;
                end
            else 
                begin
                    if (counter == counter_standard)
                        begin
                            counter_next <= 0;
                            just_next <= 1;
                        end
                    else 
                        begin
                            counter_next <= counter + 1;
                            just_next <= 0;
                        end
                end
        end
    always @(just_next)
        begin
            if (just_next == 1)
                begin
                    if (whether_read_data_pack == 1)
                        begin
                            if (location_in_data_pack == 9)
                                begin
                                    location_in_data_pack_next <= 0;
                                    whether_read_data_pack_next <= 0;
                                    rest_counter_next <= 1;
                                end
                            else
                                begin
                                    location_in_data_pack_next <= location_in_data_pack + 1;
                                    whether_read_data_pack_next <= 1;
                                    rest_counter_next <= 0;
                                end                            
                        end
                    else if (rest_counter == rest_counter_standard)
                        begin
                            location_in_data_pack_next <= 0;
                            whether_read_data_pack_next <= 1;
                            rest_counter_next <= 0;        
                        end
                    else 
                        begin
                            location_in_data_pack_next <= 0;
                            whether_read_data_pack_next <= 0;
                            rest_counter_next <= rest_counter + 1; 
                        end
                end
            else 
                begin
                    location_in_data_pack_next <= location_in_data_pack;
                    whether_read_data_pack_next <= whether_read_data_pack;
                    rest_counter_next <= rest_counter; 
                end
        end
    always @(whether_read_data_pack, location_in_data_pack)
        if (whether_read_data_pack == 1)
            begin
                tx_next <= data_pack[location_in_data_pack];
            end
        else 
            begin
                tx_next <= 1;
            end
endmodule


