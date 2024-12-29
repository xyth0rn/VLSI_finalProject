// program counter
module ProgramCounter (clk, jump, A1, PCcounter, PCadd);
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