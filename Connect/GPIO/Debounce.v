
`include "config.v"


module Debounce(
    input src_clk,pb_1,
    output reg pb_out
);

    wire slow_clk_en;
    wire Q0,Q1,Q2,Q2_bar;
    wire en = 1'b1;
    `ifdef DEBUG
    Prescaler #(.SRC_CLK(`Test_CLK),.DIV(1)) Prescaler
    `endif
    `ifdef RELEASE
    Prescaler Prescaler
    `endif
    (
        .src_clk(src_clk),
        .en(en),
        .clk_div(slow_clk_en)
    );

    wire fast_clk;
    Prescaler #(.DIV(`MHZ(25)))ALMOST_SLOW
    (
        .src_clk(src_clk),
        .en(en),
        .clk_div(fast_clk)
    );

    my_dff_en d0(src_clk,slow_clk_en,pb_1,Q0);
    my_dff_en d1(src_clk,slow_clk_en,Q0,Q1);
    my_dff_en d2(src_clk,fast_clk,Q1,Q2);

    assign Q1_bar = ~Q1;
    initial pb_out = 0;

    always @ (posedge src_clk)
    begin
        if (Q2 & Q1_bar & !Q0) begin
            pb_out <= 1;
        end
        else 
        begin
            pb_out <= 0;
        end
    end

endmodule


// D-flip-flop with clock enable signal for debouncing module 
module my_dff_en(
    input DFF_CLOCK, 
    input clock_enable,
    input D, 
    output reg Q=1
    );
    
    always @ (posedge DFF_CLOCK) 
    begin
        if(clock_enable) 
               Q <= D;
    end

endmodule 

