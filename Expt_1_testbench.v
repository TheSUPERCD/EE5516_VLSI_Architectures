`timescale 1ns/1ps
`include "VLSI_Experiment_1.v"
module Expt_1_tb();
reg clk;
reg [2:0] N;
reg N_valid;
reg sum_ack;
reg reset;
wire [4:0] sum_out;
wire sum_valid;

initial begin
    clk <= 0;
    forever begin
        #10;
        clk <= ~clk;
    end
end

sum_N sum_N(.clk(clk), .N(N), .N_valid_in(N_valid), .sum_ack(sum_ack), .reset(reset), .sum_out(sum_out), .sum_valid(sum_valid));

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, sum_N);
    reset <= 1'b1;
    sum_ack <=  0;
    #20;
    reset <= 1'b0;
    N_valid <= 1;
    N <= 3'b111;
    #10;
    N_valid <= 0;
    #300;
    sum_ack <= 1;
    #10;
    sum_ack <= 0;
    #400;
    $finish;
end

endmodule