`include "../common.v"
`timescale 10ns /1ns

`define BAUDRATE_9600
//`define BAUDRATE_57600
//`define BAUDRATE_115200

`ifdef BAUDRATE_9600
    `define PERIOD 10416.6
`endif

`ifdef BAUDRATE_57600
    `define PERIOD 1736.11
`endif

`ifdef BAUDRATE_115200
    `define PERIOD 868.055
`endif


module RX_TX_tb();

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

reg [7:0]DATA = 8'h52; // asccii R 


initial begin
    src_clk = 0;
    // configure baudrate 9600
    SW      = 0;
    SW[0]   = 1'b0;
    SW[2:1] = 2'b00;
    #3000
    //Enable RX and TX
    #5 SW[0] = 1'b1; // DISPLAY RX IN
    #300000 // #10416.6 * 8 
    $stop;
end

integer i;
integer j;
//Simulation data IN
initial begin
    for (j=0; j<2; j=j+1) begin
        //IDLE
        DataIn = 1'b1;
        #20000
        //START BIT
        DataIn = 1'b0;
        #10416.6
        for (i=0; i<8; i=i+1) begin
            DataIn = (DATA&(1<<i))>>i;
            #10416.6;
        end
        //START STOP
        DataIn = 1'b1;
        #10416.6;
    end

    $stop;

end




    
endmodule