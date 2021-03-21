`timescale 1ns/1ps

module sum_N(input clk, input[2:0] N, input N_valid_in, input sum_ack, input reset, output reg[4:0] sum_out, output reg sum_valid);
parameter IDLE = 2'b00;
parameter BUSY = 2'b01;
parameter DONE = 2'b11;

wire [2:0] i_mux_out;
wire [4:0] add_out;
wire [4:0] sum_mux_out;
wire i_eq_1, i_eq_1_state;

reg [2:0] i;
reg [1:0] state;
reg [1:0] next_state;

assign i_mux_out = N_valid ? N : i-1;
assign add_out = sum_out + i;
assign sum_mux_out = N_valid ? 0 : ((state == DONE) ? sum_mux_out : add_out);
assign i_eq_1 = (i==1);
assign i_eq_1_state = i_eq_1 && (state == BUSY);
assign N_valid = N_valid_in && (state == IDLE);

always @(posedge clk or posedge reset)
if(reset)
begin
    sum_out <= 0;
    i <= 0;
    sum_valid <= 0;
end
else
begin
    sum_out <= sum_mux_out;
    i <= i_mux_out;
    sum_valid <= i_eq_1_state;
end

always @(*)
begin
case(state)
    IDLE : if(N_valid) next_state = BUSY; else next_state = IDLE;
    BUSY : if(sum_valid) next_state = DONE; else next_state = BUSY;
    DONE : if(sum_ack) next_state = IDLE; else next_state = DONE;
endcase  
end

always @(posedge clk or posedge reset)
if(reset)
begin
    state <= IDLE;
end
else
begin
    state <= next_state;
end
endmodule