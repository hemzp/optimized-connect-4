onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mainGame_testbench/clk
add wave -noupdate /mainGame_testbench/reset
add wave -noupdate /mainGame_testbench/left
add wave -noupdate /mainGame_testbench/right
add wave -noupdate /mainGame_testbench/confirm
add wave -noupdate /mainGame_testbench/board0
add wave -noupdate /mainGame_testbench/board1
add wave -noupdate /mainGame_testbench/dropDone
add wave -noupdate /mainGame_testbench/weHaveAWinner
add wave -noupdate -expand -group drop /mainGame_testbench/dut/DUU1/right
add wave -noupdate -expand -group drop /mainGame_testbench/dut/DUU1/left
add wave -noupdate -expand -group drop /mainGame_testbench/dut/DUU1/confirm
add wave -noupdate -expand -group drop /mainGame_testbench/dut/DUU1/currentPlayer
add wave -noupdate -expand -group drop /mainGame_testbench/dut/DUU1/dropDone
add wave -noupdate -expand -group drop /mainGame_testbench/dut/DUU1/board0
add wave -noupdate -expand -group drop /mainGame_testbench/dut/DUU1/board1
add wave -noupdate -expand -group drop /mainGame_testbench/dut/DUU1/dropEnable
add wave -noupdate -expand -group drop /mainGame_testbench/dut/DUU1/currentRow
add wave -noupdate -expand -group drop /mainGame_testbench/dut/DUU1/targetRow
add wave -noupdate -expand -group drop /mainGame_testbench/dut/DUU1/ledPosition
add wave -noupdate -expand -group drop /mainGame_testbench/dut/DUU1/latchedPosition
add wave -noupdate -expand -group drop /mainGame_testbench/dut/DUU1/leftPulse
add wave -noupdate -expand -group drop /mainGame_testbench/dut/DUU1/rightPulse
add wave -noupdate -expand -group drop /mainGame_testbench/dut/DUU1/confirmPulse
add wave -noupdate -expand -group drop /mainGame_testbench/dut/DUU1/ps
add wave -noupdate -expand -group drop /mainGame_testbench/dut/DUU1/ns
add wave -noupdate -expand -group drop /mainGame_testbench/dut/DUU1/computedTarget
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1965 ps} 0}
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
WaveRestoreZoom {0 ps} {9188 ps}
