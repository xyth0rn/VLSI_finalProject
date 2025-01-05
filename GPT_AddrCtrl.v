module AddressControlSystem (
    input wire [3:0] D0,  // 4-bit input D0
    input wire [3:0] D1,  // 4-bit input D1
    input wire ctl,       // Control signal for multiplexer
    input wire clk,       // Clock signal
    output reg [3:0] addr // 4-bit address output
);

    reg [3:0] IR1;  // Intermediate register IR1

    // Multiplexer and IR1 logic
    always @(*) begin
        if (ctl == 1'b0) begin
            IR1 = D0;
        end else begin
            IR1 = D1;
        end
    end

    // IR2 logic: Register the output
    always @(posedge clk) begin
        addr <= IR1;
    end

    // Probes for debugging
    `probe(D0);   // Probe input D0
    `probe(D1);   // Probe input D1
    `probe(ctl);  // Probe control signal
    `probe(clk);  // Probe clock signal
    `probe(IR1);  // Probe IR1 output
    `probe(addr); // Probe address output

endmodule

module top_module;
    reg [3:0] D0;   // Test input D0
    reg [3:0] D1;   // Test input D1
    reg ctl;        // Test control signal
    reg clk;        // Test clock signal
    wire [3:0] addr; // Address output

    // Instantiate Address Control System module
    AddressControlSystem uut (
        .D0(D0),
        .D1(D1),
        .ctl(ctl),
        .clk(clk),
        .addr(addr)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Generate clock with period = 10 units
    end

    initial `probe_start; // Start the timing diagram

    `probe(D0);   // Probe input D0
    `probe(D1);   // Probe input D1
    `probe(ctl);  // Probe control signal
    `probe(clk);  // Probe clock signal
    `probe(addr); // Probe address output

    // Test sequence
    initial begin
        // Initialize inputs
        D0 = 4'b0000; D1 = 4'b0000; ctl = 0;

        // Test case 1: ctl = 0, addr should take D0
        #10 D0 = 4'b1010; ctl = 0;
        #10 $display("Test 1: addr = %b (expected 1010)", addr);

        // Test case 2: ctl = 1, addr should take D1
        #10 D1 = 4'b1100; ctl = 1;
        #10 $display("Test 2: addr = %b (expected 1100)", addr);

        // Test case 3: Change D0 while ctl = 0
        #10 D0 = 4'b0011; ctl = 0;
        #10 $display("Test 3: addr = %b (expected 0011)", addr);

        // Test case 4: Change ctl to 1, addr should follow D1
        #10 D1 = 4'b1111; ctl = 1;
        #10 $display("Test 4: addr = %b (expected 1111)", addr);

        // End simulation
        #20 $finish;
    end

endmodule