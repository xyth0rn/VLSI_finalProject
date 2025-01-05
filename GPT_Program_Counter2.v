module ProgramCounter2 (
    input wire clk,              // Clock signal
    input wire jump,             // Jump enable
    input wire ret,              // Return enable
    input wire [11:0] jumber,    // Jump address
    input wire [11:0] stk0,      // Stack data input
    output reg [11:0] pc         // PC address output
);

    always @(posedge clk) begin
        if (ret)
            pc <= stk0;          // Return to address from stack
        else if (jump)
            pc <= pc + jumber;   // Jump to specific address
        else
            pc <= pc + 1;        // Default increment
    end

    `probe(clk);   // Debug: clock signal
    `probe(jump);  // Debug: jump enable
    `probe(ret);   // Debug: return enable
    `probe(jumber); // Debug: jump address input
    `probe(stk0);  // Debug: stack input
    `probe(pc);    // Debug: program counter output
endmodule


module top_module ();
    reg clk = 0;                  // Clock signal
    reg jump = 0;                 // Jump enable
    reg ret = 0;                  // Return enable
    reg [11:0] jumber = 12'b0;    // Jump address input
    reg [11:0] stk0 = 12'b0;      // Stack data input
    wire [11:0] pc;               // PC address output

    // Instantiate ProgramCounter2
    ProgramCounter2 uut (
        .clk(clk),
        .jump(jump),
        .ret(ret),
        .jumber(jumber),
        .stk0(stk0),
        .pc(pc)
    );

    // Clock generation
    always #5 clk = ~clk; // Clock period = 10 units

    initial `probe_start; // Start probing for debugging

    `probe(clk);          // Probe clock
    `probe(jump);         // Probe jump
    `probe(ret);          // Probe return
    `probe(jumber);       // Probe jump address
    `probe(stk0);         // Probe stack input
    `probe(pc);           // Probe program counter output

    // Test sequence
    initial begin
        // Test case 1: Increment PC by 1
        #10 jump = 0; ret = 0; jumber = 12'h000; stk0 = 12'h000;
        #10 $display("PC = %h (should increment by 1)", pc);

        // Test case 2: Jump to PC + jumber
        #10 jump = 1; ret = 0; jumber = 12'h003; 
        #10 $display("PC = %h (should jump to PC + 3)", pc);

        // Test case 3: Increment PC by 1
        #10 jump = 0; ret = 0; 
        #10 $display("PC = %h (should increment by 1)", pc);

        // Test case 4: Return to stk0 address
        #10 jump = 0; ret = 1; stk0 = 12'h010; 
        #10 $display("PC = %h (should return to stk0)", pc);

        // End simulation
        $finish;
    end
endmodule