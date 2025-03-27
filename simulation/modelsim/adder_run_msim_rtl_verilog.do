transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/mar_32_bit.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/D_flip_flop.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/decoder_2_to_4.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/decoder_4_to_16.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/z_reg.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/shr_32_bit.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/shra_32_bit.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/shl_32_bit.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/ror_32_bit.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/rol_32_bit.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/reg_32_bit.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/pc_32_bit.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/or_32_bit.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/not_32_bit.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/neg_32_bit.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/mux_32_bit.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/mux_2_to_1.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/MDR_32_bit.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/encoder_32_to_5.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/div_32_bit.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/bp_booth_mul_32.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/and_32_bit.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/adder_32_bit.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/subtractor_32_bit.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/select_and_encode.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/memram.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/CON_FF.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/defines.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/control_unit.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/datapath.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/alu.v}

vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/control_unit_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  control_unit_tb

add wave *
view structure
view signals
run 2000 ns
