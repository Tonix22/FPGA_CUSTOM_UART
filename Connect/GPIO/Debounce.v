
`include "../../config.v"


module Debounce(
    input src_clk,pb_1,
    output reg pb_out
);
    
    wire slow_clk_en;
    wire en = 1'b1;
    Prescaler #(.SRC_CLK(`CLK_REF),.DIV(9600)) Prescaler_debounce
    (
        .src_clk(src_clk),
        .en(en),
        .clk_div(slow_clk_en)
    );
    reg [3:0]debouncer_cnt;
    initial debouncer_cnt =  4'b0000;
    always @(posedge slow_clk_en) begin
        if (pb_1 == 1'b0) begin
            if(debouncer_cnt == 3) begin
                pb_out = 1'b1;
            end
            if(debouncer_cnt  > 6)
            begin
                pb_out =1'b0;  
            end
            else
                debouncer_cnt=debouncer_cnt+1;
        end
        else
            debouncer_cnt = 4'b0000;
    end
    
endmodule



