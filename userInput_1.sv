module userInput(clk, reset, playerMoveLeft, playerMoveRight, playerMoveConfirm, columnPosition, coulumnSelect, confirmMove);

    input logic clk, reset;
    input logic playerMoveLeft, playerMoveRight, playerMoveConfirm;
    output logic [2:0] columnPosition;
    output logic [2:0] coulumnSelect;
    output logic confirmMove;

    enum {IDLE, MOVING, CONFIRM} ps, ns;

    //internal signals

    logic [2:0] columnPos; //the cursor

    //metastabilities 
    logic dffL1, dffL2;
    always_ff @(posedge clk) begin
        dffL1 <= playerMoveLeft;
        dffL2 <= dffL1;
    end

    logic dffR1, dffR2;
    always_ff @(posedge clk) begin
        dffR1 <= playerMoveRight;
        dffR2 <= dffR1;
    end

    logic dffC1, dffC2;
    always_ff @(posedge clk) begin
        dffC1 <= playerMoveConfirm;
        dffC2 <= dffC1;
    end

    always_ff @(posedge clk) begin
        if(reset) begin
            ps <= IDLE;
            columnPos <= 3'd0;
        end 
        else begin
            ps <= ns;

            if(ps == MOVING) begin 
                if()
    end


