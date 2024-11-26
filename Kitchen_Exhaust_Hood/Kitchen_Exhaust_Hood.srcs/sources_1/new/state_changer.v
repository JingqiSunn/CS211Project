module state_changer(
    input x_in,
    input reset,
    input clk,
    output reg [2:0] y_out
    );
    reg [2:0] state;
    reg [2:0] next_state;
    parameter S1 = 3'b001, S2 = 3'b010, S3 = 3'b100;
    always @(negedge reset,posedge clk)
        begin
            if (~reset)
                begin
                    state <= S1;
                end
             else 
                begin
                    state <= next_state;
                end
        end
     always @(x_in, state)
        case (state)
            S1: if (x_in == 0) next_state <= S1; else next_state <= S2;
            S2: if (x_in == 0) next_state <= S2; else next_state <= S3;
            S3: if (x_in == 0) next_state <= S3; else next_state <= S1;
            default: next_state <= S1;
        endcase
     always @(state)
        y_out = state;
endmodule
