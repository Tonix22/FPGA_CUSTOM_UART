module Tx(
    input	clk, ena, send,
    input [7:0] data,
	output reg out
);


reg [3:0] cnt;
reg [1:0]state;
initial state = 2'b00;


// Declare states
parameter IDLE = 0, START_BIT = 1, SEND_GPIO = 2, STOP_BIT = 3;

always @ (posedge clk) begin
	case (state)
		IDLE:
			if (!send)
				state <= IDLE;
			else
				state <= START_BIT;
		START_BIT:
				state <= SEND_GPIO;
		SEND_GPIO:
			if (cnt == 4'b0111)
				state <= STOP_BIT;
			else
				state <= SEND_GPIO;
		STOP_BIT:
				if(send)
					state <= STOP_BIT;
				else
					state <= IDLE;
		default:
			state <= IDLE;
	endcase
end


always @(posedge clk) 
begin
	case (state)
		IDLE:
		begin
			out   <= 1'b1; // IDLE
			cnt   <= 4'b0; // reset count
		end
		START_BIT:
		begin
			out   <= 1'b0;
			cnt   <= 4'b0;
		end
		SEND_GPIO:
		begin
			out   = data[cnt];
			cnt   = cnt+1'b1;
		end

		STOP_BIT:
		begin
			out   <= 1'b1;
			cnt   <= 4'b0;
		end
	endcase
end 



endmodule