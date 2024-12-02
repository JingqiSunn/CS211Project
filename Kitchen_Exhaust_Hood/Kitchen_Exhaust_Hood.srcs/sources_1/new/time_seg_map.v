// display total time on six LEDs

module time_seg_map (
    input rst_n,
    input clk,
    input [5:0] n0,
    input [5:0] n1,
    input [5:0] n2,
    input [5:0] n3,
    input [5:0] n4,
    input [5:0] n5,
    output reg [5:0] seg_en,
    output [7:0] seg_out
);
    reg [5:0] n_array [0:5];
    reg clkout;
    reg [31:0] cnt;
    reg [2:0] scan_cnt;
    parameter period = 200000;

    always @* begin
        n_array[0] = n5;
        n_array[1] = n4;
        n_array[2] = n3;
        n_array[3] = n2;
        n_array[4] = n1;
        n_array[5] = n0;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            clkout <= 0;
        end else begin
            if (cnt == (period >> 1) - 1) begin
                clkout <= ~clkout;
                cnt <= 0;
            end else begin
                cnt <= cnt + 1;
            end
        end
    end

    always @(posedge clkout or negedge rst_n) begin
        if (!rst_n) begin
            scan_cnt <= 0;
        end else begin
            if (scan_cnt == 3'd5) begin
                scan_cnt <= 0;
            end else begin
                scan_cnt <= scan_cnt + 1;
            end
        end
    end

    always @(scan_cnt) begin
        case (scan_cnt)
            3'b000: seg_en = 6'b000001;
            3'b001: seg_en = 6'b000010;
            3'b010: seg_en = 6'b000100;
            3'b011: seg_en = 6'b001000;
            3'b100: seg_en = 6'b010000;
            3'b101: seg_en = 6'b100000;
            default: seg_en = 6'b000000;
        endcase
    end

    wire useless0;
    seven_seg_map u0(.sw(n_array[scan_cnt]), .seg_out(seg_out), .seg_en(useless0));

endmodule