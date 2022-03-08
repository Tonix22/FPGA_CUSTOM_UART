`include "../../common.v"

module Rx(
    input	clk, ena, Bit_in,
	output reg [7:0] out,
	output reg bussy
);

initial bussy = 1'b0;
initial out   = 7'b0;

reg [3:0] cnt;
initial cnt = 4'b0000;
// Declare state register
reg [2:0]state;

/*Prescaler idea will be used to 
sample at the middle of the RX pulse
*/
// sample counter
reg [7:0] sampler;

reg half_pulse;
wire get_half_pulse = half_pulse;

reg cnt_toggle;
initial sampler = 8'b0;
initial half_pulse = 1'b0;

// Declare states
parameter IDLE = 0, START_BIT = 1, READ_GPIO = 2, STOP_BIT = 3;

reg phase_shift_enable;
initial phase_shift_enable = 1'b0;

/*This sampling will well to keep read in the middle of a pulse*/
always @(posedge clk) begin
	if (phase_shift_enable) begin
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

reg end_frame;


/* Start state machine when we detect the Bit_in start bit
   or the halpulse sampling. 
*/
always @ (posedge clk) begin
	case (state)
		IDLE:
			if (Bit_in)
				state <= IDLE;
			else
				state <= START_BIT;
		START_BIT:
			if(cnt == 1'b0)
				state <= START_BIT;
			else
				state <= READ_GPIO;
		READ_GPIO:
			if (cnt < 4'b1001)
				state <= READ_GPIO;
			else
				state <= STOP_BIT;
		STOP_BIT:
			if(end_frame == 1'b0)
				state <= STOP_BIT;
			else
				state <= IDLE;
		default:
			state <= IDLE;
	endcase
end

/*State machine for RX, read_rutine trigger the reading process
 reading process depends on get_half_pulse which samples data in 
 the middle of receving data
*/
reg read_rutine;

always @ (state) begin
	case (state)
		IDLE:
			begin
			bussy <= 1'b0;
			read_rutine<= 1'b0;
			phase_shift_enable<=1'b0;
			end
		START_BIT:
			begin 
			bussy = 1'b1;
			read_rutine = 1'b1;
			phase_shift_enable<=1'b1;
			end
		READ_GPIO:
			begin
			read_rutine<= 1'b1;
			phase_shift_enable<=1'b1;
			bussy <= 1'b1;
			end
		STOP_BIT:
			begin
			read_rutine<= 1'b0;
			phase_shift_enable<=1'b1;
			bussy <= 1'b1;
			end
		default:
			begin
			bussy <= 1'b0;
			read_rutine<= 1'b0;
			phase_shift_enable<=1'b0;
			end
	endcase
end

/*Reding bites for each coun in the middle of the pulse*/

always @(posedge get_half_pulse) begin

	if(read_rutine) 
	begin
		if(cnt == 1'b0) 
		begin
			out = 8'b0; // clear RX input
		end
		if(cnt > 0)
			out = out | (Bit_in<<(cnt-1));
		cnt = cnt+1'b1;
		end_frame = 1'b0;
	end
	else begin
		if(state == STOP_BIT)
		begin
			cnt = 4'b0000;
			end_frame = 1'b1;
		end
		else
		begin
			cnt = 4'b0000; // clear bit index when read finishes
		end
	end

end

endmodule
