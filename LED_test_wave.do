onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /LED_testbench/RST
add wave -noupdate /LED_testbench/MOVELEFT
add wave -noupdate /LED_testbench/MOVERIGHT
add wave -noupdate /LED_testbench/CONFIRM
add wave -noupdate /LED_testbench/clk
add wave -noupdate /LED_testbench/board0
add wave -noupdate /LED_testbench/board1
add wave -noupdate /LED_testbench/RedPixels
add wave -noupdate /LED_testbench/GrnPixels
add wave -noupdate /LED_testbench/positionMain
add wave -noupdate /LED_testbench/activePlayer
add wave -noupdate /LED_testbench/winEnable
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {55 ps} 0}
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
WaveRestoreZoom {0 ps} {901 ps}
