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
	2'b11 "STOP_BIT" -color coral,
	-default hex
	-defaultcolor black
}

#add wave -position end sim:/RX_TX_tb/src_clk
add wave -label RX_CLK -color magenta -position end sim:/RX_TX_tb/UART/uart_clk_Rx
#add wave -label SELECTORS -position end {SELECTORS {{sim:/RX_TX_tb/SW[2]} {sim:/RX_TX_tb/SW[1]} {sim:/RX_TX_tb/SW[0]}}}
#add wave -label SAMPLE_CNT -radix unsigned -position end sim:/RX_TX_tb/UART/Reciever/sampler
add wave -label SAMPLE_RX -position end  sim:/RX_TX_tb/UART/Reciever/half_pulse
add wave -position end sim:/RX_TX_tb/DataIn
add wave -radix States -position end sim:/RX_TX_tb/UART/Reciever/state
add wave -radix binary -position end  sim:/RX_TX_tb/UART/Reciever/out
add wave -label READRUNTIME -position end sim:/RX_TX_tb/UART/Reciever/read_rutine
add wave -position end sim:/RX_TX_tb/UART/Reciever/stop_sampling
add wave -position end sim:/RX_TX_tb/UART/Reciever/get_bussy

view structure
view signals
run -all
