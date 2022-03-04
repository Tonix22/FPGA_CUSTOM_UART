module Rx(
    input	src_clk,clk, ena, Bit_in,
	output reg [7:0] out,
	output reg bussy
);

/*Prescaler idea will be used to 
sample at the middle of the RX pulse
*/


reg [3:0] cnt;
// Declare state register
reg		[2:0]state;

// Declare states
parameter HOLD = 0, IDLE = 1, START_BIT = 2, READ_GPIO = 3, STOP_BIT = 4;

// Output depends only on the state
always @ (*) begin
	case (state)
		START_BIT:
			begin 
			cnt   = 4'h0;
			bussy = 1'b1;
			out   = 8'h0;
			end
		READ_GPIO:
			begin
			out = out | (Bit_in<<cnt);
			cnt = cnt+1'b1;
			bussy = 1'b1;
			end
		HOLD,IDLE:
			begin
			bussy = 1'b0;
			out   = 8'h0;
			cnt   = 4'b0;
			end
		default:
			begin
			out   = 8'h0;
			cnt   = 4'h0;
			bussy = 1'b1;
			end
	endcase
end

// Determine the next state
always @ (posedge clk) begin
	if (ena==1'b1)
		state <= HOLD;
	else
		case (state)
			HOLD:
				state <= IDLE;
			IDLE:
				if (Bit_in)
					state <= IDLE;
				else
					state <= START_BIT;
			START_BIT:
				state <= READ_GPIO;
			READ_GPIO:
				if (cnt < 4'b1000)
					state <= READ_GPIO;
				else
					state <= STOP_BIT;
			STOP_BIT:
				state <= IDLE;
			default:
                state <= HOLD;
		endcase
end

endmodule
