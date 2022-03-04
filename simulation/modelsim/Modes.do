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

vlog -vlog01compat -work work +incdir+/home/tonix/Documents/QuartusCinves/UART_PROJECT/test {/home/tonix/Documents/QuartusCinves/UART_PROJECT/test/Modes_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  Modes_tb

add wave -label CLK -position end sim:/Modes_tb/src_clk
add wave -label BAUD_RATE_SEL -position end sim:/Modes_tb/UART/baud_rate_sel
add wave -label DATA_DIR -color #FFCE00 -position end sim:/Modes_tb/UART/data_dir
add wave -label STREAM -color white -position end sim:/Modes_tb/UART/stream
add wave -label SELECTORS -position end {SELECTORS {{sim:/Modes_tb/SW[2]} {sim:/Modes_tb/SW[1]} {sim:/Modes_tb/SW[0]}}}
add wave -label SW0 -color cyan -position end sim:/Modes_tb/SW[0]
view structure
view signals
run -all
