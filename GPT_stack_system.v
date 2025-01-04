module top_module ();
    reg clk = 0; // Clock signal
    always #5 clk = ~clk; // Create clock with period=10

    initial `probe_start; // Start the timing diagram

    `probe(clk); // Probe clock signal

    // Testbench signals
    reg [11:0] Pcx;
    reg Push, Pop;
    wire [11:0] stk0;

    // Instantiate StackSystem
    StackSystem uut (
        .Pcx(Pcx),
        .Clk(clk),
        .Push(Push),
        .Pop(Pop),
        .stk0(stk0)
    );

    initial begin
        // Initialize signals
        Pcx = 12'b0;
        Push = 0;
        Pop = 0;

        // Test sequence
        #10 Pcx = 12'hA; Push = 1; Pop = 0; // Push A
        #10 Push = 0;                      // Disable push
        #10 Pcx = 12'hB; Push = 1;         // Push B
        #10 Push = 0;                      // Disable push
        #10 Pcx = 12'hC; Push = 1;         // Push C
        #10 Push = 0;                      // Disable push
        #10 Pcx = 12'hD; Push = 1;         // Push D
        #10 Push = 0;                      // Disable push

        #20 Pop = 1; Push = 0; // Pop to access Q2
        #10 Pop = 0;           // Disable pop
        #10 Pop = 1;           // Pop to access Q1
        #10 Pop = 0;           // Disable pop
        #10 Pop = 1;           // Pop to access Q0
        #10 Pop = 0;           // Disable pop
        
        $display ("Simulation complete at time = %0d ps", $time);
        #50 $finish; // End simulation
    end
endmodule

module StackSystem (
    input [11:0] Pcx,     // Data input
    input Clk,            // Clock
    input Push,           // Push enable
    input Pop,            // Pop enable
    output reg [11:0] stk0 // Stack output
);
    reg [11:0] Q0, Q1, Q2, Q3; // Stack registers
    reg [1:0] Sp;             // Stack pointer (2 bits to select 4 slots)

    always @(posedge Clk) begin
        if (Push) begin
            case (Sp)
                2'b00: Q0 <= Pcx;
                2'b01: Q1 <= Pcx;
                2'b10: Q2 <= Pcx;
                2'b11: Q3 <= Pcx;
            endcase
            Sp <= Sp - 1; // Update stack pointer on push
        end
        else if (Pop) begin
            Sp <= Sp + 1; // Update stack pointer on pop
        end
    end

    // Multiplexer for stack output
    always @(*) begin
        case (Sp)
            2'b00: stk0 = Q0;
            2'b01: stk0 = Q1;
            2'b10: stk0 = Q2;
            2'b11: stk0 = Q3;
        endcase
    end

    `probe(Pcx);   // Probe input data
    `probe(Clk);   // Probe clock
    `probe(Push);  // Probe push signal
    `probe(Pop);   // Probe pop signal
    `probe(stk0);  // Probe stack output
    `probe(Sp);    // Probe stack pointer
    `probe(Q0);    // Probe stack register Q0
    `probe(Q1);    // Probe stack register Q1
    `probe(Q2);    // Probe stack register Q2
    `probe(Q3);    // Probe stack register Q3
endmodule