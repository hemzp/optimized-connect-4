onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /userInput_testbench/clk
add wave -noupdate /userInput_testbench/reset
add wave -noupdate /userInput_testbench/inSignal1
add wave -noupdate /userInput_testbench/inSignal2
add wave -noupdate /userInput_testbench/confirmSignal
add wave -noupdate /userInput_testbench/outSignal1
add wave -noupdate /userInput_testbench/outSignal2
add wave -noupdate /userInput_testbench/outSignal3
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {272 ps} 0}
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
WaveRestoreZoom {200 ps} {1200 ps}
