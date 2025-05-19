module boardDisplay(clk, reset, currentPlayer, confirmPulse, ledPosition, board0, board1, dropDone);

    input logic clk, reset;
    input logic currentPlayer, confirmPulse;
    input logic [6:0] ledPosition;

    output logic dropDone;
    output logic [5:0][6:0] board0;
    output logic [5:0][6:0] board1;



    logic dropEnable;
    logic [2:0] currentRow;  
    logic [2:0] targetRow;   


    logic [2:0] computedTarget;


    computeDrop computeDrop_inst (
        .board0(board0),
        .board1(board1),
        .ledPosition(ledPosition),
        .computedTarget(computedTarget)
    );

        enum {waiting, dropping} ps, ns;

    always_comb begin 
        case (ps)
            waiting: begin
                if (confirmPulse)
                    ns = dropping;
                else
                    ns = waiting;
            end

            dropping: begin 
                if (dropEnable && ~dropDone)
                    ns = dropping;
                else
                    ns = waiting;
            end
            
            default: ns = waiting;
        endcase
    end


    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            ps <= waiting;
        else
            ps <= ns;
    end


    always_ff @(posedge clk) begin
        if (reset) begin
            integer i, j;
            for(i = 0; i < 6; i++) begin
                for(j = 0; j < 7; j++) begin
                    board0[i][j] <= 0;
                    board1[i][j] <= 0;
                end
            end
            
            dropEnable <= 0;
            dropDone <= 0;
            currentRow <= 0;
        end else begin
            case (ps)
                waiting: begin
                    if (confirmPulse) begin
                        targetRow <= computedTarget;
                        dropEnable <= 1;
                        dropDone <= 0;
                        if (computedTarget != 3'd7)
                            currentRow <= 3'd5;
                        else if (currentPlayer == 0)
                            board0[0][ledPosition] <= 1;
                        else
                            board1[0][ledPosition] <= 1;
                    end
                end
                dropping: begin
                    if (dropEnable) begin
                        if (currentRow < targetRow) begin

                            logic [2:0] nextRow;
                            nextRow = currentRow + 1;


                            if (currentPlayer == 0) begin
                                board0[currentRow][ledPosition] <= 0;
                                board0[nextRow][ledPosition]   <= 1;
                            end
                            else begin
                                board1[currentRow][ledPosition] <= 0;
                                board1[nextRow][ledPosition]   <= 1;
                            end


                            currentRow <= nextRow;
                        end
                        else if (currentRow == targetRow) begin

                            if (currentPlayer == 0)
                                board0[currentRow][ledPosition] <= 1;
                            else
                                board1[currentRow][ledPosition] <= 1;
                            dropDone   <= 1;
                            dropEnable <= 0;
                        end
                    end
                end
                default: ;
            endcase
        end
    end
endmodule


module boardDisplay_testbench();
    logic clk, reset;
    logic currentPlayer, confirmPulse;
    logic [6:0] ledPosition;
    logic dropDone;
    logic [5:0][6:0] board0;
    logic [5:0][6:0] board1;

    parameter CLOCK_PERIOD = 100;
    
    initial begin
        clk = 0;
        forever #(CLOCK_PERIOD/2) clk = ~clk;
    end

    boardDisplay dut (
        .clk(clk),
        .reset(reset),
        .currentPlayer(currentPlayer),
        .confirmPulse(confirmPulse),
        .ledPosition(ledPosition),
        .board0(board0),
        .board1(board1),
        .dropDone(dropDone)
    );

    integer i;
    initial begin
        reset = 1;
        currentPlayer = 0;
        confirmPulse = 0;
        ledPosition = 7'd3;

        repeat(2) @(posedge clk);
        reset = 0;
        @(posedge clk);

        confirmPulse = 1;
        @(posedge clk);
        confirmPulse = 0;
        
        wait(dropDone == 1);

        currentPlayer = 1;
        @(posedge clk);
        confirmPulse = 1;
        @(posedge clk);
        confirmPulse = 0;
        
        wait(dropDone == 1);

        $stop;
    end
endmodule

