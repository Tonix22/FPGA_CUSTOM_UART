`include "../../common.v"

module Rx(
    input	clk, ena, Bit_in,
	output reg [7:0] out,
	output reg bussy
);

reg [3:0] cnt;
// Declare state register
reg		[2:0]state;

/*Prescaler idea will be used to 
sample at the middle of the RX pulse
*/
// sample counter
reg [7:0] sampler;
reg half_pulse;
initial sampler = 8'b0;
initial half_pulse = 1'b0;

// Declare states
parameter IDLE = 0, START_BIT = 1, READ_GPIO = 2, STOP_BIT = 3;

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
		IDLE:
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

/// sample in the middle of pulse
always @(posedge clk) begin
	if (ena==1'b1) begin
		if(sampler == 8'd`HALF_PULSE-1'b1)
			half_pulse = 1'b1;
		if(sampler == (8'd`HALF_PULSE))
			half_pulse = 1'b0;
		if(sampler == `SAMPLING_FACTOR-1) 
			sampler = 8'b0;
		else // only incremment if count is not zero
			sampler = sampler +1'b1;
	end
	else begin
		sampler = 8'b0;
	end
end



// Determine the next state
always @ (posedge half_pulse) begin
	case (state)
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
			state <= IDLE;
	endcase
end

endmodule
