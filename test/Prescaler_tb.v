`include "../common.v"
`timescale 10ns /1ns

module Prescaler_tb();

reg src_clk;
reg [9:0] SW;
reg DataIn;
reg SendItem;
wire DataOut;
wire [`BCD_DISPLAY_LEDS:0] Display;


always #1 src_clk=~src_clk;

UART_BCD UART(
    .src_clk(src_clk),
    .Switches(SW),
    .DataIn(DataIn),  //  RX
    .SendItem(SendItem),// PUSH Button
    .DataOut(DataOut), // TX
    .Display_out(Display)
);

initial begin
    src_clk = 0;
    #5;
    // 9600 -> 104166.66 ns -> 10416.666
    // 50MHZ/9600 -> 5208
    // configure baudrate
    SW[0] = 0;
    SW[2:1] = 2'b00;
    //listen RX or TX
    #5
    SW[0] = 1;
    #21000
    // 57600 -> 17361.1111 ns ->1736.11111
    // configure baudrate
    SW[0] = 0;
    SW[2:1] = 2'b01;
    //listen RX or TX
    #5
    SW[0] = 1;
    #3500
    //115200 -> 8680.55556 ns
    SW[0] = 0;
    SW[2:1] = 2'b10; 
    #5
    SW[0] = 1;
    #2000
    // disable
    SW[0] = 0;
    SW[2:1] = 2'b11; 
    #1000
    $stop; 
end

endmodule