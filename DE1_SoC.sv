module DE1_SoC (
    HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, 
    KEY, SW, LEDR, GPIO_1, CLOCK_50
);
    output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    output logic [9:0]  LEDR;
    input  logic [3:0]  KEY;
    input  logic [9:0]  SW;
    output logic [35:0] GPIO_1;
    input logic CLOCK_50;

    // Turn off HEX displays.
    assign HEX0 = '1;
    assign HEX1 = '1;
    assign HEX2 = '1;
    assign HEX3 = '1;
    assign HEX4 = '1;
    assign HEX5 = '1;
    
    /* Set up system base clock to 1526 Hz (50 MHz / 2**(14+1)) */
    logic [31:0] div_clk;
    logic clk;
    clock_divider divider (
        .clock(CLOCK_50),
        .divided_clocks(div_clk)
    );


    `ifdef ALTERA_RESERVED_QIS
        assign clk = div_clk[14]; // for board
    `else
        assign clk = CLOCK_50; // for simulation
    `endif

    
    /* Declare LED board signals */
    logic [15:0][15:0] RedPixels; // 16x16 array for red LEDs
    logic [15:0][15:0] GrnPixels; // 16x16 array for green LEDs

    // Declare control signals that come from the board's buttons.
    logic RST, MOVELEFT, MOVERIGHT, CONFIRM;
    
    // Additional signals for the outputs of LED_test.
    logic [5:0][6:0] gameBoard0, gameBoard1;
    logic dropDone, weHaveAWinner;
    logic activePlayer;
    logic confirmPulse;
    logic [2:0] ledPositionOut;
    logic [5:0] ROWS;
    logic [15:0][15:0] curtainPattern;
    
    // Assign button signals (active low)
    assign RST       = ~KEY[0];
    assign MOVELEFT  = ~KEY[3];
    assign MOVERIGHT = ~KEY[2];
    assign CONFIRM   = ~KEY[1];
    
    /* Standard LED Driver instantiation - do not modify unless necessary */
    LEDDriver Driver (
        .CLK(clk), 
        .RST(RST), 
        .EnableCount(1'b1), 
        .RedPixels(RedPixels), 
        .GrnPixels(GrnPixels), 
        .GPIO_1(GPIO_1)
    );
    

    mainGame gameInstantiation(
        .clk(clk),
        .reset(RST),
        .left(MOVELEFT),
        .right(MOVERIGHT),
        .confirm(CONFIRM),
        .board0(gameBoard0),
        .board1(gameBoard1),
        .dropDone(dropDone),
        .currentPlayer(activePlayer),
        .weHaveAWinner(weHaveAWinner),
        .positionOut(ledPositionOut),
        .currRow(ROWS),
        .confirmPulse(confirmPulse)
    );

    fallingCurtain curtain (
        .clk(clk),
        .reset(reset),
        .curtainPattern(curtainPattern)
    );



    integer i, j;
    always_comb begin
        for (i = 0; i < 16; i++) begin
            for (j = 0; j < 16; j++) begin
                RedPixels[i][j] = 0;
                GrnPixels[i][j] = 0;
            end
        end
        

        for (i = 0; i < 6; i++) begin
            for (j = 0; j < 7; j++) begin 
                RedPixels[15 - i][9 + j] = gameBoard0[i][j];
                GrnPixels[15 - i][9 + j] = gameBoard1[i][j];
            end
        end
        

        if (!confirmPulse) begin
            if (activePlayer == 0)
                RedPixels[10][ledPositionOut + 9] = 1; // draw cursor for player 1
            else
                GrnPixels[10][ledPositionOut + 9] = 1; // draw cursor for player 2
        end
        
        if(weHaveAWinner) begin
            for (i = 0; i < 6; i++) begin
                for (j = 0; j < 15; j++) begin     
                    if(activePlayer == 0)
                        RedPixels[i][15 - j] = curtainPattern[i][j];
                    else
                        GrnPixels[i][15 - j] = curtainPattern[i][j];
                end
            end
        end
    end


endmodule




module DE1_SoC_testbench();
  logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  logic [9:0] LEDR;
  logic [3:0] KEY;
  logic [9:0] SW;
  logic [35:0] GPIO_1;
  logic CLOCK_50;
  logic clk;

  assign CLOCK_50 = clk;

  DE1_SoC dut (
    .HEX0(HEX0),
    .HEX1(HEX1),
    .HEX2(HEX2),
    .HEX3(HEX3),
    .HEX4(HEX4),
    .HEX5(HEX5),
    .LEDR(LEDR),
    .KEY(KEY),
    .SW(SW),
    .GPIO_1(GPIO_1),
    .CLOCK_50(CLOCK_50)
  );

  parameter CLOCK_PERIOD = 100;
  initial begin
    clk = 0;
    forever #(CLOCK_PERIOD/2) clk = ~clk;
  end

  initial begin
    KEY = 4'b1111; 

    KEY[0] = 0;
    @(posedge clk);
    KEY[0] = 1;    
    for (int i = 0; i < 100; i++) begin
      repeat (10) @(posedge clk);
    end

    @(posedge clk);

  
    KEY[1] = 0; 
    for (int i = 0; i < 100; i++) begin
      repeat (10) @(posedge clk);
    end
    KEY[1] = 1; 
    @(posedge clk);
    KEY[3] = 0;
    @(posedge clk);
    KEY[3] = 1;
    @(posedge clk);
    KEY[1] = 0; 
    @(posedge clk);
    KEY[1] = 1;
    for (int i = 0; i < 100; i++) begin
      repeat (10) @(posedge clk);
    end

    KEY[2] = 0;
    @(posedge clk);
    KEY[2] = 1;
    @(posedge clk);
    KEY[1] = 0;
    @(posedge clk);
    KEY[1] = 1;
    for (int i = 0; i < 100; i++) begin
      repeat (10) @(posedge clk);
    end

    KEY[3] = 0;
    @(posedge clk);
    KEY[3] = 1;
    @(posedge clk);
    KEY[1] = 0; 
    @(posedge clk);
    KEY[1] = 1;
    for (int i = 0; i < 100; i++) begin
      repeat (10) @(posedge clk);
    end   

    KEY[2] = 0;
    @(posedge clk);
    KEY[2] = 1;
    @(posedge clk);
    KEY[1] = 0;
    @(posedge clk);
    KEY[1] = 1;
    for (int i = 0; i < 100; i++) begin
      repeat (10) @(posedge clk);
    end

    KEY[3] = 0;
    @(posedge clk);
    KEY[3] = 1;
    @(posedge clk);
    KEY[1] = 0; 
    @(posedge clk);
    KEY[1] = 1;
    for (int i = 0; i < 100; i++) begin
      repeat (10) @(posedge clk);
    end 

    
    KEY[2] = 0;
    @(posedge clk);
    KEY[2] = 1;
    @(posedge clk);
    KEY[1] = 0;
    @(posedge clk);
    KEY[1] = 1;
    for (int i = 0; i < 100; i++) begin
      repeat (10) @(posedge clk);
    end


    KEY[0] = 0;
    @(posedge clk);
    KEY[0] = 1;

    repeat(20) @(posedge clk);


    KEY[1] = 0;
    @(posedge clk);
    KEY[1] = 1;
    for (int i = 0; i < 100; i++) begin
      repeat (10) @(posedge clk);
    end;



    KEY[3] = 0;
    repeat(20) @(posedge clk);
    KEY[3] = 1;

    KEY[3] = 0;
    repeat(20) @(posedge clk);
    KEY[3] = 1;

    KEY[3] = 0;
    repeat(20) @(posedge clk);
    KEY[3] = 1;

    KEY[3] = 0;
    repeat(20) @(posedge clk);
    KEY[3] = 1;


    KEY[1] = 0;
    @(posedge clk);
    KEY[1] = 1;
    for (int i = 0; i < 100; i++) begin
      repeat (10) @(posedge clk);
    end;



    $stop;
  end
endmodule
