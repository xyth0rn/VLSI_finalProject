module ConditionCode (
    input [3:0] cont,       // Instruction control line
    input [11:0] alu,       // ALU operation output
    output reg tcnd         // Condition control output
);

    always @(*) begin
        case (cont)
            4'b0001: tcnd = 1'b1;  // RET: tcnd = 1
            4'b0010: tcnd = 1'b1;  // JUMP: tcnd = 1
            4'b0011: tcnd = 1'b1;  // CALL: tcnd = 1
            4'b0100: tcnd = (alu == 12'b0) ? 1'b1 : 1'b0; // JZ: tcnd = 1 if ALU result is 0
            4'b0101: tcnd = (alu != 12'b0) ? 1'b1 : 1'b0; // JNZ: tcnd = 1 if ALU result is non-zero
            4'b0110: tcnd = alu[11]; // JC: tcnd = 1 if carry flag (MSB) is 1
            4'b0111: tcnd = ~alu[11]; // JNC: tcnd = 1 if carry flag (MSB) is 0
            default: tcnd = 1'b0;  // Default: tcnd = 0
        endcase
    end

endmodule

module top_module;
    reg [3:0] cont;        // Test instruction control line
    reg [11:0] alu;        // Test ALU operation output
    wire tcnd;             // Condition control output

    // Instantiate the ConditionCode module
    ConditionCode uut (
        .cont(cont),
        .alu(alu),
        .tcnd(tcnd)
    );

    initial `probe_start; // Start the timing diagram

    `probe(cont);  // Probe instruction control line
    `probe(alu);   // Probe ALU output
    `probe(tcnd);  // Probe condition control output

    // Test sequence
    initial begin
        // Test case 1: RET instruction
        cont = 4'b0001; alu = 12'b000000000000;
        #10 $display("Test 1: cont=0001, alu=%b, tcnd=%b (expected 1)", alu, tcnd);

        // Test case 2: JUMP instruction
        cont = 4'b0010; alu = 12'b000000000000;
        #10 $display("Test 2: cont=0010, alu=%b, tcnd=%b (expected 1)", alu, tcnd);

        // Test case 3: CALL instruction
        cont = 4'b0011; alu = 12'b000000000000;
        #10 $display("Test 3: cont=0011, alu=%b, tcnd=%b (expected 1)", alu, tcnd);

        // Test case 4: JZ instruction, ALU result = 0
        cont = 4'b0100; alu = 12'b000000000000;
        #10 $display("Test 4: cont=0100, alu=%b, tcnd=%b (expected 1)", alu, tcnd);

        // Test case 5: JZ instruction, ALU result != 0
        cont = 4'b0100; alu = 12'b000000000001;
        #10 $display("Test 5: cont=0100, alu=%b, tcnd=%b (expected 0)", alu, tcnd);

        // Test case 6: JNZ instruction, ALU result != 0
        cont = 4'b0101; alu = 12'b000000000001;
        #10 $display("Test 6: cont=0101, alu=%b, tcnd=%b (expected 1)", alu, tcnd);

        // Test case 7: JNZ instruction, ALU result = 0
        cont = 4'b0101; alu = 12'b000000000000;
        #10 $display("Test 7: cont=0101, alu=%b, tcnd=%b (expected 0)", alu, tcnd);

        // Test case 8: JC instruction, carry flag = 1
        cont = 4'b0110; alu = 12'b100000000000;
        #10 $display("Test 8: cont=0110, alu=%b, tcnd=%b (expected 1)", alu, tcnd);

        // Test case 9: JC instruction, carry flag = 0
        cont = 4'b0110; alu = 12'b000000000000;
        #10 $display("Test 9: cont=0110, alu=%b, tcnd=%b (expected 0)", alu, tcnd);

        // Test case 10: JNC instruction, carry flag = 0
        cont = 4'b0111; alu = 12'b000000000000;
        #10 $display("Test 10: cont=0111, alu=%b, tcnd=%b (expected 1)", alu, tcnd);

        // Test case 11: JNC instruction, carry flag = 1
        cont = 4'b0111; alu = 12'b100000000000;
        #10 $display("Test 11: cont=0111, alu=%b, tcnd=%b (expected 0)", alu, tcnd);

        // End simulation
        #20 $finish;
    end

endmodule