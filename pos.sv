module pos (clk, reset, left, right, confirm, position, leftPulse, rightPulse, confirmPulse, latchedPosition);

    input logic clk, reset, left, right, confirm;
    
    output logic leftPulse, rightPulse, confirmPulse;
    output logic [2:0] latchedPosition;


    output logic [2:0] position;
    logic confirmed;

    
    userInput player1 (
        .clk(clk),
        .reset(reset),
        .inSignal1(left),
        .inSignal2(right),
        .confirmSignal(confirm),
        .outSignal1(leftPulse),
        .outSignal2(rightPulse),
        .outSignal3(confirmPulse)  
    );

    always_ff @(posedge clk) begin
        if (reset) begin
        position <= 0;
        latchedPosition <= 0;
        confirmed <= 0;
        end else begin

        if(leftPulse) begin
            if(position == 6)
                position <= 0;
            else
                position <= position + 1;
        end else if(rightPulse) begin
            if(position == 0)
                position <= 6;
            else 
                position <= position - 1;
        end

        if (confirmPulse) begin
            latchedPosition <= position;
            confirmed <= 1;
        end 
        else begin
            confirmed <= 0;
            end
        end
    end



endmodule


module pos_testbench();

    logic clk, reset;
    logic left, right, confirm;
    logic [6:0] position;


    pos dut (
        .clk(clk),
        .reset(reset),
        .left(left),
        .right(right),
        .confirm(confirm),
        .position(position)
    );

    parameter CLOCK_PERIOD = 100;
    initial begin
        clk = 0;
        forever #(CLOCK_PERIOD/2) clk = ~clk;
    end

    initial begin

        reset   = 1;
        left    = 0;
        right   = 0;
        confirm = 0;


        repeat(2) @(posedge clk);
        reset = 0;
        @(posedge clk);


        right = 1;
        @(posedge clk);
        right = 0;
        @(posedge clk);


        left = 1;
        @(posedge clk);
        left = 0;
        @(posedge clk);

        repeat(7) begin
            right = 1;
            @(posedge clk);
            right = 0;
            @(posedge clk);
        end


        confirm = 1;
        @(posedge clk);
        confirm = 0;
        @(posedge clk);

        right = 1;
        @(posedge clk);
        right = 0;
        @(posedge clk);

        $finish;
    end

endmodule
