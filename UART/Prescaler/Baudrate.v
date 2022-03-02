`include "config.v"

`define ID_9600   0
`define ID_57600  1
`define ID_115200 2

`define SEL_9600   2'b00
`define SEL_57600  2'b01
`define SEL_115200 2'b10

`define MAX_BAUDRATE 115200


module Baudrate(
    input src_clk,    
    input [1:0] Prescaler_sel, // prescaler select
    output reg Uart_clk
);

`ifdef DEBUG
    `define CLK_REF MAX_BAUDRATE*2 // Double of FS max
`elsif RELEASE
    `define CLK_REF `SOURCE_CLK // Ready for FPGA download
`endif

reg [2:0] en_clk;
wire [2:0] output_clk;

Prescaler #(.SRC_CLK(`CLK_REF),.DIV(9600))  Prescaler_9600 
(.src_clk(src_clk),.en(en_clk[`ID_9600]),.clk_div(output_clk[`ID_9600]));

Prescaler #(.SRC_CLK(`CLK_REF),.DIV(57600)) Prescaler_57600
(.src_clk(src_clk),.en(en_clk[`ID_57600]),.clk_div(output_clk[`ID_57600]));

Prescaler #(.SRC_CLK(`CLK_REF),.DIV(115200)) Prescaler_115200
(.src_clk(src_clk),.en(en_clk[`ID_115200]),.clk_div(output_clk[`ID_115200]));


always @(posedge src_clk) begin

    case (Prescaler_sel)
        `SEL_9600 :  begin
                    en_clk   = 3'b001;
                    Uart_clk = output_clk[`ID_9600];
                    end 

        `SEL_57600 : begin
                    en_clk   = 3'b010;
                    Uart_clk = output_clk[`ID_57600];
                    end
                    
        `SEL_115200 :begin
                    en_clk   = 3'b100;
                    Uart_clk = output_clk[`ID_115200];
                    end

        default: en_clk = 3'b000;
    endcase
end

endmodule