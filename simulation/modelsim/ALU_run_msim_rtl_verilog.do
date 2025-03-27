transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/memram.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/subtractor.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/sra.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/shiftLeft.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/rotateRight.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/rotateLeft.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/register_64.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/register.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/PC_register.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/orALU.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/notALU.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/negALU.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/Mux_32to1.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/Mux_2to1.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/MDR_register.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/MAR_register.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/divisor.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/decoder2to4.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/DataPath.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/CON_FF.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/Bus.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/booth.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/andALU.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/adder.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/ALU.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/shiftRight.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/decoder_4_to_16.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/select_and_encoder.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/mux_2_to_1.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/encoder_32_to_5.v}

vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.1/elec374_project {C:/intelFPGA_lite/18.1/elec374_project/DataPath_P2_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  DataPath_P2_tb

add wave *
view structure
view signals
run 500 ns
