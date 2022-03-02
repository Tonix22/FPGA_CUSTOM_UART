module BCD_Counter
(
    input src_clk,
    input push_cnt,
    input rst,
    output [27:0] Display
);

wire [15:0] Digits;
wire  bcd_enable;

Counter_controller Counter_controller
(
    .src_clk(src_clk),
    .pb(push_cnt),
    .rst(rst),
    .cnt(Digits),
	.bcd_enable(bcd_enable)
);

reg [3:0]W;
reg [3:0]X;
reg [3:0]Y;
reg [3:0]Z;

initial  W = 4'b0;
initial  X = 4'b0;
initial  Y = 4'b0;
initial  Z = 4'b0;


BCD BCD_arr[3:0](W,X,Y,Z,Display[3:0],Display[7:4],
                Display[11:8],Display[15:12],Display[19:16],
                Display[23:20],Display[27:24]);


always @(posedge src_clk) begin
    {W[0],X[0],Y[0],Z[0]} = Digits[3:0];
    {W[1],X[1],Y[1],Z[1]} = Digits[7:4];
    {W[2],X[2],Y[2],Z[2]} = Digits[11:8];
    {W[3],X[3],Y[3],Z[3]} = Digits[15:12];
end


    
endmodule