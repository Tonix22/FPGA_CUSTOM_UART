module Tx(
    input	clk, ena, send,
    input [7:0] data,
	output reg out,
	output reg bussy
);

reg [3:0] cnt;
// Declare state register
reg [2:0] state;

// Declare states
parameter HOLD = 0, IDLE = 1, START_BIT = 2, READ_GPIO = 3, STOP_BIT = 4;


// Determine the next state
always @ (posedge clk) begin
	if (ena==1'b0)
		state <= HOLD;
	else
		case (state)
			HOLD:
				state <= IDLE;
			IDLE:
				begin
				if (!send)
					state <= IDLE;
				else
					state <= START_BIT;
				end
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

reg transmit_rutine;

// Output depends only on the state
always @ (state) begin
	case (state)
       IDLE:
			begin
			bussy <= 1'b0;
			transmit_rutine <= 1'b0;
			end
		START_BIT:
			begin 
			bussy <= 1'b1;
			transmit_rutine <= 1'b1;
			end
		READ_GPIO:
			begin
			bussy <= 1'b1;
			transmit_rutine <= 1'b1;
            end
        STOP_BIT:
		  begin
			bussy <= 1'b1;
			transmit_rutine <= 1'b0;
			end
		default:
			begin 
			bussy <= 1'b1;
			transmit_rutine <= 1'b0;
			end
	endcase
end

reg first;
initial first = 1'b0;

always @(posedge clk or posedge transmit_rutine) 
begin
	if (transmit_rutine) begin
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
		end
		else 
		begin
			first <= 1'b1; 
			out = data[cnt];
			cnt = cnt+1'b1;
		end
		
		
	end
	else begin
		out <= 1'b1; // IDLE
		cnt <= 1'b0; // reset count
		first <= 1'b0; 
	end

end 
	



endmodule
