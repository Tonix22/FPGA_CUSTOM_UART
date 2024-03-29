`include "../common.v"
`timescale 1ns /10ps
`define Test_CLK 5

module Modes_tb();

reg src_clk;
reg [9:0] SW;
reg DataIn;
reg SendItem;
wire DataOut;
wire [`BCD_DISPLAY_LEDS:0] Display;

always #`Test_CLK src_clk=~src_clk;

UART_BCD UART(
    .src_clk(src_clk),
    .Switches(SW),
    .DataIn(DataIn),  //  RX
    .SendItem(SendItem),// PUSH Button
    .DataOut(DataOut), // TX
    .Display_out(Display)
);

integer i;

initial
    begin
        src_clk   = 0;
        SW = 0;
        # 10

        /********* TC0.TC3,TC4 *********/
        /********* BEGIN *********/
        /*  INPUT : SW0 (zero) 
            OUTPUT: Mux listen SWI and SW2 to  modify (baudrate sel)*/
        #10 SW[2:1] = 2'b00;
        #10 SW[2:1] = 2'b01;
        #10 SW[2:1] = 2'b10;
        #10 SW[2:1] = 2'b11;
        #10 SW[2:1] = 2'b01; // set back to 57600

        /*------- END ----------*/

        /*********TC2, TC2*********/
        /********* BEGIN *********/
        /*  INPUT : SW0 (one) 
            OUTPUT: SW1 (baudrate sel) hold its value, even if SW1 and SW2 changes.  
            OUTPUT: The signal (data_dir) will change with SW1 instead.*/
        
        #10 SW[0] = 1;
        #10 SW[2:1] = 2'b00;
        #10 SW[2:1] = 2'b01;
        #10 SW[2:1] = 2'b10;
        #10 SW[2:1] = 2'b11;
        #10 SW[2:1] = 2'b01; // set back to 57600

        /*------- END ----------*/
        #30
        
        
        $stop;

    end
    
endmodule