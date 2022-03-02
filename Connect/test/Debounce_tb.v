`timescale 1ns / 1ps

// testbench verilog code for debouncing button without creating another clock
module Debounce_tb;
 // Inputs
 reg pb_1;
 reg src_clk;
 // Outputs
 wire pb_out;
 // Instantiate the debouncing Verilog code
 Debounce uut (
  .pb_1(pb_1), 
  .src_clk(src_clk), 
  .pb_out(pb_out)
 );
 initial begin
  src_clk = 0;
  forever #10 src_clk = ~src_clk;
 end
 initial begin
    $dumpfile("test.vcd");
    $dumpvars(0,uut);
    pb_1 = 1;
    #20;
    pb_1=0;
    #10;
    pb_1 = 1;
    #5;
    pb_1=0;
    #15; 
    pb_1 = 1;
    #5;
    pb_1=0;
    #20;
    pb_1 = 1;
    #5;
    pb_1=0;
    #15; 
    pb_1 = 1;
    #5;
    pb_1=0; 
    #500; 
    pb_1 = 1;
    #5;
    pb_1=0;
    #10;
    pb_1 = 1;
    #5;
    pb_1=0;
    #30; 
    pb_1 = 1;
    #10;
    pb_1=0;
    #40;
    pb_1 = 1;
    #100
    $stop;
 end 
      
endmodule