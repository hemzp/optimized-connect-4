module LED_test(RST, RedPixels, GrnPixels, clk, MOVELEFT, MOVERIGHT, CONFIRM, board0, board1, positionMain, activePlayer, winEnable);
    input logic               RST;
    input logic MOVELEFT, MOVERIGHT, CONFIRM, clk;

    output logic [5:0] [6:0] board0, board1;
    output logic [15:0][15:0] RedPixels; // 16x16 array of red LEDs
    output logic [15:0][15:0] GrnPixels; // 16x16 array of green LEDs
    output logic [2:0] positionMain;
	output logic activePlayer, winEnable;

    logic dropDoneInsts, weHaveAWinnerInsts;

    mainGame gameInstantiation(
        .clk(clk),
        .reset(RST),
        .left(MOVELEFT),
        .right(MOVERIGHT),
        .confirm(CONFIRM),
        .board0(board0),
        .board1(board1),
        .dropDone(dropDoneInsts),
        .weHaveAWinner(weHaveAWinnerInsts),
        .positionOut(positionMain),
        .currentPlayer(activePlayer)
    );

    assign winEnable = dropDoneInsts;

    assign activePlayer = 1'b0;

    always_comb begin : LED_display
        integer i, r, c;
        if (RST) begin
            // When reset is active, keep LEDs off.
                    // Clear both LED matrices.
            for (i = 0; i < 16; i++) begin
                RedPixels[i] = 16'd0;
                GrnPixels[i] = 16'd0;
            end
        end else begin
            // Map Player 1 tokens (board0) into the red LED array.
            // For instance, place the 6×7 board starting at row 10.
            for (r = 0; r < 6; r++) begin
                for (c = 0; c < 7; c++) begin
                    if (board0[r][c] == 1)
                        RedPixels[r + 10][15 - c] = 1'b1;
                end
            end

            // Map Player 2 tokens (board1) into the green LED array.
            for (r = 0; r < 6; r++) begin
                for (c = 0; c < 7; c++) begin
                    if (board1[r][c] == 1)
                        GrnPixels[r + 10][15 - c] = 1'b1;
                end
            end

            // Draw a cursor indicator.
            // Here we light one red LED (for example, row 9) at the column given by ledPositionOut.
            RedPixels[9][15 - positionMain] = 1'b1;
        end
    end


endmodule


module LED_testbench();

    // Signal declarations
    logic RST;
    logic MOVELEFT, MOVERIGHT, CONFIRM, clk;
    logic [5:0][6:0] board0, board1;
    logic [15:0][15:0] RedPixels, GrnPixels;
    logic [2:0] positionMain;
    logic activePlayer, winEnable;

    // Clock period parameter (in time units)
    parameter CLOCK_PERIOD = 100;

    // Clock generation
    initial begin
        clk = 0;
        forever #(CLOCK_PERIOD/2) clk = ~clk;
    end

    // Instantiate the LED_test module
    LED_test uut (
        .RST(RST),
        .RedPixels(RedPixels),
        .GrnPixels(GrnPixels),
        .clk(clk),
        .MOVELEFT(MOVELEFT),
        .MOVERIGHT(MOVERIGHT),
        .CONFIRM(CONFIRM),
        .board0(board0),
        .board1(board1),
        .positionMain(positionMain),
        .activePlayer(activePlayer),
        .winEnable(winEnable)
    );

    // Test sequence to simulate a full game
    initial begin
        // Initialize inputs and assert reset
        RST = 1;
        MOVELEFT = 0;
        MOVERIGHT = 0;
        CONFIRM = 0;
        
        // Hold reset for 20 cycles then release
        repeat (20) @(posedge clk);
        RST = 0;
        repeat (20) @(posedge clk);
        
        // --- Move 1: Player 0 ---
        // Drop token at current position (assumed default column)
        @(posedge clk);
        CONFIRM = 1;
        @(posedge clk);
        CONFIRM = 0;
        // Allow time for drop FSM to process
        repeat (20) @(posedge clk);
        
        // --- Move 2: Simulate move for Player 1 ---
        // From starting position (assumed at col0), move right 6 times to reach col6.
        for (int i = 0; i < 6; i++) begin
            @(posedge clk);
            MOVERIGHT = 1;
            @(posedge clk);
            MOVERIGHT = 0;
            repeat (20) @(posedge clk);
        end
        @(posedge clk);
        CONFIRM = 1;
        @(posedge clk);
        CONFIRM = 0;
        repeat (20) @(posedge clk);
        
        // --- Move 3: Player 0 ---
        // From current position (assumed col6), move left 5 times to reach col1.
        for (int i = 0; i < 5; i++) begin
            @(posedge clk);
            MOVELEFT = 1;
            @(posedge clk);
            MOVELEFT = 0;
            repeat (20) @(posedge clk);
        end
        @(posedge clk);
        CONFIRM = 1;
        @(posedge clk);
        CONFIRM = 0;
        repeat (20) @(posedge clk);
        
        // --- Move 4: Simulate move for Player 1 ---
        // From current position (assumed col1), move right 5 times to reach col6 again.
        for (int i = 0; i < 5; i++) begin
            @(posedge clk);
            MOVERIGHT = 1;
            @(posedge clk);
            MOVERIGHT = 0;
            repeat (20) @(posedge clk);
        end
        @(posedge clk);
        CONFIRM = 1;
        @(posedge clk);
        CONFIRM = 0;
        repeat (20) @(posedge clk);
        
        // --- Move 5: Player 0 ---
        // Drop token at the current position (no horizontal move)
        @(posedge clk);
        CONFIRM = 1;
        @(posedge clk);
        CONFIRM = 0;
        repeat (20) @(posedge clk);
        
        // Additional moves can be added here to further exercise the game logic.
        // For example, you can add moves that move left/right and drop tokens to test win detection.
        
        // Wait some cycles to observe the final LED outputs and winEnable signal
        repeat (20) @(posedge clk);
        $stop;
    end

endmodule
