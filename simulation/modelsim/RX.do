transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/tonix/Documents/QuartusCinves/UART_PROJECT/UART/FSM {/home/tonix/Documents/QuartusCinves/UART_PROJECT/UART/FSM/Tx.v}
vlog -vlog01compat -work work +incdir+/home/tonix/Documents/QuartusCinves/UART_PROJECT/Connect/BCD {/home/tonix/Documents/QuartusCinves/UART_PROJECT/Connect/BCD/BCD.v}
vlog -vlog01compat -work work +incdir+/home/tonix/Documents/QuartusCinves/UART_PROJECT {/home/tonix/Documents/QuartusCinves/UART_PROJECT/common.v}
vlog -vlog01compat -work work +incdir+/home/tonix/Documents/QuartusCinves/UART_PROJECT {/home/tonix/Documents/QuartusCinves/UART_PROJECT/config.v}
vlog -vlog01compat -work work +incdir+/home/tonix/Documents/QuartusCinves/UART_PROJECT {/home/tonix/Documents/QuartusCinves/UART_PROJECT/UART_BCD.v}
vlog -vlog01compat -work work +incdir+/home/tonix/Documents/QuartusCinves/UART_PROJECT/UART/FSM {/home/tonix/Documents/QuartusCinves/UART_PROJECT/UART/FSM/Rx.v}
vlog -vlog01compat -work work +incdir+/home/tonix/Documents/QuartusCinves/UART_PROJECT/Connect/BCD {/home/tonix/Documents/QuartusCinves/UART_PROJECT/Connect/BCD/DigitsDisplay.v}
vlog -vlog01compat -work work +incdir+/home/tonix/Documents/QuartusCinves/UART_PROJECT/UART/Prescaler {/home/tonix/Documents/QuartusCinves/UART_PROJECT/UART/Prescaler/Baudrate.v}
vlog -vlog01compat -work work +incdir+/home/tonix/Documents/QuartusCinves/UART_PROJECT/UART/Prescaler {/home/tonix/Documents/QuartusCinves/UART_PROJECT/UART/Prescaler/Prescaler.v}

vlog -vlog01compat -work work +incdir+/home/tonix/Documents/QuartusCinves/UART_PROJECT/test {/home/tonix/Documents/QuartusCinves/UART_PROJECT/test/RX_TX_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  RX_TX_tb

radix define States {
	2'b00 "IDLE" -color cyan,
	2'b01 "START_BIT" -color yellow,
	2'b10 "READ_GPIO" -color "spring green",
	2'b11 "STOP_BIT" ,
	-default hex
	-defaultcolor black
}

radix define States_TX {
	3'b000 "HOLD" -color white,
	3'b001 "IDLE" -color cyan,
	3'b010 "START_BIT" -color yellow,
	3'b011 "READ_GPIO" -color "spring green",
	3'b100 "STOP_BIT" -color coral,
	-default hex
	-defaultcolor black
}



radix define BCD_States {
	7'b0000001 "ZERO",
	7'b1001111 "ONE",
	7'b0010010 "TWO",
	7'b0000110 "TREE",
	7'b1001100 "FOUR",
	7'b0100100 "FIVE",
	7'b0100000 "SIX",
	7'b0001111 "SEVEN",
	7'b0000000 "EIGHT",
	7'b0001100 "NINE",
	7'b0001000 "TEN",
	7'b1100000 "0",
	7'b0110001 "1",
	7'b1000010 "C",
	7'b0110000 "C",
	7'b0111000 "D",
	7'b1111111 "OFF",
	-default hex
	-defaultcolor black
}

#add wave -label SELECTORS -position end {SELECTORS {{sim:/RX_TX_tb/SW[2]} {sim:/RX_TX_tb/SW[1]} {sim:/RX_TX_tb/SW[0]}}}
#add wave -label SAMPLE_CNT -radix unsigned -position end sim:/RX_TX_tb/UART/Reciever/sampler
add wave -label SAMPLE_RX -position end  sim:/RX_TX_tb/UART/Reciever/half_pulse
add wave -position end sim:/RX_TX_tb/DataIn
add wave -radix States -label RX_STATES -position end sim:/RX_TX_tb/UART/Reciever/state
add wave -radix hexadecimal -position end  sim:/RX_TX_tb/UART/Reciever/out
add wave -label READRUNTIME -position end sim:/RX_TX_tb/UART/Reciever/read_rutine

#add wave -radix BCD_States -label BCD0 -position end {BCD0 {sim:/RX_TX_tb/Display[0] sim:/RX_TX_tb/Display[6] sim:/RX_TX_tb/Display[12] sim:/RX_TX_tb/Display[18] sim:/RX_TX_tb/Display[24] sim:/RX_TX_tb/Display[30] sim:/RX_TX_tb/Display[36]}}
#add wave -radix BCD_States -label BCD1 -position end {BCD1 {sim:/RX_TX_tb/Display[1] sim:/RX_TX_tb/Display[7] sim:/RX_TX_tb/Display[13] sim:/RX_TX_tb/Display[19] sim:/RX_TX_tb/Display[25] sim:/RX_TX_tb/Display[31] sim:/RX_TX_tb/Display[37]}}
#add wave -radix BCD_States -label BCD2 -position end {BCD2 {sim:/RX_TX_tb/Display[2] sim:/RX_TX_tb/Display[8] sim:/RX_TX_tb/Display[14] sim:/RX_TX_tb/Display[20] sim:/RX_TX_tb/Display[26] sim:/RX_TX_tb/Display[32] sim:/RX_TX_tb/Display[38]}}
#add wave -radix BCD_States -label BCD3 -position end {BCD3 {sim:/RX_TX_tb/Display[3] sim:/RX_TX_tb/Display[9] sim:/RX_TX_tb/Display[15] sim:/RX_TX_tb/Display[21] sim:/RX_TX_tb/Display[27] sim:/RX_TX_tb/Display[33] sim:/RX_TX_tb/Display[39]}}
#add wave -radix BCD_States -label BCD4 -position end {BCD4 {sim:/RX_TX_tb/Display[4] sim:/RX_TX_tb/Display[10] sim:/RX_TX_tb/Display[16] sim:/RX_TX_tb/Display[22] sim:/RX_TX_tb/Display[28] sim:/RX_TX_tb/Display[34] sim:/RX_TX_tb/Display[40]}}
#add wave -radix BCD_States -label BCD5 -position end {BCD5 {sim:/RX_TX_tb/Display[5] sim:/RX_TX_tb/Display[11] sim:/RX_TX_tb/Display[17] sim:/RX_TX_tb/Display[23] sim:/RX_TX_tb/Display[29] sim:/RX_TX_tb/Display[35] sim:/RX_TX_tb/Display[41]}}

add wave -radix States_TX -label TX_STATES -position end  sim:/RX_TX_tb/UART/Transmiter/state
add wave -position end sim:/RX_TX_tb/UART/Transmiter/*

add wave -label SELECTORS -position end {SELECTORS {{sim:/RX_TX_tb/SW[2]} {sim:/RX_TX_tb/SW[1]} {sim:/RX_TX_tb/SW[0]}}}

view structure
view signals
run -all
