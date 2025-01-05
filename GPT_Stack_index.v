module StackIndex (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input push,        // Push enable signal
    input pop,         // Pop enable signal
    output reg [1:0] sp // Stack index output
);

    // Initialize or update stack pointer based on control signals
    always @(posedge clk or posedge reset) begin
        if (reset)
            sp <= 2'b00; // Initialize stack pointer to 0 on reset
        else if (pop)
            sp <= sp + 1; // Increment stack pointer on pop
        else if (push)
            sp <= sp - 1; // Decrement stack pointer on push
    end

endmodule
module top_module;
    reg clk;          // Test clock signal
    reg reset;        // Test reset signal
    reg push;         // Test push enable signal
    reg pop;          // Test pop enable signal
    wire [1:0] sp;    // Stack index output

    // Instantiate the StackIndex module
    StackIndex uut (
        .clk(clk),
        .reset(reset),
        .push(push),
        .pop(pop),
        .sp(sp)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Clock period = 10 units
    end

    initial `probe_start; // Start the timing diagram

    `probe(reset); // Probe reset signal
    `probe(push);  // Probe push signal
    `probe(pop);   // Probe pop signal
    `probe(sp);    // Probe stack index output

    // Test sequence
    initial begin
        // Initialize inputs
        reset = 1; push = 0; pop = 0; // Reset activated
        #10 reset = 0;                // Deactivate reset

        // Test case 1: No operation after reset
        #10 $display("Test 1: sp = %b (expected 00 after reset)", sp);

        // Test case 2: Perform a pop operation, sp should increment
        #10 pop = 1;
        #10 pop = 0; // Disable pop
        #10 $display("Test 2: sp = %b (expected 01)", sp);

        // Test case 3: Perform a push operation, sp should decrement
        #10 push = 1;
        #10 push = 0; // Disable push
        #10 $display("Test 3: sp = %b (expected 00)", sp);

        // Test case 4: Activate reset again, sp should be initialized to 00
        #10 reset = 1;
        #10 reset = 0;
        #10 $display("Test 4: sp = %b (expected 00 after reset)", sp);

        // End simulation
        #20 $finish;
    end

endmodule
