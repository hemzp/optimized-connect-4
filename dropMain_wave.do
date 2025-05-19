onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dropMain_testbench/clk
add wave -noupdate /dropMain_testbench/reset
add wave -noupdate /dropMain_testbench/left
add wave -noupdate /dropMain_testbench/right
add wave -noupdate /dropMain_testbench/confirm
add wave -noupdate /dropMain_testbench/currentPlayer
add wave -noupdate /dropMain_testbench/dropDone
add wave -noupdate /dropMain_testbench/board0
add wave -noupdate /dropMain_testbench/board1
add wave -noupdate /dropMain_testbench/i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {406 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 50
configure wave -gridperiod 100
configure wave -griddelta 2
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {4148 ps}
