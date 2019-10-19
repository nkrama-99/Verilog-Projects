# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog FA_4bitAdder.v

#load simulation using mux as the top level simulation module
vsim FA_4bitAdder

#log all signals and add some signals to waveform window
# add wave {/*} would add all items in top level simulation module
log {/*}
add wave {/*}

# 0100 + 0100 = 1000
# input B
force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0
# input A
force {SW[4]} 0
force {SW[5]} 1
force {SW[6]} 0
force {SW[7]} 0
# Cin
force {SW[8]} 0
run 10ns

# 1000 + 1000 = 10000
# input B
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0
# input A
force {SW[4]} 1
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0
# Cin
force {SW[8]} 0
run 10ns

# 1010+1001=10011
# input B
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 0
# input A
force {SW[4]} 1
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 1
# Cin
force {SW[8]} 0
run 10ns

# 1110+1011=11001
# input B
force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 1
force {SW[3]} 0
# input A
force {SW[4]} 1
force {SW[5]} 0
force {SW[6]} 1
force {SW[7]} 1
# Cin
force {SW[8]} 0
run 10ns

# 0010+1011=1101
# input B
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 0
# input A
force {SW[4]} 1
force {SW[5]} 0
force {SW[6]} 1
force {SW[7]} 1
# Cin
force {SW[8]} 0
run 10ns

# 1101+1011=11000
# input B
force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 1
# input A
force {SW[4]} 1
force {SW[5]} 0
force {SW[6]} 1
force {SW[7]} 1
# Cin
force {SW[8]} 0
run 10ns

# 1010+0000=1010
# input B
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 0
# input A
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0
# Cin
force {SW[8]} 0
run 10ns

# 1010+0101=1111
# input B
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 0
# input A
force {SW[4]} 0
force {SW[5]} 1
force {SW[6]} 0
force {SW[7]} 1
# Cin
force {SW[8]} 0
run 10ns

# 0111+0001=1000
# input B
force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 1
force {SW[3]} 1
# input A
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 1
# Cin
force {SW[8]} 0
run 10ns

# 1111+1001=11000
# input B
force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 1
force {SW[3]} 1
# input A
force {SW[4]} 1
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 1
# Cin
force {SW[8]} 0
run 10ns

# 0111+1001=10000
# input B
force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 1
force {SW[3]} 1
# input A
force {SW[4]} 1
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 1
# Cin
force {SW[8]} 0
run 10ns

# 0000+0000=0000
# input B
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0
# input A
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0
# Cin
force {SW[8]} 0
run 10ns

# 1111+1111=11110
# input B
force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 1
force {SW[3]} 1
# input A
force {SW[4]} 1
force {SW[5]} 1
force {SW[6]} 1
force {SW[7]} 1
# Cin
force {SW[8]} 0
run 10ns