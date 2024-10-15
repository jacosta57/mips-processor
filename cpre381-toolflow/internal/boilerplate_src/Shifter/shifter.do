onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tb_shifter/s_i_D
add wave -noupdate /tb_shifter/s_Right_Left
add wave -noupdate /tb_shifter/s_Logic_Arith
add wave -noupdate -radix unsigned /tb_shifter/s_Shamt
add wave -noupdate -radix hexadecimal /tb_shifter/s_o_Q
add wave -noupdate -radix binary /tb_shifter/DUT0/i_D
add wave -noupdate /tb_shifter/DUT0/Right_Left
add wave -noupdate /tb_shifter/DUT0/Logic_Arith
add wave -noupdate /tb_shifter/DUT0/s_Control
add wave -noupdate -radix unsigned /tb_shifter/DUT0/i_Shamt
add wave -noupdate -radix unsigned /tb_shifter/DUT0/s_shamt
add wave -noupdate -radix binary /tb_shifter/DUT0/o_Q
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {107 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 179
configure wave -valuecolwidth 184
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
configure wave -timelineunits ns
update
WaveRestoreZoom {45 ns} {115 ns}
