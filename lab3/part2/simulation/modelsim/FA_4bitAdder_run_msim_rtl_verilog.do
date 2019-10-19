transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/Projects/ECE241/lab3/pt2b {E:/Projects/ECE241/lab3/pt2b/FA_4bitAdder.v}

