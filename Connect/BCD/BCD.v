//signals assigment
module BCD 
( 
    input W,X,Y,Z,en,
    output A,B,C,D,E,F,G
);
assign A  = (~en) | ((~W&~X&~Y&Z) | (~W&X&~Y&~Z) | (W&~X&Y&Z) | (W&X&~Y&Z));
assign B  = (~en) | ((~W&X&~Y&Z) | (X&Y&~Z) | (W&Y&Z) | (W&X&~Z));
assign C  = (~en) | ((~W&~X&Y&~Z) | (W&X&~Z) | (W&X&Y));
assign D  = (~en) | ((~X&~Y&Z) | (~W&X&~Y&~Z) | (X&Y&Z) | (W&~X&Y&~Z));
assign E  = (~en) | ((~W&Z) | (~X&~Y&Z) | (~W&X&~Y));
assign F  = (~en) | ((~W&~X&Z) | (~W&~X&Y) | (~W&Y&Z) | (W&X&~Y&Z));
assign G  = (~en) | ((~W&~X&~Y) | (~W&X&Y&Z) | (W&X&~Y&~Z));

endmodule
