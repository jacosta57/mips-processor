onerror {resume}
quietly set dataset_list [list vsim3 vsim2 vsim1 vsim]
if {[catch {datasetcheck $dataset_list}]} {abort}
quietly WaveActivateNextPane {} 0
add wave -noupdate vsim2:/tb/MyMips/fetch_component/i_clk
add wave -noupdate vsim2:/tb/MyMips/control_component/i_opcode
add wave -noupdate vsim2:/tb/MyMips/control_component/i_funct
add wave -noupdate vsim2:/tb/MyMips/control_component/i_reset
add wave -noupdate vsim2:/tb/MyMips/control_component/o_RegDst
add wave -noupdate vsim2:/tb/MyMips/control_component/o_Jump
add wave -noupdate vsim2:/tb/MyMips/control_component/o_JumpReturn
add wave -noupdate vsim2:/tb/MyMips/control_component/o_Jal
add wave -noupdate vsim2:/tb/MyMips/control_component/o_Branch
add wave -noupdate vsim2:/tb/MyMips/control_component/o_Zero_Extend
add wave -noupdate vsim2:/tb/MyMips/control_component/o_MemRead
add wave -noupdate vsim2:/tb/MyMips/control_component/o_MemtoReg
add wave -noupdate vsim2:/tb/MyMips/control_component/o_ALUOp
add wave -noupdate vsim2:/tb/MyMips/control_component/o_MemWrite
add wave -noupdate vsim2:/tb/MyMips/control_component/o_ALUSrc
add wave -noupdate vsim2:/tb/MyMips/control_component/o_RegWrite
add wave -noupdate vsim2:/tb/MyMips/control_component/o_Halt
add wave -noupdate vsim2:/tb/MyMips/control_component/r_control
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {245061 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 359
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
WaveRestoreZoom {0 ps} {253978 ps}
