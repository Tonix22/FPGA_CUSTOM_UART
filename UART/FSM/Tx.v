module Tx(
    input	clk, ena, send,
    input [7:0] data,
	output reg out,
	output reg bussy
);

reg transmit;
reg first;
reg [3:0] cnt;
initial transmit = 1'b0;
initial first = 1'b0;

always @(posedge clk) 
begin
	if (send && transmit == 1'b0) begin
		transmit = 1'b1;
		out <= 1'b1; // IDLE
		cnt <= 4'b0; // reset count
		first <= 1'b0; 
	end
	else begin
		// think the as 10 bit fashion
		if(first == 1'b0) // start bit
		begin
			first <= 1'b1; 
			out   <= 1'b0;
		end
		else if (cnt == 4'h8) 
		begin
			out   <= 1'b1;
			first <= 1'b1;
			transmit <= 1'b0;
		end
		else 
		begin
			first <= 1'b1; 
			out = data[cnt];
			cnt = cnt+1'b1;
		end
	end

end 



endmodule