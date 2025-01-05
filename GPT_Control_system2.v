module ControlSystem2 (
    input wire clk,            // Clock signal
    input wire [3:0] contl,    // Instruction control
    input wire tcnd,           // Condition control
    input wire jump2_in,       // Jump control input (renamed for clarity)
    output wire ret1,          // Return to main program control
    output reg push2,          // Push input enable
    output reg wen2            // Write in register enable
);

    reg tempret, push1, wen1;  // Internal control signals
    wire temp1;                // Intermediate signal
    reg jump1;                 // Internal jump control

    // Combinational logic for temp1
    assign temp1 = jump1 & tcnd & jump2_in;

    // Assign jump2 as a wire based on temp1
    wire jump2 = temp1;

    // Control logic
    always @(posedge clk) begin
        tempret = 1'b0;
        wen1 = 1'b0;
        push1 = 1'b0;
        jump1 = 1'b0;

        case (contl)
            4'b0001: begin
                tempret = jump2;
                jump1 = jump2;
            end
            4'b0010: begin
                jump1 = jump2;
            end
            4'b0011: begin
                push1 = jump2;
                jump1 = jump2;
            end
            4'b0100, 4'b0101, 4'b0110, 4'b0111: begin
                jump1 = jump2;
            end
            default: begin
                wen1 = ~jump2;
            end
        endcase
    end

    // Assign ret1
    assign ret1 = tempret & jump2;

    // Synchronous logic for push2 and wen2
    always @(posedge clk) begin
        push2 <= push1 & jump2;
        wen2 <= wen1 & jump2;
    end

endmodule

module top_module;
    reg clk;                 // Test clock signal
    reg [3:0] contl;         // Test instruction control
    reg tcnd;                // Test condition control
    reg jump2_in;            // Test jump control input
    wire ret1;               // Return control output
    wire push2;              // Push control output
    wire wen2;               // Write enable output

    // Instantiate the Control System 2 module
    ControlSystem2 uut (
        .clk(clk),
        .contl(contl),
        .tcnd(tcnd),
        .jump2_in(jump2_in), // 修正這裡，與模組定義一致
        .ret1(ret1),
        .push2(push2),
        .wen2(wen2)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Clock period = 10 units
    end

    initial `probe_start; // Start the timing diagram

    `probe(contl);        // Probe control signal
    `probe(tcnd);         // Probe condition signal
    `probe(jump2_in);     // Probe jump control input
    `probe(ret1);         // Probe return control
    `probe(push2);        // Probe push control
    `probe(wen2);         // Probe write enable

    // Test sequence
    initial begin
        // Initialize inputs
        contl = 4'b0000; tcnd = 0; jump2_in = 0;

        // Test case 1: Instruction = NOP
        #10 contl = 4'b0000; jump2_in = 0;
        #10 $display("Test 1: ret1 = %b, push2 = %b, wen2 = %b", ret1, push2, wen2);

        // Test case 2: Instruction = RET
        #10 contl = 4'b0001; jump2_in = 1;
        #10 $display("Test 2: ret1 = %b, push2 = %b, wen2 = %b", ret1, push2, wen2);

        // Test case 3: Instruction = JUMP
        #10 contl = 4'b0010; jump2_in = 1;
        #10 $display("Test 3: ret1 = %b, push2 = %b, wen2 = %b", ret1, push2, wen2);

        // Test case 4: Instruction = CALL
        #10 contl = 4'b0011; jump2_in = 1;
        #10 $display("Test 4: ret1 = %b, push2 = %b, wen2 = %b", ret1, push2, wen2);

        // Test case 5: Default case
        #10 contl = 4'b1111; jump2_in = 0;
        #10 $display("Test 5: ret1 = %b, push2 = %b, wen2 = %b", ret1, push2, wen2);

        // End simulation
        #20 $finish;
    end

endmodule