
`include "../../config.v"


module Debounce(
    input src_clk,pb_1,
    output reg pb_out
);
    initial pb_out = 1'b0;
    wire slow_clk_en;
    wire en = 1'b1;
    Prescaler #(.SRC_CLK(`SOURCE_CLK),.DIV(1000)) Prescaler_debounce
    (
        .src_clk(src_clk),
        .en(en),
        .clk_div(slow_clk_en)
    );
    reg [7:0]debouncer_cnt;
    initial debouncer_cnt =  7'h00;
    always @(posedge slow_clk_en) begin
        if (pb_1 == 1'b0) begin
            if(debouncer_cnt == 40) begin //40 ms DEBOUNCE
                pb_out = 1'b1;
            end
            if(debouncer_cnt  > 60) // 20 ms ON HIGH
            begin
                pb_out =1'b0;  
            end
            else
                debouncer_cnt=debouncer_cnt+1'b1;
        end
        else
            debouncer_cnt = 4'b0000;
    end
    
endmodule



