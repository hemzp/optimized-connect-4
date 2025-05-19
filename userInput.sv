module userInput(clk, reset, inSignal1, inSignal2, confirmSignal, outSignal1, outSignal2, outSignal3);


    input logic clk;
    input logic reset;
    input logic inSignal1, inSignal2, confirmSignal;
    output logic outSignal1, outSignal2, outSignal3;

    

    logic dff1Q, dff2Q, dff3Q, dff4Q;
    logic dff1Q2, dff2Q2;
	logic inSignalFiltered1, confirmSignalFiltered;
    logic inSignalFiltered2;


    enum  {idle, pulsed} ps, ns;

    always_ff @(posedge clk) begin
        if (reset)
            ps <= idle;
        else
            ps <= ns;
    end

    //Metastability for left 
    always_ff @(posedge clk) begin
        dff1Q <= inSignal1;
        dff2Q <= dff1Q;
    end

    assign inSignalFiltered1 = dff2Q;
    //Metastability for right 
    always_ff @(posedge clk) begin
        dff1Q2 <= inSignal2;
        dff2Q2 <= dff1Q2;
    end

    assign inSignalFiltered2 = dff2Q2;

    //Metastability for confirm
    always_ff @(posedge clk) begin
        dff3Q <= confirmSignal;
        dff4Q <= dff3Q;
    end

    assign confirmSignalFiltered = dff4Q;

    always_comb begin 
        ns = ps;
        outSignal1 = 0;
        outSignal2 = 0;
        outSignal3 = 0;

        case (ps)
            idle: begin 
                if (inSignalFiltered1 && !inSignalFiltered2 && !confirmSignalFiltered) begin 
                    outSignal1 = 1;
                    ns = pulsed;
                end
                else if (!inSignalFiltered1 && inSignalFiltered2 && !confirmSignalFiltered) begin 
                    outSignal2 = 1;
                    ns = pulsed;
                end
                else if (confirmSignalFiltered) begin 
                    outSignal3 = 1;
                    ns = pulsed;
                end

                else begin
                    ns = idle;
                end
            end

            pulsed: begin
                if(!inSignalFiltered1 && !inSignalFiltered2 && !confirmSignalFiltered) begin 
                    ns = idle;
                end
                else
                    ns = pulsed;
            end

            default: begin 
                ns = idle;
            end
            
        endcase
    end
endmodule


module userInput_testbench();
    logic clk, reset;
    logic inSignal1, inSignal2, confirmSignal;
    logic outSignal1, outSignal2, outSignal3;


    userInput dut (
        .clk(clk),
        .reset(reset),
        .inSignal1(inSignal1),
        .inSignal2(inSignal2),
        .confirmSignal(confirmSignal),
        .outSignal1(outSignal1),
        .outSignal2(outSignal2),
        .outSignal3(outSignal3)
    );

    parameter CLOCK_PERIOD = 100;

    initial begin
        clk = 0;
        forever #(CLOCK_PERIOD/2) clk = ~clk;
    end


    initial begin

        reset = 1;
        inSignal1 = 0;
        inSignal2 = 0;
        confirmSignal = 0;

        repeat (2) @(posedge clk);
        reset = 0;

        @(posedge clk);
        inSignal1 = 1;
        @(posedge clk);
        inSignal1 = 0;

        repeat (2) @(posedge clk);
        @(posedge clk);
        confirmSignal = 1;
        @(posedge clk);
        confirmSignal = 0;


        repeat (2) @(posedge clk);
        @(posedge clk);
        inSignal2 = 1;
        @(posedge clk);
        inSignal2 = 0;
        repeat (2) @(posedge clk);
        @(posedge clk);
        confirmSignal = 1;
        @(posedge clk);
        confirmSignal = 0;


        repeat (2) @(posedge clk);
        @(posedge clk);
        inSignal1 = 1;
        inSignal2 = 1;
        @(posedge clk);
        inSignal1 = 0;
        inSignal2 = 0;

        repeat (2) @(posedge clk);

        @(posedge clk);
        inSignal1 = 1;
        @(posedge clk);
        inSignal1 = 0;

        @(posedge clk);
        inSignal2 = 1;
        @(posedge clk);
        inSignal2 = 0;

        @(posedge clk);
        confirmSignal = 1;
        @(posedge clk);
        confirmSignal = 0;


        repeat (5) @(posedge clk);
        $finish;
    end
endmodule
