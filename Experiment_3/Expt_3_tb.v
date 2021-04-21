`timescale 1ns/1ps
`include "Experiment_3_worst.v"
// `include "Experiment_3_optimized.v"
// `include "Experiment_3_most_optimized.v"

module sum_fact_N_tb ();
reg clk;
reg [2:0] N;
reg input_valid;
reg reset;
wire [12:0] sum_fact;
wire output_valid;
reg output_ack;

initial begin
    clk <= 0;
    forever begin
        #10;
        clk <= ~clk;
    end
end

sum_fact_N sum_fact_N(.clk(clk), .N_in(N), .input_valid(input_valid), .reset(reset), .output_ack(output_ack), .sum_fact(sum_fact), .output_valid(output_valid));

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, sum_fact_N);
    reset <= 1'b1;
    output_ack <= 0;
    #20;
    reset <= 1'b0;
    input_valid <= 1;
    N <= 3'b111;
    #15;
    input_valid <= 0;
    #1000;
    output_ack <= 1;
    #20;
    output_ack <= 0;
    #50;
    $finish;
end

endmodule