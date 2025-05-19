module dropMain(clk, reset, left, right, confirm, currentPlayer, dropDone, board0, board1);

    input logic clk, reset;
    input logic left, right, confirm;
    input logic currentPlayer;

    output logic dropDone;
    output logic  [5:0][6:0] board0;
    output logic  [5:0][6:0] board1;
    

    logic [6:0] ledPosition;
    logic leftPulse, rightPulse, confirmPulse;

    pos cursor (
        .clk(clk),
        .reset(reset),
        .left(left),
        .right(right),
        .confirm(confirm),
        .ledPosition(ledPosition),
        .leftPulse(leftPulse),
        .rightPulse(rightPulse),
        .confirmPulse(confirmPulse)
    );

    boardDisplay DUU (
        .clk(clk),
        .reset(reset),
        .confirmPulse(confirmPulse),
        .currentPlayer(currentPlayer),
        .ledPosition(ledPosition),
        .dropDone(dropDone),
        .board0(board0),
        .board1(board1)
    );

endmodule



module dropMain_testbench();
    logic clk, reset;
    logic left, right, confirm;
    logic currentPlayer;
    logic dropDone;
    logic [5:0][6:0] board0;
    logic [5:0][6:0] board1;

    parameter CLOCK_PERIOD = 100;

    initial begin
        clk = 0;
        forever #(CLOCK_PERIOD/2) clk = ~clk;
    end

    dropMain dut (
        .clk(clk),
        .reset(reset),
        .left(left),
        .right(right),
        .confirm(confirm),
        .currentPlayer(currentPlayer),
        .dropDone(dropDone),
        .board0(board0),
        .board1(board1)
    );

    integer i;
    initial begin
        reset = 1;
        left = 0;
        right = 0;
        confirm = 0;
        currentPlayer = 0;

        repeat(2) @(posedge clk);
        reset = 0;
        @(posedge clk);

        confirm = 1;
        @(posedge clk);
        confirm = 0;
        wait(dropDone == 1);

        #20;
        currentPlayer = 1;
        @(posedge clk);
        confirm = 1;
        @(posedge clk);
        confirm = 0;
        wait(dropDone == 1);

        $stop;
    end
endmodule
