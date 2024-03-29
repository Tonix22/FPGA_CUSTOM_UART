`include "common.v"

module UART_BCD(
    input src_clk,
    input [9:0]Switches,
    input DataIn,  //  RX
    input SendItem,// PUSH Button
    output DataOut, // TX
    output [`BCD_DISPLAY_LEDS:0] Display_out
);

/****************************************
************** WIRES ********************
*****************************************/
wire uart_clk_Tx;
wire uart_clk_Rx;
wire DisplayMode = Switches[0]; // (1)


/****************************************
************** REGS *********************
*****************************************/
reg [1:0]baud_rate_sel; 
reg data_dir;    
reg stream;      
reg en_Rx;
reg en_Tx;


initial baud_rate_sel = 2'b00;
initial data_dir = 1'b0;
initial stream = 1'b0;


/****************************************
************** PRESCALER ****************
*****************************************/

Baudrate PrescalerTX
(
    .src_clk(src_clk),
    .Prescaler_sel(baud_rate_sel),
    .Uart_clk(uart_clk_Tx)
);

// RX Need higer speed rate to sample input samples
Baudrate #(.SCALE(`SAMPLING_FACTOR)) PrescalerRX
(
    .src_clk(src_clk),
    .Prescaler_sel(baud_rate_sel),
    .Uart_clk(uart_clk_Rx)
);

/****************************************
************** Push Button Debouncer ****
*****************************************/

wire sent_TX;
Debounce debouncer (
  .pb_1(SendItem), 
  .src_clk(src_clk), 
  .pb_out(sent_TX)
 );


/****************************************
************** FSM RX *******************
*****************************************/
wire [7:0] out_rx;
wire bussy_RX;
wire RX_baudrate;
assign RX_baudrate = en_Rx & uart_clk_Rx;

Rx Reciever
(
    .clk(src_clk),
    .ena(RX_baudrate), 
    .Bit_in(DataIn), // bit de entrada
    .out(out_rx),    // Recived byte
	.bussy(bussy_RX)
);

/****************************************
************** FSM TX *******************
*****************************************/

//FSM TX
wire [7:0] manual_in = {1'b0,Switches[9:3]};
wire [7:0] tx_in;

assign tx_in = (stream)?manual_in:out_rx;

wire Tx_baudrate;
assign Tx_baudrate = en_Tx & uart_clk_Tx;
Tx  Transmiter
(
    .clk(src_clk), 
    .ena(Tx_baudrate),
    .send(sent_TX),  //push button with debounce
    .data(tx_in),     // data to bypass
	.out(DataOut)   // UART out
);

/****************************************
************** BCD  *********************
*****************************************/

/* The display can show RX data or TX data
   data_dir
    TX
        tx_in
    RX
        out_rx
*/

reg [7:0] msg;
initial msg = 8'b0;
DigitsDisplay Display
(
    .src_clk(src_clk),
    .mode(DisplayMode),
    .msg(msg),
    .Display(Display_out)
);


always @(posedge src_clk) begin

    if (DisplayMode == `BAUDRATE_MODE) begin
        baud_rate_sel = Switches[2:1];
        msg           = {{6{1'b0}},Switches[2:1]}; // 8bit variable
        en_Rx <= 1'b0;
        en_Tx <= 1'b0;
    end
    else begin

        en_Rx <= 1'b1;
        en_Tx <= 1'b1;
        data_dir = Switches[1];
        stream   = Switches[2];
        
        if(data_dir == `MODE_RX) begin
            if(!bussy_RX) begin
                msg = out_rx;
                end
        end
        else begin // MODE TX
            msg = tx_in;
        end
    end
end

    
endmodule