`include "../../config.v"
`include "../../common.v"

module Baudrate #(parameter SCALE=1)(
    input src_clk,    
    input [1:0] Prescaler_sel, // prescaler select
    output reg Uart_clk
);
//SAMPLING_FACTOR is to catch the middle of a RX pulse
//This up scalling should be corrected also in TX

`ifdef DEBUG
    `define CLK_REF `MAX_BAUDRATE*SCALE*2 // Double of FS max
`elsif RELEASE
    `define CLK_REF `SOURCE_CLK // Ready for FPGA download
`endif

reg [2:0] en_clk;
wire [2:0] output_clk;

Prescaler #(.SRC_CLK(`CLK_REF),.DIV(9600*SCALE))  Prescaler_9600 
(.src_clk(src_clk),.en(en_clk[`ID_9600]),.clk_div(output_clk[`ID_9600]));

Prescaler #(.SRC_CLK(`CLK_REF),.DIV(57600*SCALE)) Prescaler_57600
(.src_clk(src_clk),.en(en_clk[`ID_57600]),.clk_div(output_clk[`ID_57600]));

Prescaler #(.SRC_CLK(`CLK_REF),.DIV(115200*SCALE)) Prescaler_115200
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

        default: begin
            en_clk   = 3'b001;
            Uart_clk = output_clk[`ID_9600];
        end
        
    endcase
end

endmodule