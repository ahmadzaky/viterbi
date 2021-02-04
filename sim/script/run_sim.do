vlib work
vlib viterbilib

vcom -work viterbilib ../../rtl/viterbi_package.vhd

vcom -f vcomp.list
vcom ../bench/tb_systol_vit.vhd

vsim -novopt tb_systol_vit

add wave -hex -r *

run 100000 ns
