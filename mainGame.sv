module mainGame(clk, reset, left, right, confirm, board0, board1, dropDone, weHaveAWinner, positionOut, currentPlayer, currRow, confirmPulse);
    input logic clk, reset;
    input logic left, right, confirm;
    output logic [5:0][6:0] board0, board1;
    output logic dropDone, weHaveAWinner;
    output logic [2:0] positionOut;


    logic winEnable;
    logic leftPulse, rightPulse;
    logic gated_left, gated_right, gated_confirm;
    output logic confirmPulse;
    output logic [5:0] currRow;
    output logic currentPlayer;


    logic [5:0][6:0] raw_board0, raw_board1;

    assign winEnable = dropDone; 


    parameter BLINK_MAX = 1525;  
    logic [10:0] blinkCounter;
    logic blink;


    enum logic [2:0] { 
        IDLE, 
        PIECE_SELECTION, 
        PIECE_DROP, 
        WIN_CHECK, 
        NEXT_PLAYER,
        GAME_OVER
    } ps, ns;
    

    always_ff @(posedge clk) begin
        if (reset)
            blinkCounter <= 0;
        else if (blinkCounter == BLINK_MAX - 1)
            blinkCounter <= 0;
        else
            blinkCounter <= blinkCounter + 1;
    end
    

    always_comb begin
        if (blinkCounter < BLINK_MAX/2)
            blink = 1;
        else
            blink = 0;
    end


    logic [5:0][6:0] winMask_internal;

    always_comb begin
        if (ps == GAME_OVER) begin
            gated_left = 1'b0;
            gated_right = 1'b0;
            gated_confirm = 1'b0;
        end else begin
            gated_left = left;
            gated_right = right;
            gated_confirm = confirm;
        end
    end


    drop DUU1(
        .clk(clk),
        .reset(reset),
        .left(gated_left),
        .right(gated_right),
        .confirm(gated_confirm),
        .currentPlayer(currentPlayer),
        .dropDone(dropDone),
        .board0(raw_board0),
        .board1(raw_board1),
        .leftPulse(leftPulse),
        .rightPulse(rightPulse),
        .confirmPulse(confirmPulse),
        .position(positionOut),
        .currentRow(currRow)
    );


    winLogic DUU2(
        .clk(clk),
        .reset(reset),
        .currentPlayer(currentPlayer),
        .winEnable(winEnable),
        .weHaveAWinner(weHaveAWinner),
        .board0(raw_board0),
        .board1(raw_board1),
        .winMask(winMask_internal)  
    );


    // Sequential state update
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            ps <= IDLE;
        else
            ps <= ns;
    end


    always_comb begin
        case (ps)
            IDLE: begin 
                if (leftPulse || rightPulse)
                    ns = PIECE_SELECTION;
                else if (confirmPulse)
                    ns = PIECE_DROP;
                else
                    ns = IDLE;
            end

            PIECE_SELECTION: begin

                if (!confirmPulse)
                    ns = PIECE_SELECTION;
                else
                    ns = PIECE_DROP;
            end

            PIECE_DROP: begin

                if (dropDone)
                    ns = WIN_CHECK;
                else
                    ns = PIECE_DROP;
            end

            WIN_CHECK: begin

                if (!weHaveAWinner)
                    ns = NEXT_PLAYER;
                else
                    ns = GAME_OVER;
            end

            NEXT_PLAYER: begin
                ns = PIECE_SELECTION;
            end

            GAME_OVER: begin
                if(reset)
                    ns = IDLE;
                else
                    ns = GAME_OVER;
            end

            default: ns = IDLE;
        endcase
    end


    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            currentPlayer <= 0;
        else if (ps == NEXT_PLAYER)
            currentPlayer <= ~currentPlayer;
    end







    logic [5:0][6:0] board0_final, board1_final;

    integer r, c;
    
    always_comb begin
        for (r = 0; r < 6; r = r + 1) begin
            for (c = 0; c < 7; c = c + 1) begin
                board0_final[r][c] = raw_board0[r][c];
                board1_final[r][c] = raw_board1[r][c];
            end
        end
        if ((ps == GAME_OVER) && weHaveAWinner) begin
            if (currentPlayer == 0) begin
                for (r = 0; r < 6; r = r + 1) begin
                    for (c = 0; c < 7; c = c + 1) begin
                        if (winMask_internal[r][c] == 1) begin
                            if (blink == 1)
                                board0_final[r][c] = raw_board0[r][c];
                            else
                                board0_final[r][c] = 0;
                        end
                    end
                end
            end else begin

                for (r = 0; r < 6; r = r + 1) begin
                    for (c = 0; c < 7; c = c + 1) begin
                        if (winMask_internal[r][c] == 1) begin
                            if (blink == 1)
                                board1_final[r][c] = raw_board1[r][c];
                            else
                                board1_final[r][c] = 0;
                        end
                    end
                end
            end
        end
    end

    assign board0 = board0_final;
    assign board1 = board1_final;

endmodule


module mainGame_testbench();


    logic clk;
    logic reset;
    logic left;
    logic right;
    logic confirm;
    logic currentPlayer;
    logic [5:0][6:0] board0, board1;
    logic dropDone, weHaveAWinner;
    logic [2:0] positionOut;
    logic [5:0] currRow;

    parameter CLOCK_PERIOD = 100;

    initial begin
        clk = 0;
        forever #(CLOCK_PERIOD/2) clk = ~clk;
    end


    mainGame dut (
        .clk(clk),
        .reset(reset),
        .left(left),
        .right(right),
        .confirm(confirm),
        .board0(board0),
        .board1(board1),
        .dropDone(dropDone),
        .weHaveAWinner(weHaveAWinner),
        .positionOut(positionOut),
        .currentPlayer(currentPlayer),
        .currRow(currRow),
        .confirmPulse(confirmPulse)
    );


    initial begin

        reset = 1;
        left  = 0;
        right = 0;
        confirm = 0;
        
   
        repeat (20) @(posedge clk);
        reset = 0;
        repeat (20) @(posedge clk);
        

        @(posedge clk);
        confirm = 1;
        @(posedge clk);
        confirm = 0;
        wait (dropDone == 1);
        repeat (20) @(posedge clk);
        

        for (int i = 0; i < 6; i++) begin
            @(posedge clk);
            right = 1;
            @(posedge clk);
            right = 0;
            repeat (20) @(posedge clk);
        end
        @(posedge clk);
        confirm = 1;
        @(posedge clk);
        confirm = 0;
        wait (dropDone == 1);
        repeat (20) @(posedge clk);
        

        for (int i = 0; i < 5; i++) begin
            @(posedge clk);
            left = 1;
            @(posedge clk);
            left = 0;
            repeat (20) @(posedge clk);
        end
        @(posedge clk);
        confirm = 1;
        @(posedge clk);
        confirm = 0;
        wait (dropDone == 1);
        repeat (20) @(posedge clk);
        

        for (int i = 0; i < 5; i++) begin
            @(posedge clk);
            right = 1;
            @(posedge clk);
            right = 0;
            repeat (20) @(posedge clk);
        end
        @(posedge clk);
        confirm = 1;
        @(posedge clk);
        confirm = 0;
        wait (dropDone == 1);
        repeat (20) @(posedge clk);
        

        for (int i = 0; i < 4; i++) begin
            @(posedge clk);
            left = 1;
            @(posedge clk);
            left = 0;
            repeat (20) @(posedge clk);
        end
        @(posedge clk);
        confirm = 1;
        @(posedge clk);
        confirm = 0;
        wait (dropDone == 1);
        repeat (20) @(posedge clk);

        for (int i = 0; i < 4; i++) begin
            @(posedge clk);
            right = 1;
            @(posedge clk);
            right = 0;
            repeat (20) @(posedge clk);
        end
        @(posedge clk);
        confirm = 1;
        @(posedge clk);
        confirm = 0;
        wait (dropDone == 1);
        repeat (20) @(posedge clk);

        for (int i = 0; i < 3; i++) begin
            @(posedge clk);
            left = 1;
            @(posedge clk);
            left = 0;
            repeat (20) @(posedge clk);
        end
        @(posedge clk);
        confirm = 1;
        @(posedge clk);
        confirm = 0;
        wait (dropDone == 1);
        repeat (20) @(posedge clk);

        repeat (20) @(posedge clk);
        $stop;
    end

endmodule







