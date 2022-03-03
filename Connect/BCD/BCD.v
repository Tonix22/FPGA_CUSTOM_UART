//signals assigment
module BCD 
( 
    input W,X,Y,Z,
    output A,B,C,D,E,F,G
);
assign A  = (~W&~X&~Y&Z) | (~W&X&~Y&~Z) | (W&~X&Y&Z) | (W&X&~Y&Z);
assign B  = (~W&X&~Y&Z) | (X&Y&~Z) | (W&Y&Z) | (W&X&~Z);
assign C  = (~W&~X&Y&~Z) | (W&X&~Z) | (W&X&Y);
assign D  = (~X&~Y&Z) | (~W&X&~Y&~Z) | (X&Y&Z) | (W&~X&Y&~Z);
assign E  = (~W&Z) | (~X&~Y&Z) | (~W&X&~Y);
assign F  = (~W&~X&Z) | (~W&~X&Y) | (~W&Y&Z) | (W&X&~Y&Z);
assign G  = (~W&~X&~Y) | (~W&X&Y&Z) | (W&X&~Y&~Z);

endmodule
