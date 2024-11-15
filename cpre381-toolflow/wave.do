onerror {resume}
quietly set dataset_list [list vsim9 vsim8 vsim7 vsim6 vsim5 vsim4 vsim3 vsim2 vsim1 vsim]
if {[catch {datasetcheck $dataset_list}]} {abort}
quietly WaveActivateNextPane {} 0
add wave -noupdate vsim9:/tb/MyMips/fetch_component/i_clk
add wave -noupdate vsim9:/tb/MyMips/fetch_component/i_rst
add wave -noupdate -radix hexadecimal vsim9:/tb/MyMips/fetch_component/o_PC
add wave -noupdate -radix hexadecimal vsim9:/tb/MyMips/IF_ID_Reg_Inst/i_Inst
add wave -noupdate -radix hexadecimal vsim9:/tb/MyMips/IF_ID_Reg_Inst/o_Inst
add wave -noupdate -radix hexadecimal vsim9:/tb/MyMips/IMem/q
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {39972 ps} 0}
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
