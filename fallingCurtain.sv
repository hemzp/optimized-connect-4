module fallingCurtain(clk, reset, curtainPattern);

    input logic clk, reset;
    output logic [15:0][15:0] curtainPattern;


    parameter UPDATE_MAX = 300;
    logic [9:0] updateCounter;
    logic updateTick;
    logic [15:0][15:0] colReg;

    logic [6:0] lfsr;

    logic xNOR;

    assign xNOR = ~(lfsr[1] ^ lfsr[0]);

    always_ff @(posedge clk) begin
        if(reset)
            lfsr <= 7'd4;
        else begin
            lfsr[6] <= xNOR;
            lfsr[5:0] <= lfsr[6:1];
        end
    end

    always_ff @(posedge clk) begin
        if (reset)
            updateCounter <= 0;
        else if (updateCounter == UPDATE_MAX - 1)
            updateCounter <= 0;
        else
            updateCounter <= updateCounter + 1;
    end
    assign updateTick = (updateCounter == UPDATE_MAX - 1);

    integer row, col;
    always_ff @(posedge clk) begin 
        if(reset) begin
            for(col = 0; col < 16; col++)
                colReg[col] <= 16'd0;
        end else if (updateTick) begin
            for(col = 0; col < 16; col++) begin
                if((lfsr < 100) && (lfsr[0] == 1))
                    colReg[col][15] <= 1;
                else
                    colReg[col][15] <= 0;
                    colReg[col][14:0] <= colReg[col][15:1];
            end
        end
    end

    always_comb begin
        integer row, col;
        for (row = 0; row < 16; row++) begin
            for (col = 0; col < 16; col++) begin
                curtainPattern[row][15 - col] = colReg[col][15 - row];
            end
        end
    end    
endmodule


module fallingPattern_testbench();

  logic clk;
  logic reset;
  logic [15:0][15:0] curtainPattern;


  fallingCurtain dut (
    .clk(clk),
    .reset(reset),
    .curtainPattern(curtainPattern)
  );

  parameter CLK_PERIOD = 10;
  initial begin
    clk = 0;
    forever #(CLK_PERIOD/2) clk = ~clk;
  end


  initial begin

    reset <= 1;

    repeat(5) @(posedge clk);  
    reset <= 0;


    repeat(10000) @(posedge clk);   //need to give a lot of cycles to start seeing random beaviour in TB in hardware it works.
    $stop;
  end

endmodule
