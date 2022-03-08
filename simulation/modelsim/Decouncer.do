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

vlog -vlog01compat -work work +incdir+/home/tonix/Documents/QuartusCinves/UART_PROJECT/Connect/test {/home/tonix/Documents/QuartusCinves/UART_PROJECT/Connect/test/Debounce_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  Debounce_tb

radix define States {
	2'b00 "IDLE" -color cyan,
	2'b01 "START_BIT" -color yellow,
	2'b10 "READ_GPIO" -color "spring green",
	2'b11 "STOP_BIT" ,
	-default hex
	-defaultcolor black
}

add wave -label UART_CLK    -position end sim:/Debounce_tb/UART/Transmiter/clk
add wave -label PUSH_BUTTON -position end sim:/Debounce_tb/pb_1 
add wave -label DEBOUNCED   -color "spring green" -position end sim:/Debounce_tb/UART/Transmiter/send
add wave -label STATES      -radix States -position end sim:/Debounce_tb/UART/Transmiter/state 
add wave -label TX          -color cyan -position end sim:/Debounce_tb/UART/Transmiter/out
add wave -label BUFF        -position end sim:/Debounce_tb/UART/Transmiter/data

view structure
view signals
run -all
