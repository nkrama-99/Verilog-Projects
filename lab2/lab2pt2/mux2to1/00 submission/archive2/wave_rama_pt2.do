# own .do template
# author: Ramakrishna Natarajan

# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog mux2to1.v

#load simulation using mux as the top level simulation module
vsim mux2to1

#log all signals and add some signals to waveform window
log {/*}

# add wave {/*} would add all items in top level simulation module
add wave {/*}

#forcing simulation

force {SW[0]} 0
force {SW[1]} 0
force {SW[9]} 0
run 10ns

force {SW[0]} 0
force {SW[1]} 0
force {SW[9]} 1
run 10ns

force {SW[0]} 0
force {SW[1]} 1
force {SW[9]} 0
run 10ns

force {SW[0]} 0
force {SW[1]} 1
force {SW[9]} 1
run 10ns

force {SW[0]} 1
force {SW[1]} 0
force {SW[9]} 0
run 10ns