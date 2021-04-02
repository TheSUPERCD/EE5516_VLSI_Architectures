`timescale 1ns/1ps

module GCD (
    input clk,
    input [7:0] A_in,
    input [7:0] B_in,
    input input_valid,
    input reset,
    input gcd_ack,
    output [7:0] G_out,
    output output_valid
);

parameter IDLE = 2'b00;
parameter BUSY = 2'b01;
parameter DONE = 2'b10;

reg [7:0] A;
reg [7:0] B;
reg [1:0] state;
reg [1:0] next_state;

wire [7:0] A_mux_out;
wire [7:0] B_mux_out;
wire [7:0] A_out;
wire [7:0] B_out;
wire [7:0] G_out;
wire [7:0] A_minus_B;
wire B_zero;

assign A_out = A;
assign B_out = B;
assign A_mux_out = input_valid ? A_in : ( (state==BUSY) ? ((A_out < B_out) ? B_out : A_minus_B) : A_out);
assign B_mux_out = input_valid ? B_in : ( (state==BUSY) ? ((A_out < B_out) ? A_out : B_out) : B_out);
assign A_minus_B = A_out - B_out;
assign B_zero = (B_out == 8'b00000000);

always @(posedge clk or posedge reset)
if(reset)
begin
    A <= 0;
    B <= 0;
end
else
begin
    A <= A_mux_out;
    B <= B_mux_out;
end

always @(posedge clk or posedge reset)
begin
if(reset)
    state <= IDLE;
else
    state <= next_state;
end

assign G_out = output_valid ? A_out : 0;
assign output_valid = (state == DONE);

always @(*)
begin
case (state)
    IDLE: if(input_valid) next_state = BUSY; else next_state = IDLE;
    BUSY: if(B_zero) next_state = DONE; else next_state = BUSY;
    DONE: if(gcd_ack) next_state = IDLE; else next_state = DONE;
endcase
end

endmodule