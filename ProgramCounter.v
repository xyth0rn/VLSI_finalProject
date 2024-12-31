// program counter
module ProgramCounter1 (clk, jump, A1, PCcounter, PCadd);
    input  clk;
    input  jump;                // jump enable
    input  [11:0] PCcounter;    // PC address input
    input  [11:0] A1;           // jump address
    output [11:0] PCadd;        // adder output

    reg [11:0] PCadd;

    // DEBUG: need clock or not?
    always @(posedge clk) begin
        if (jump)
            PCadd = PCcounter + A1;
        else
            PCadd = PCcounter + 1;
    end

endmodule

module ProgramCounter2 (clk, jump, ret, jumber, stk0, pc);
    input  clk;
    input  jump;                // jump enable
    input  ret;                 // return enable
    input  [11:0] jumber;       // jump address
    input  [11:0] stk0;         // stack data input
    output [11:0] pc;           // PC address output

    reg [11:0] pc;

    // DEBUG: need clock or not?
    always @(posedge clk) begin
        if (ret)
            pc = stk0;
        else if (jump)
            pc = pc + jumber;
        else
            pc = pc + 1;
endmodule