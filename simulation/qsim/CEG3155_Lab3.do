onerror {quit -f}
vlib work
vlog -work work CEG3155_Lab3.vo
vlog -work work CEG3155_Lab3.vt
vsim -novopt -c -t 1ps -L cycloneive_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.top1_vlg_vec_tst
vcd file -direction CEG3155_Lab3.msim.vcd
vcd add -internal top1_vlg_vec_tst/*
vcd add -internal top1_vlg_vec_tst/i1/*
add wave /*
run -all
