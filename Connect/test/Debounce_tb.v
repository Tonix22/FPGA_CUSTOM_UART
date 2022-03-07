`timescale 10ns /1ns
`include "../GPIO/Debounce.v"
`include "../../UART_BCD.v"
`include "../../common.v"

// testbench verilog code for debouncing button without creating another clock
module Debounce_tb;
 // Inputs
 reg pb_1;
 reg src_clk;
 // Outputs
 wire pb_out;
 // Instantiate the debouncing Verilog code
reg [9:0] SW;
wire DataOut;
wire [`BCD_DISPLAY_LEDS:0] Display;

UART_BCD UART(
    .src_clk(src_clk),
    .Switches(SW),
    .DataIn(DataIn),  //  RX
    .SendItem(pb_1),// PUSH Button
    .DataOut(DataOut), // TX
    .Display_out(Display)
);



 initial begin
  src_clk = 0;
  forever #1 src_clk=~src_clk;
 end
 initial begin
    //$dumpfile("test.vcd");
    //$dumpvars(0,uut);
    repeat(2) begin
    pb_1 = 1;
    #2000000;
    pb_1=0;
    #1000000;
    pb_1 = 1;
    #500000;
    pb_1=0;
    #1500000; 
    pb_1 = 1;
    #500000;
    pb_1=0;
    #2000000;
    pb_1 = 1;
    #500000;
    pb_1=0;
    #1500000; 
    pb_1 = 1;
    #500000;
    pb_1=0; 
    
    #50000000;

    pb_1 = 1;
    #500000;
    pb_1=0;
    #1000000;
    pb_1 = 1;
    #500000;
    pb_1=0;
    #3000000; 
    pb_1 = 1;
    #1000000;
    pb_1=0;
    #4000000;
    pb_1 = 1;
    #10000000;
    end

    $stop;
 end

 initial begin
   SW = 0;
   #1000 SW[0] = 1'b1;
   SW[1] = 1'b1;
   SW[2] = 1'b1; // get switch input
   SW[9:3] = 7'h5A;   
   #1000000000
   $stop;
 end
      
endmodule