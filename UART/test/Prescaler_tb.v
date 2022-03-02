`timescale 1ns /10ps
`define Test_CLK 10

module Prescaler_tb();


reg src_clk;
wire clk_div;

always #`Test_CLK src_clk=~src_clk;

Prescaler #(.SRC_CLK(`Test_CLK),.DIV(1)) Prescaler_dut
(
    .src_clk(src_clk),
    .clk_div(clk_div)
);
    
initial
    begin
        $dumpfile("test.vcd");
        $dumpvars(0,Prescaler_dut);
        src_clk = 1'b0;
        #1000
        $display("simulation Finished!");
        $stop;
        //$finish;
    end


endmodule