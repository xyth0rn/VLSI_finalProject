module ProgramCounter1 (
    input wire [11:0] Pcounter,  // Current PC address input
    input wire [11:0] A1,        // Jump address input
    input wire jump,             // Jump enable
    output reg [11:0] PCadd      // Program counter output
);

    always @(*) begin
        if (jump)
            PCadd = Pcounter + A1;  // Jump to PC + A1
        else
            PCadd = Pcounter + 1;   // Increment PC by 1
    end

    `probe(Pcounter);  // Debug: Probe Pcounter
    `probe(A1);        // Debug: Probe A1
    `probe(jump);      // Debug: Probe jump signal
    `probe(PCadd);     // Debug: Probe PCadd (output)

endmodule

module top_module ();

    // Testbench signals
    reg [11:0] Pcounter; // Current PC address input
    reg [11:0] A1;       // Jump address input
    reg jump;            // Jump enable signal
    wire [11:0] PCadd;   // Program counter output

    // Instantiate ProgramCounter1
    ProgramCounter1 uut (
        .Pcounter(Pcounter),
        .A1(A1),
        .jump(jump),
        .PCadd(PCadd)
    );

    // Clock-like signal for visualization (optional)
    reg clk = 0;
    always #5 clk = ~clk; // Clock period = 10 units

    initial `probe_start; // Start probing for debugging

    `probe(clk);          // Probe clock signal (for reference)
    `probe(Pcounter);     // Probe PC input
    `probe(A1);           // Probe jump address
    `probe(jump);         // Probe jump signal
    `probe(PCadd);        // Probe PC output

    // Test sequence
    initial begin
        // Test case 1: Increment PC by 1
        Pcounter = 12'h001; A1 = 12'h000; jump = 0;
        #10 $display("Test 1: jump=0, PCadd=%h (should be PC+1)", PCadd);

        // Test case 2: Jump to PC + A1
        Pcounter = 12'h002; A1 = 12'h003; jump = 1;
        #10 $display("Test 2: jump=1, PCadd=%h (should be PC+A1)", PCadd);

        // Test case 3: Increment PC by 1 again
        Pcounter = 12'h005; A1 = 12'h000; jump = 0;
        #10 $display("Test 3: jump=0, PCadd=%h (should be PC+1)", PCadd);

        // Test case 4: Another jump to PC + A1
        Pcounter = 12'h008; A1 = 12'h002; jump = 1;
        #10 $display("Test 4: jump=1, PCadd=%h (should be PC+A1)", PCadd);

        // End simulation
        $finish;
    end
endmodule