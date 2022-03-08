`define MHZ(freq) freq*1000000
`define PRESCALE_CNT(ref_clk,freq) (ref_clk/freq)

`define SOURCE_CLK `MHZ(50)
`define Output_frequency 20//Hz 125 ms
`define MAX_VALUE 9768
`define Test_CLK 10

`define RELEASE
//`define DEBUG