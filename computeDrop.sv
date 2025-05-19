module computeDrop(board0, board1, ledPosition, computedTarget);
    input logic [5:0][6:0] board0;
    input logic [5:0][6:0] board1;
    input logic [6:0] ledPosition;

    output logic [2:0] computedTarget;

    always_comb begin
        computedTarget = 3'd7; 
        if ((board0[5][ledPosition] == 0) && (board1[5][ledPosition] == 0))
            computedTarget = 3'd5;
        else if ((board0[4][ledPosition] == 0) && (board1[4][ledPosition] == 0))
            computedTarget = 3'd4;
        else if ((board0[3][ledPosition] == 0) && (board1[3][ledPosition] == 0))
            computedTarget = 3'd3;
        else if ((board0[2][ledPosition] == 0) && (board1[2][ledPosition] == 0))
            computedTarget = 3'd2;
        else if ((board0[1][ledPosition] == 0) && (board1[1][ledPosition] == 0))
            computedTarget = 3'd1;
        else if ((board0[0][ledPosition] == 0) && (board1[0][ledPosition] == 0))
            computedTarget = 3'd0;
    end
endmodule


module computeDrop_testbench();

    logic [5:0][6:0] board0;
    logic [5:0][6:0] board1;
    logic [6:0]      ledPosition;
    logic [2:0]      computedTarget;
    logic            clk;

    parameter CLOCK_PERIOD = 100;
    initial begin
        clk = 0;
        forever #(CLOCK_PERIOD/2) clk = ~clk;
    end


    computeDrop dut (
        .board0(board0),
        .board1(board1),
        .ledPosition(ledPosition),
        .computedTarget(computedTarget)
    );

    integer i, j;
    initial begin

        for(i = 0; i < 6; i = i + 1)
            for(j = 0; j < 7; j = j + 1) begin
                board0[i][j] = 0;
                board1[i][j] = 0;
            end


        ledPosition = 7'd3;  
        @(posedge clk);


        board0[5][3] = 1;
        @(posedge clk);



        board1[5][3] = 1;
        @(posedge clk);

        board0[4][3] = 1;
        board1[4][3] = 1;
        @(posedge clk);



        board0[3][3] = 1;
        board1[3][3] = 1;
        @(posedge clk);



        board0[2][3] = 1;
        board1[2][3] = 1;
        @(posedge clk);



        board0[1][3] = 1;
        board1[1][3] = 1;
        @(posedge clk);



        board0[0][3] = 1;
        board1[0][3] = 1;
        @(posedge clk);


        $stop;
    end
endmodule


