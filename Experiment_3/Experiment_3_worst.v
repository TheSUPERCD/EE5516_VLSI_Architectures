`timescale 1ns/1ps

module sum_fact_N (
    input clk,
    input [2:0] N_in,
    input input_valid,
    input reset,
    input output_ack,
    output [12:0] sum_fact,
    output output_valid
);

parameter IDLE = 2'b00;
parameter BUSY = 2'b01;
parameter DONE = 2'b11;

reg [2:0] N;
reg [2:0] i;
reg [12:0] fact;
reg [12:0] sum;
reg [1:0] state;
reg [1:0] next_state;
wire [2:0] N_mux_out;
wire [2:0] N_out;
wire [2:0] i_out;
wire [12:0] sum_out;
wire [12:0] sum_mux_out;
wire [12:0] fact_mux_out;
wire [2:0] i_mux_out;

assign N_out = N;
assign sum_out = sum;
assign i_out = i;
assign N_mux_out = input_valid ? N_in : ((state==BUSY && i==0) ? (N_out-1) : N_out);
assign i_mux_out = ((state==BUSY) ? ((i_out==0) ? N_out : (i_out-1)) : i_out);
assign fact_mux_out = (state==BUSY && i_out==0) ? 1 : ((state==IDLE) ? 1 : (fact*i_out));
assign sum_mux_out = (state==BUSY && i==0) ? (sum_out + fact) : sum_out;


always @(posedge clk or posedge reset)
if(reset)
begin
    N <= 0;
    state <= IDLE;
    sum <= 0;
    i <= 0;
    fact <= 1;
end
else
begin
    N <= N_mux_out;
    sum <= sum_mux_out;
    fact <= fact_mux_out;
    i <= i_mux_out;
    state <= next_state;
end

always @(*)
begin
case(state)
    IDLE: if(input_valid) next_state = BUSY; else next_state = IDLE;
    BUSY: if(N_out==0) next_state = DONE; else next_state = BUSY;
    DONE: if(output_ack) next_state = IDLE; else next_state = DONE;
endcase
end

assign sum_fact = output_valid ? sum_out : 0;
assign output_valid = (state==DONE);

endmodule