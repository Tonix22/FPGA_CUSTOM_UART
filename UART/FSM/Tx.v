module Tx(
    input	clk, ena, send,reset,
    input [7:0] data,
	output reg out,
	output reg bussy
);

reg [3:0] cnt;
// Declare state register
reg [2:0] state;

// Declare states
parameter HOLD = 0, IDLE = 1, START_BIT = 2, READ_GPIO = 3, STOP_BIT = 4;

// Output depends only on the state
always @ (state) begin
	case (state)
       IDLE:
			begin
			bussy = 1'b0;
			out   = 1'b1;
			cnt   = 4'h0;
			end
		START_BIT:
			begin 
			cnt   = 4'h0;
			bussy = 1'b1;
         out   = 1'b0;
			end
		READ_GPIO:
			begin
			bussy = 1'b1;
			out = data[cnt];
			cnt = cnt+1'b1;
            end
        STOP_BIT:
		  begin
				cnt   = 4'h0;
				bussy = 1'b1;
            out   = 1'b1;
			end
		default:
			begin 
			out = 1'b0;
			cnt = 4'h0;
			bussy = 1'b1;
			end
	endcase
end

// Determine the next state
always @ (posedge clk) begin
	if (reset == 1'b1 || ena==1'b1)
		state <= HOLD;
	else
		case (state)
			HOLD:
				state <= IDLE;
			IDLE:
				if (!send)
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
