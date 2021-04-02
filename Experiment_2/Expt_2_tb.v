`timescale 1ns/1ps
`include "Experiment_2.v"
module Expt_2_tb ();

reg clk;
reg [7:0] A_in;
reg [7:0] B_in;
reg input_valid;
reg reset;
reg gcd_ack;
wire [7:0] G_out;
wire output_valid;

initial begin
    clk <= 0;
    forever begin
        #10;
        clk <= ~clk;
    end
end

GCD GCD(.clk(clk), .A_in(A_in), .B_in(B_in), .input_valid(input_valid), .reset(reset), .gcd_ack(gcd_ack), .G_out(G_out), .output_valid(output_valid));

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, GCD);
    reset <= 1;
    #10;
    reset <= 0;
    #10;
    input_valid <= 0;
    A_in <= 21;
    B_in <= 18;
    #30;
    input_valid <= 1;
    #10;
    input_valid <= 0;
    #300;
    gcd_ack <= 1;
    #15;
    gcd_ack <= 0;
    #50;
    input_valid <= 1;
    #10;
    input_valid <= 0;
    #300;

    $finish;
end
    
endmodule