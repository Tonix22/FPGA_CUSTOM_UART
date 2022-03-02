#!/bin/sh

BASEDIR=${PWD}
SOFT_DIR=/output_files/CounterDisplay.cdf

if [ "$1" = '-build' ]; then 
    quartus_map --read_settings_files=on --write_settings_files=off CounterDisplay -c CounterDisplay --analysis_and_elaboration
elif [ "$1" = '-all' ]; then 
    quartus_map --read_settings_files=on --write_settings_files=off CounterDisplay -c CounterDisplay --analysis_and_elaboration
    sudo -E env "PATH=$PATH" quartus_fit --read_settings_files=off --write_settings_files=off CounterDisplay -c CounterDisplay
    sudo -E env "PATH=$PATH" quartus_asm --read_settings_files=off --write_settings_files=off CounterDisplay -c CounterDisplay
    sudo -E env "PATH=$PATH" quartus_sta CounterDisplay -c CounterDisplay
    sudo -E env "PATH=$PATH" quartus_eda --read_settings_files=off --write_settings_files=off CounterDisplay -c CounterDisplay
elif [ "$1" = '-bitstream' ]; then 
    quartus_pgm -c 1 ${BASEDIR}${SOFT_DIR}
elif [ "$1" = '-test' ]; then 
    sudo -E env "PATH=$PATH" quartus_sh -t "/home/tonix/intelFPGA_lite/20.1/quartus/common/tcl/internal/nativelink/qnativesim.tcl" --rtl_sim "CounterDisplay" "CounterDisplay"
elif [ "$1" = '-vcd' ]; then 
    iverilog -o Test BCD_Counter_tb.v BCD_Counter.v Prescaler.v contador.v BCD.v
fi;



