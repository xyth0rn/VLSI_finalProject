module ProgramCounter2 (
    input [11:0] Pcounter, // Current PC address input
    input [11:0] A1,       // Jump address input
    input Jump,            // Jump enable signal
    output reg [11:0] PCadd // Program counter output
);
    always @(*) begin
        if (Jump)
            PCadd = Pcounter + A1; // Jump to new address
        else
            PCadd = Pcounter + 1;  // Increment PC by 1
    end

    `probe(Pcounter); // Probe current PC address input
    `probe(A1);       // Probe jump address input
    `probe(Jump);     // Probe jump enable signal
    `probe(PCadd);    // Probe PC output
endmodule


module top_module ();
    reg [11:0] Pcounter; // Current PC address input
    reg [11:0] A1;       // Jump address input
    reg Jump;            // Jump enable signal
    wire [11:0] PCadd;   // Program counter output

    // Instantiate ProgramCounter2
    ProgramCounter2 uut (
        .Pcounter(Pcounter),
        .A1(A1),
        .Jump(Jump),
        .PCadd(PCadd)
    );

    reg clk = 0;
    always #5 clk = ~clk; // Generate clock with period = 10

    initial `probe_start; // Start the timing diagram

    `probe(clk);        // Probe clock signal
    `probe(Pcounter);   // Probe PC input
    `probe(A1);         // Probe jump address
    `probe(Jump);       // Probe jump signal
    `probe(PCadd);      // Probe PC output

    initial begin
        // Initialize signals
        Pcounter = 12'b0;
        A1 = 12'b0;
        Jump = 0;

        // Test sequence
        #10 Pcounter = 12'h001; Jump = 0; A1 = 12'h0; // Increment by 1
        #10 Pcounter = 12'h002; Jump = 1; A1 = 12'h003; // Jump to PC + A1
        #10 Pcounter = 12'h005; Jump = 0; A1 = 12'h0; // Increment by 1
        #10 Pcounter = 12'h006; Jump = 1; A1 = 12'h002; // Jump to PC + A1
        #10 Pcounter = 12'h008; Jump = 0; A1 = 12'h0; // Increment by 1

        $display("Simulation complete at time = %0d ps", $time);
        #50 $finish; // End simulation
    end
endmodule