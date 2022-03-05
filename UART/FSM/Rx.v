`include "../../common.v"

module Rx(
    input	clk, ena, Bit_in,
	output reg [7:0] out,
	output reg bussy
);

initial bussy = 1'b0;
initial out   = 7'b0;

wire get_bussy = bussy;

reg [3:0] cnt;
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


reg start_sampling;
reg stop_sampling;
initial stop_sampling = 1'b0;

/*If we detect the start bit start enable the 8x sampling clk*/
always @(negedge Bit_in or posedge stop_sampling) begin
	if(stop_sampling)
	begin
		start_sampling <= 1'b0;
	end
	else begin
		if(get_bussy == 1'b0)
			start_sampling <= 1'b1;
	end

end

/*This sampling will well to keep read in the middle of a pulse*/
always @(posedge clk) begin
	if (ena==1'b1 && start_sampling==1'b1) begin
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


/* Start state machine when we detect the Bit_in start bit
   or the halpulse sampling. 
*/
always @ (posedge half_pulse or posedge start_sampling) begin
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
			end
		START_BIT:
			begin 
			bussy = 1'b1;
			read_rutine = 1'b1;
			end
		READ_GPIO:
			begin
			read_rutine<= 1'b1;
			bussy <= 1'b1;
			end
		STOP_BIT:
			begin
			read_rutine<= 1'b0;
			bussy <= 1'b1;
			end
		default:
			begin
			bussy <= 1'b0;
			read_rutine<= 1'b0;
			end
	endcase
end

/*Reding bites for each coun in the middle of the pulse*/

always @(posedge get_half_pulse or negedge start_sampling) begin

	if(!start_sampling) begin
		if(state == IDLE && stop_sampling == 1'b1) 
		begin
			stop_sampling =1'b0;
		end
	end
	else begin
		if(read_rutine) 
		begin
			if(cnt == 1'b0) 
			begin
				out = 8'b0;
			end
			out = out | (Bit_in<<cnt);
			cnt = cnt+1'b1;
			stop_sampling =1'b0;
		end
		else begin
			cnt = 4'b0;
		end
		if(state == STOP_BIT)
		begin
			stop_sampling =1'b1;
		end
	end


end

endmodule
