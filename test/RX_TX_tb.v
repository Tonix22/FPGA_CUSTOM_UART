`include "../common.v"
`timescale 10ns /1ns

//`define RECIEVE
`define RECIEVE_TRANSMIT

`define BAUDRATE_9600
//`define BAUDRATE_57600
//`define BAUDRATE_115200

`ifdef BAUDRATE_9600
    `define PERIOD 10416.6
    `define HOLD 3000
`endif

`ifdef BAUDRATE_57600
    `define PERIOD 1736.11
    `define HOLD 200
`endif

`ifdef BAUDRATE_115200
    `define PERIOD 868.055
    `define HOLD 200
`endif

`ifdef RECIEVE
    `define FRAMES 2
`endif

`ifdef RECIEVE_TRANSMIT
    `define FRAMES 1
`endif

module RX_TX_tb();

reg src_clk;
reg [9:0] SW;
reg DataIn;
reg SendItem;
wire DataOut;
wire [`BCD_DISPLAY_LEDS:0] Display;

initial SendItem = 1'b1;

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
    `ifdef BAUDRATE_9600
    SW[2:1] = 2'b00;
    `endif
    `ifdef BAUDRATE_57600
    SW[2:1] = 2'b01;
    `endif
    `ifdef BAUDRATE_115200
    SW[2:1] = 2'b10;
    `endif

    #`HOLD
    //Enable RX and TX
    #5 SW[0] = 1'b1; // DISPLAY RX IN
    #300000 // #10416.6 * 8 
    $stop;
end

integer i;
integer j;
//Simulation data IN
initial begin
    repeat(`FRAMES) begin
        //IDLE
        DataIn = 1'b1;
        #20000
        //START BIT
        DataIn = 1'b0;
        #`PERIOD
        for (i=0; i<8; i=i+1) begin
            DataIn = (DATA&(1<<i))>>i;
            #`PERIOD;
        end
        //START STOP
        DataIn = 1'b1;
        #`PERIOD;
    end
    `ifdef RECIEVE_TRANSMIT
    // TX mode get RX outpu
    SW[1] = 1'b1;
    #100 SendItem =1'b0;
    for (i=0; i<10; i=i+1) begin
        #`PERIOD;
    end
    #`PERIOD;

    `endif
    $stop;

end




    
endmodule