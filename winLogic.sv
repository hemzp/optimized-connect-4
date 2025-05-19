module winLogic (clk, reset, board0, board1, currentPlayer, winEnable, weHaveAWinner, winMask);

    input logic clk, reset;
    input logic currentPlayer;
    input logic [5:0][6:0] board0;
    input logic [5:0][6:0] board1;
    input logic winEnable; //not inputted in testbench yet

    output logic weHaveAWinner;
    output logic [5:0][6:0] winMask;



    logic win;

    always_comb begin
        integer r,c;
        win = 0;

        winMask = '0;
        
        if(winEnable) begin
            if (currentPlayer == 0) begin
                for (r = 0; r < 6; r = r + 1) begin
                    for (c = 0; c < 7; c = c + 1) begin
                        if (board0[r][c]) begin

                            if (c <= 3) begin
                                if (board0[r][c+1] && board0[r][c+2] && board0[r][c+3]) begin
                                    win = 1;
                                    winMask[r][c]   = 1;
                                    winMask[r][c+1] = 1;
                                    winMask[r][c+2] = 1;
                                    winMask[r][c+3] = 1;
                                end
                            end

                            if (r <= 2) begin
                                if (board0[r+1][c] && board0[r+2][c] && board0[r+3][c]) begin
                                    win = 1;
                                    winMask[r][c]   = 1;
                                    winMask[r+1][c] = 1;
                                    winMask[r+2][c] = 1;
                                    winMask[r+3][c] = 1;
                                end
                            end

                            if ((r <= 2) && (c <= 3)) begin
                                if (board0[r+1][c+1] && board0[r+2][c+2] && board0[r+3][c+3]) begin
                                    win = 1;
                                    winMask[r][c]     = 1;
                                    winMask[r+1][c+1] = 1;
                                    winMask[r+2][c+2] = 1;
                                    winMask[r+3][c+3] = 1;
                                end
                            end

                            if ((r >= 3) && (c <= 3)) begin
                                if (board0[r-1][c+1] && board0[r-2][c+2] && board0[r-3][c+3]) begin
                                    win = 1;
                                    winMask[r][c]     = 1;
                                    winMask[r-1][c+1] = 1;
                                    winMask[r-2][c+2] = 1;
                                    winMask[r-3][c+3] = 1;
                                end
                            end
                        end
                    end
                end
            end else begin

                for (r = 0; r < 6; r = r + 1) begin
                    for (c = 0; c < 7; c = c + 1) begin
                        if (board1[r][c]) begin

                            if (c <= 3) begin
                                if (board1[r][c+1] && board1[r][c+2] && board1[r][c+3]) begin
                                    win = 1;
                                    winMask[r][c]   = 1;
                                    winMask[r][c+1] = 1;
                                    winMask[r][c+2] = 1;
                                    winMask[r][c+3] = 1;
                                end
                            end

                            if (r <= 2) begin
                                if (board1[r+1][c] && board1[r+2][c] && board1[r+3][c]) begin
                                    win = 1;
                                    winMask[r][c]   = 1;
                                    winMask[r+1][c] = 1;
                                    winMask[r+2][c] = 1;
                                    winMask[r+3][c] = 1;
                                end
                            end

                            if ((r <= 2) && (c <= 3)) begin
                                if (board1[r+1][c+1] && board1[r+2][c+2] && board1[r+3][c+3]) begin
                                    win = 1;
                                    winMask[r][c]     = 1;
                                    winMask[r+1][c+1] = 1;
                                    winMask[r+2][c+2] = 1;
                                    winMask[r+3][c+3] = 1;
                                end
                            end

                            if ((r >= 3) && (c <= 3)) begin
                                if (board1[r-1][c+1] && board1[r-2][c+2] && board1[r-3][c+3]) begin
                                    win = 1;
                                    winMask[r][c]     = 1;
                                    winMask[r-1][c+1] = 1;
                                    winMask[r-2][c+2] = 1;
                                    winMask[r-3][c+3] = 1;
                                end
                            end
                        end
                    end
                end
            end
        end
    end





    always_ff @(posedge clk) begin
        if (reset)
            weHaveAWinner <= 0;
        else
            weHaveAWinner <= win;
    end

endmodule

module winLogic_testbench();


  logic clk, reset, currentPlayer, winEnable;
  logic [5:0][6:0] board0, board1;
  logic weHaveAWinner;
  logic [5:0][6:0] winMask;


  winLogic dut (
    .clk(clk),
    .reset(reset),
    .currentPlayer(currentPlayer),
    .board0(board0),
    .board1(board1),
    .winEnable(winEnable),
    .weHaveAWinner(weHaveAWinner),
    .winMask(winMask)
  );


  parameter CLOCK_PERIOD = 10;
  initial begin
    clk = 0;
    forever #(CLOCK_PERIOD/2) clk = ~clk;
  end


  initial begin
    integer r, c;


    reset = 1;
    winEnable = 0;
    currentPlayer = 0;  
    for (r = 0; r < 6; r = r + 1)
      for (c = 0; c < 7; c = c + 1) begin
        board0[r][c] = 0;
        board1[r][c] = 0;
      end


    repeat(2) @(posedge clk);
    reset = 0;
    repeat(2) @(posedge clk);


    for (r = 0; r < 6; r = r + 1)
      for (c = 0; c < 7; c = c + 1)
        board0[r][c] = 0;
        board0[2][1] = 1;
        board0[2][2] = 1;
        board0[2][3] = 1;
        board0[2][4] = 1;

    winEnable = 1;
    @(posedge clk); 

    repeat(10) @(posedge clk);

    // Reset after Test 1
    reset = 1;
    repeat(2) @(posedge clk);
    reset = 0;
    repeat(2) @(posedge clk);


    for (r = 0; r < 6; r = r + 1)
      for (c = 0; c < 7; c = c + 1)
        board0[r][c] = 0;
        board0[0][3] = 1;
        board0[1][3] = 1;
        board0[2][3] = 1;
        board0[3][3] = 1;

    winEnable = 1;
    @(posedge clk);


    repeat(10) @(posedge clk);

    // Reset after Test 2
    reset = 1;
    repeat(2) @(posedge clk);
    reset = 0;
    repeat(2) @(posedge clk);


    for (r = 0; r < 6; r = r + 1)
      for (c = 0; c < 7; c = c + 1)
        board0[r][c] = 0;
        board0[0][0] = 1;
        board0[1][1] = 1;
        board0[2][2] = 1;
        board0[3][3] = 1;

    winEnable = 1;
    @(posedge clk); 


    repeat(10) @(posedge clk);


    reset = 1;
    repeat(2) @(posedge clk);
    reset = 0;
    repeat(2) @(posedge clk);

    $finish;
  end

endmodule

