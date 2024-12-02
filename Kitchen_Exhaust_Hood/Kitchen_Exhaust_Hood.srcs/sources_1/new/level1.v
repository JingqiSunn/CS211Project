
module level1 (
    input enable,
    input clk,
    input [27:0] total_seconds,
    output reg [7:0] seg_out,
    output reg [7:0] seg_en
)
    reg [5:0] time_data[0:7];
    reg [31:0] cnt;
    reg [2:0] scan_cnt;
    reg clkout_1hz;
    reg clkout_60hz;
    reg [5:0] hour_0, hour_1, minute_0, minute_1, second_0, second_1;

    parameter period_1hz = 50000000;
    parameter period_60hz = 833333;

    second_time_switcher time_converter (
        .total_seconds(total_seconds),
        .hour_0(hour_0),
        .hour_1(hour_1),
        .minute_0(minute_0),
        .minute_1(minute_1),
        .second_0(second_0),
        .second_1(second_1)
    );

    wire standard_clock_1;
    standard_clock_generator_60 clk_gen (
        .clk(clk), 
        .reset(enable), 
        .standard_clock_1(standard_clock_1), 
        .standard_clock_60(clkout_60hz)
    );

    always @(posedge standard_clock_1 or negedge enable) begin
        if (!enable) begin
            clkout_1hz <= 0;
            cnt <= 0;
        end else if (cnt == period_1hz - 1) begin
            clkout_1hz <= ~clkout_1hz;
            cnt <= 0;
        end else begin
            cnt <= cnt + 1;
        end
    end

    always @(posedge clkout_1hz or negedge enable) begin
        if (!enable) begin
            time_data[0] <= 6'b010101;
            time_data[1] <= 6'b000001;
            time_data[2] <= 6'b000000;
            time_data[3] <= 6'b000000;
            time_data[4] <= 6'b000000;
            time_data[5] <= 6'b000000;
            time_data[6] <= 6'b000000;
            time_data[7] <= 6'b000000;
        end else begin
            time_data[0] <= 6'b010101;
            time_data[1] <= 6'b000001;
            time_data[2] <= hour_0;
            time_data[3] <= hour_1;
            time_data[4] <= minute_0;
            time_data[5] <= minute_1;
            time_data[6] <= second_0;
            time_data[7] <= second_1;
        end
    end

    always @(posedge clkout_60hz or negedge enable) begin
        if (!enable) begin
            scan_cnt <= 3'b000;
        end else if (scan_cnt == 3'b111) begin
            scan_cnt <= 3'b000;
        end else begin
            scan_cnt <= scan_cnt + 1;
        end
    end

    always @(*) begin
        case (scan_cnt)
            3'b000:seg_en=8'b00000001;
            3'b001:seg_en=8'b00000010;
            3'b010:seg_en=8'b00000100;
            3'b011:seg_en=8'b00001000;
            3'b100:seg_en=8'b00010000;
            3'b101:seg_en=8'b00100000;
            3'b110:seg_en=8'b01000000;
            3'b111:seg_en=8'b10000000;
            default:seg_en=8'b0;
        endcase
    end

    seven_seg_map u0 (
        .sw(time_data[scan_cnt]),
        .seg_out(seg_out),
        .seg_en(seg_en)
    );
endmodule