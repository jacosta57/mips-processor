onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_stallhalt_regs/s_CLK
add wave -noupdate /tb_stallhalt_regs/s_IFID_Stall
add wave -noupdate /tb_stallhalt_regs/s_IFID_Flush
add wave -noupdate /tb_stallhalt_regs/s_IDEX_Stall
add wave -noupdate /tb_stallhalt_regs/s_IDEX_Flush
add wave -noupdate /tb_stallhalt_regs/s_EXMEM_Stall
add wave -noupdate /tb_stallhalt_regs/s_EXMEM_Flush
add wave -noupdate /tb_stallhalt_regs/s_MEMWB_Stall
add wave -noupdate /tb_stallhalt_regs/s_MEMWB_Flush
add wave -noupdate -radix hexadecimal /tb_stallhalt_regs/s_PC_plus_4
add wave -noupdate -radix hexadecimal /tb_stallhalt_regs/s_ID_PC
add wave -noupdate -radix hexadecimal /tb_stallhalt_regs/s_EX_PC
add wave -noupdate -radix hexadecimal /tb_stallhalt_regs/s_MEM_PC
add wave -noupdate -radix hexadecimal /tb_stallhalt_regs/s_WB_PC
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {86 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 271
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
configure wave -timelineunits ns
update
WaveRestoreZoom {84 ns} {924 ns}
