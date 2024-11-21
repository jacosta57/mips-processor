onerror {resume}
quietly set dataset_list [list vsim2 vsim1 vsim]
if {[catch {datasetcheck $dataset_list}]} {abort}
quietly WaveActivateNextPane {} 0
add wave -noupdate vsim2:/tb/CLK
add wave -noupdate -radix hexadecimal vsim2:/tb/MyMips/IF_ID_Reg_Inst/i_PC
add wave -noupdate -radix hexadecimal vsim2:/tb/MyMips/ID_EX_Reg_inst/i_RegData0
add wave -noupdate -radix hexadecimal vsim2:/tb/MyMips/ID_EX_Reg_inst/i_RegData1
add wave -noupdate vsim2:/tb/MyMips/ID_EX_Reg_inst/i_AddrRd
add wave -noupdate vsim2:/tb/MyMips/ID_EX_Reg_inst/i_AddrRt
add wave -noupdate vsim2:/tb/MyMips/ID_EX_Reg_inst/i_AddrRs
add wave -noupdate -radix hexadecimal vsim2:/tb/MyMips/ID_EX_Reg_inst/o_RegData0
add wave -noupdate -radix hexadecimal vsim2:/tb/MyMips/ID_EX_Reg_inst/o_RegData1
add wave -noupdate vsim2:/tb/MyMips/ID_EX_Reg_inst/o_AddrRd
add wave -noupdate vsim2:/tb/MyMips/ID_EX_Reg_inst/o_AddrRt
add wave -noupdate vsim2:/tb/MyMips/ID_EX_Reg_inst/o_AddrRs
add wave -noupdate -radix hexadecimal vsim2:/tb/MyMips/alu_1/i_A
add wave -noupdate -radix hexadecimal vsim2:/tb/MyMips/alu_1/i_B
add wave -noupdate -radix hexadecimal vsim2:/tb/MyMips/alu_1/o_F
add wave -noupdate vsim2:/tb/MyMips/forwarding_unit/i_MEM_RegWr
add wave -noupdate vsim2:/tb/MyMips/forwarding_unit/i_WB_RegWr
add wave -noupdate vsim2:/tb/MyMips/forwarding_unit/i_MEM_RegDst
add wave -noupdate vsim2:/tb/MyMips/forwarding_unit/i_WB_RegDst
add wave -noupdate vsim2:/tb/MyMips/forwarding_unit/i_Rs
add wave -noupdate vsim2:/tb/MyMips/forwarding_unit/i_Rt
add wave -noupdate vsim2:/tb/MyMips/forwarding_unit/o_Mux0_s
add wave -noupdate vsim2:/tb/MyMips/forwarding_unit/o_Mux1_s
add wave -noupdate vsim2:/tb/MyMips/ALU_Mux_0/i_S
add wave -noupdate -radix hexadecimal vsim2:/tb/MyMips/ALU_Mux_0/i_D0
add wave -noupdate -radix hexadecimal vsim2:/tb/MyMips/ALU_Mux_0/i_D1
add wave -noupdate -radix hexadecimal vsim2:/tb/MyMips/ALU_Mux_0/i_D2
add wave -noupdate -radix hexadecimal vsim2:/tb/MyMips/ALU_Mux_0/o_O
add wave -noupdate vsim2:/tb/MyMips/ALU_Mux_1/i_S
add wave -noupdate -radix hexadecimal vsim2:/tb/MyMips/ALU_Mux_1/i_D0
add wave -noupdate -radix hexadecimal vsim2:/tb/MyMips/ALU_Mux_1/i_D1
add wave -noupdate -radix hexadecimal vsim2:/tb/MyMips/ALU_Mux_1/i_D2
add wave -noupdate -radix hexadecimal vsim2:/tb/MyMips/ALU_Mux_1/o_O
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {127156 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 381
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {154612 ps}
