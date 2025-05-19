onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /drop_testbench/dut/clk
add wave -noupdate /drop_testbench/dut/reset
add wave -noupdate /drop_testbench/dut/right
add wave -noupdate /drop_testbench/dut/left
add wave -noupdate /drop_testbench/dut/confirm
add wave -noupdate /drop_testbench/dut/currentPlayer
add wave -noupdate /drop_testbench/dut/dropDone
add wave -noupdate /drop_testbench/dut/board0
add wave -noupdate /drop_testbench/dut/board1
add wave -noupdate /drop_testbench/dut/dropEnable
add wave -noupdate /drop_testbench/dut/currentRow
add wave -noupdate /drop_testbench/dut/targetRow
add wave -noupdate /drop_testbench/dut/leftPulse
add wave -noupdate /drop_testbench/dut/rightPulse
add wave -noupdate /drop_testbench/dut/confirmPulse
add wave -noupdate /drop_testbench/dut/ps
add wave -noupdate /drop_testbench/dut/ns
add wave -noupdate -expand -group pos /drop_testbench/dut/cursor/clk
add wave -noupdate -expand -group pos /drop_testbench/dut/cursor/reset
add wave -noupdate -expand -group pos /drop_testbench/dut/cursor/left
add wave -noupdate -expand -group pos /drop_testbench/dut/cursor/right
add wave -noupdate -expand -group pos /drop_testbench/dut/cursor/confirm
add wave -noupdate -expand -group pos /drop_testbench/dut/cursor/leftPulse
add wave -noupdate -expand -group pos /drop_testbench/dut/cursor/rightPulse
add wave -noupdate -expand -group pos /drop_testbench/dut/cursor/confirmPulse
add wave -noupdate -expand -group pos /drop_testbench/dut/cursor/position
add wave -noupdate -expand -group pos /drop_testbench/dut/cursor/latchedPosition
add wave -noupdate -expand -group pos /drop_testbench/dut/cursor/confirmed
add wave -noupdate -expand -group userInput /drop_testbench/dut/cursor/player1/clk
add wave -noupdate -expand -group userInput /drop_testbench/dut/cursor/player1/reset
add wave -noupdate -expand -group userInput /drop_testbench/dut/cursor/player1/inSignal1
add wave -noupdate -expand -group userInput /drop_testbench/dut/cursor/player1/inSignal2
add wave -noupdate -expand -group userInput /drop_testbench/dut/cursor/player1/confirmSignal
add wave -noupdate -expand -group userInput /drop_testbench/dut/cursor/player1/outSignal1
add wave -noupdate -expand -group userInput /drop_testbench/dut/cursor/player1/outSignal2
add wave -noupdate -expand -group userInput /drop_testbench/dut/cursor/player1/outSignal3
add wave -noupdate -expand -group userInput /drop_testbench/dut/cursor/player1/dff1Q
add wave -noupdate -expand -group userInput /drop_testbench/dut/cursor/player1/dff2Q
add wave -noupdate -expand -group userInput /drop_testbench/dut/cursor/player1/dff3Q
add wave -noupdate -expand -group userInput /drop_testbench/dut/cursor/player1/dff4Q
add wave -noupdate -expand -group userInput /drop_testbench/dut/cursor/player1/dff1Q2
add wave -noupdate -expand -group userInput /drop_testbench/dut/cursor/player1/dff2Q2
add wave -noupdate -expand -group userInput /drop_testbench/dut/cursor/player1/inSignalFiltered1
add wave -noupdate -expand -group userInput /drop_testbench/dut/cursor/player1/confirmSignalFiltered
add wave -noupdate -expand -group userInput /drop_testbench/dut/cursor/player1/inSignalFiltered2
add wave -noupdate -expand -group userInput /drop_testbench/dut/cursor/player1/ps
add wave -noupdate -expand -group userInput /drop_testbench/dut/cursor/player1/ns
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1574 ps} 0}
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
