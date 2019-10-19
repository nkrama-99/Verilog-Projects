# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog ALU.v

#load simulation using mux as the top level simulation module
vsim ALU

#log all signals and add some signals to waveform window
# add wave {/*} would add all items in top level simulation module
log {/*}
add wave {/*}

#case 1
force {SW[9]}0
force {KEY[0]} 0
force {KEY[1]}1
#CASE 1 force Data: 0000 and 1101  Clock: 1  Reset_b: 0
force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 1
force {KEY[3]} 0
force {KEY[2]} 0
force {KEY[1]} 0
force {SW[9]} 0
force {KEY[0]} 1
run 1ns
force {KEY[0]} 0
run 1ns
force {KEY[0]} 1
run 1ns
force {SW[9]}0
force {KEY[0]} 0
force {KEY[1]}1

#CASE 2 force Data: 1111 and 0000  Clock: 1  Reset_b: 0
force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 1
force {SW[3]} 1
force {KEY[3]} 0
force {KEY[2]} 0
force {KEY[1]} 1
force {SW[9]} 0
run 1ns
force {KEY[0]} 1
run 1ns
force {KEY[0]} 0
run 1ns
force {KEY[0]} 1
run 1ns
force {SW[9]}0
force {KEY[0]} 0
force {KEY[1]}1

#CASE 3 force Data: 0000 and 1010  Clock: 1  Reset_b: 0
force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 1
force {KEY[3]} 0
force {KEY[2]} 1
force {KEY[1]} 0
force {SW[9]} 0
force {KEY[0]} 0
run 1ns
force {KEY[0]} 1
run 1ns
force {KEY[0]} 0
run 1ns
force {KEY[0]} 1
run 1ns
force {SW[9]}0
force {KEY[0]} 0
force {KEY[1]}1

#CASE 4 force Data: 1100 and 0000 Clock: 1 Reset_b: 0
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 1
force {KEY[3]} 0
force {KEY[2]} 1
force {KEY[1]} 1
force {SW[9]} 0
force {KEY[0]} 0
run 1ns
force {KEY[0]} 1
run 1ns
force {KEY[0]} 0
run 1ns
force {KEY[0]} 1
run 1ns

#CASE 5 
force {SW[9]}0
force {KEY[0]} 0
force {KEY[1]}1

#CASE 6 force Data: 1100 and 0000 Clock: 1 Reset_b: 0
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 1
force {KEY[3]} 1
force {KEY[2]} 0
force {KEY[1]} 1
force {SW[9]} 0
force {KEY[0]} 0
run 1ns
force {KEY[0]} 1
run 1ns
force {KEY[0]} 0
run 1ns
force {KEY[0]} 1
run 1ns
force {SW[9]}0
force {KEY[0]} 0
force {KEY[1]}1

#CASE 7 force Data: 1100 and 0000 Clock: 1 Reset_b: 0
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 1
force {KEY[3]} 1
force {KEY[2]} 1
force {KEY[1]} 0
force {SW[9]} 0
force {KEY[0]} 0
run 1ns
force {KEY[0]} 1
run 1ns
force {KEY[0]} 0
run 1ns
force {KEY[0]} 1
run 1ns
force {SW[9]}0
force {KEY[0]} 0
force {KEY[1]}1

#CASE 8 force Data: 1100 and 0000 Clock: 1 Reset_b: 0
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 1
force {KEY[3]} 1
force {KEY[2]} 1
force {KEY[1]} 1
force {SW[9]} 0
force {KEY[0]} 0
run 1ns
force {KEY[0]} 1
run 1ns
force {KEY[0]} 0
run 1ns
force {KEY[0]} 1
run 1ns
