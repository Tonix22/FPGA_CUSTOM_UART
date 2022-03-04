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

add wave -color yellow -position end sim:/Modes_tb/UART/Display/BCD_en

add wave -label BCD0 -position end {BCD0 {sim:/Modes_tb/Display[0] sim:/Modes_tb/Display[6] sim:/Modes_tb/Display[12] sim:/Modes_tb/Display[18] sim:/Modes_tb/Display[24] sim:/Modes_tb/Display[30] sim:/Modes_tb/Display[36]}}
add wave -label BCD1 -position end {BCD1 {sim:/Modes_tb/Display[1] sim:/Modes_tb/Display[7] sim:/Modes_tb/Display[13] sim:/Modes_tb/Display[19] sim:/Modes_tb/Display[25] sim:/Modes_tb/Display[31] sim:/Modes_tb/Display[37]}}
add wave -label BCD2 -position end {BCD2 {sim:/Modes_tb/Display[2] sim:/Modes_tb/Display[8] sim:/Modes_tb/Display[14] sim:/Modes_tb/Display[20] sim:/Modes_tb/Display[26] sim:/Modes_tb/Display[32] sim:/Modes_tb/Display[38]}}
add wave -label BCD3 -position end {BCD3 {sim:/Modes_tb/Display[3] sim:/Modes_tb/Display[9] sim:/Modes_tb/Display[15] sim:/Modes_tb/Display[21] sim:/Modes_tb/Display[27] sim:/Modes_tb/Display[33] sim:/Modes_tb/Display[39]}}
add wave -label BCD4 -position end {BCD4 {sim:/Modes_tb/Display[4] sim:/Modes_tb/Display[10] sim:/Modes_tb/Display[16] sim:/Modes_tb/Display[22] sim:/Modes_tb/Display[28] sim:/Modes_tb/Display[34] sim:/Modes_tb/Display[40]}}
add wave -label BCD5 -position end {BCD5 {sim:/Modes_tb/Display[5] sim:/Modes_tb/Display[11] sim:/Modes_tb/Display[17] sim:/Modes_tb/Display[23] sim:/Modes_tb/Display[29] sim:/Modes_tb/Display[35] sim:/Modes_tb/Display[41]}}




view structure
view signals
run -all
