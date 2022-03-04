`include "../../common.v"

/***********************************************************
*
*  Mode Baudrate -> msg(1:0) : Give the clk select in BCD format
*  Mode TX       -> msg(7:0) : Print ascii digit un on BCD
*  Mode RX       -> msg(7:0) : Print ascii digit un on BCD
*
************************************************************/
module DigitsDisplay
(
    input src_clk,
    input mode,        // Baudrate / Data
    input  [7:0] msg,  // 8 bit
    output [`BCD_DISPLAY_LEDS:0] Display 
);


reg [`BCD_MAX_IDX:0]W;
reg [`BCD_MAX_IDX:0]X;
reg [`BCD_MAX_IDX:0]Y;
reg [`BCD_MAX_IDX:0]Z;
reg [`BCD_MAX_IDX:0]BCD_en;

initial  W = `BCD_DIM'b0;
initial  X = `BCD_DIM'b0;
initial  Y = `BCD_DIM'b0;
initial  Z = `BCD_DIM'b0;
initial BCD_en = `BCD_DIM'b1;


BCD BCD_arr[`BCD_MAX_IDX:0](W,X,Y,Z,BCD_en,
                            //BCD TENSOR       SEGMENT SECTION
                            Display[5:0],   // 0 
                            Display[11:6],  // 1
                            Display[17:12], // 2
                            Display[23:18], // 3
                            Display[29:24], // 4
                            Display[35:30], // 5
                            Display[41:36]); // 6
             


always @(posedge src_clk) begin
    if (mode == `BAUDRATE_MODE) begin

        BCD_en [`BCD_MAX_IDX:0] = `BCD_DIM'b1;
        
        case (msg)
            `SEL_9600 : begin
                        {W[0],X[0],Y[0],Z[0]} = 4'h0;
                        {W[1],X[1],Y[1],Z[1]} = 4'h0;
                        {W[2],X[2],Y[2],Z[2]} = 4'h6;
                        {W[3],X[3],Y[3],Z[3]} = 4'h9;
                        BCD_en [`BCD_MAX_IDX:4] = 2'b0;
                        end
            `SEL_57600 : begin
                        {W[0],X[0],Y[0],Z[0]} = 4'h0;
                        {W[1],X[1],Y[1],Z[1]} = 4'h0;
                        {W[2],X[2],Y[2],Z[2]} = 4'h6;
                        {W[3],X[3],Y[3],Z[3]} = 4'h7;
                        {W[4],X[4],Y[4],Z[4]} = 4'h5;
                        BCD_en[5]=1'b0;
                        end
            `SEL_115200 :begin
                        {W[0],X[0],Y[0],Z[0]} = 4'h0;
                        {W[1],X[1],Y[1],Z[1]} = 4'h0;
                        {W[2],X[2],Y[2],Z[2]} = 4'h2;
                        {W[3],X[3],Y[3],Z[3]} = 4'h5;
                        {W[4],X[4],Y[4],Z[4]} = 4'h1;
                        {W[5],X[5],Y[5],Z[5]} = 4'h1;
                        end
            default:
                BCD_en [`BCD_MAX_IDX:0] = `BCD_DIM'b0;
        endcase
    end
    else if (mode == `DATA_MODE) begin
        // it transparent for RX or TX mode it only display ASCII binary value
        {W[0],X[0],Y[0],Z[0]} = msg[3:0];
        {W[1],X[1],Y[1],Z[1]} = msg[7:4];
    end

end


    
endmodule