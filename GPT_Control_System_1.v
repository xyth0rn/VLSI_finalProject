module ControlSystem1 (
    input clk,
    input [3:0] contl,
    input jump2,
    output reg jump1,
    output reg ret1,
    output reg push1,
    output reg wen1
);

    always @(posedge clk) begin
        // Default values
        jump1 = 0;
        ret1 = 0;
        push1 = 0;
        wen1 = 0;

        case (contl)
            4'b0001: begin
                jump1 = ~jump2;
                ret1 = ~jump2;
            end
            4'b0010: begin
                jump1 = ~jump2;
            end
            4'b0011: begin
                jump1 = ~jump2;
                push1 = ~jump2;
            end
            4'b0100: begin
                jump1 = ~jump2; // Zero operation jump
            end
            4'b0101: begin
                jump1 = ~jump2; // Non-zero operation jump
            end
            4'b0110: begin
                jump1 = ~jump2; // Carry flag 1 jump
            end
            4'b0111: begin
                jump1 = ~jump2; // Carry flag 0 jump
            end
            4'b1xxx: begin
                wen1 = ~jump2; // Data operation
            end
            default: begin
                // No operation
            end
        endcase
    end

    `probe(clk);
    `probe(contl);
    `probe(jump2);
    `probe(jump1);
    `probe(ret1);
    `probe(push1);
    `probe(wen1);
endmodule

module top_module ();
    reg clk = 0;
    always #5 clk = ~clk; // Generate clock with period = 10

    reg [3:0] contl;
    reg jump2;
    wire jump1, ret1, push1, wen1;

    // Instantiate ControlSystem1
    ControlSystem1 uut (
        .clk(clk),
        .contl(contl),
        .jump2(jump2),
        .jump1(jump1),
        .ret1(ret1),
        .push1(push1),
        .wen1(wen1)
    );

    initial `probe_start; // Start the timing diagram

    `probe(clk);          // Probe clock
    `probe(contl);        // Probe control signal
    `probe(jump2);        // Probe jump2 input
    `probe(jump1);        // Probe jump1 output
    `probe(ret1);         // Probe ret1 output
    `probe(push1);        // Probe push1 output
    `probe(wen1);         // Probe wen1 output

    initial begin
        // Initialize signals
        contl = 4'b0000;
        jump2 = 0;

        // Test sequence
        #10 contl = 4'b0001; jump2 = 1; // 回主程式
        #10 contl = 4'b0010; jump2 = 1; // 無條件跳躍
        #10 contl = 4'b0011; jump2 = 1; // 無條件呼叫
        #10 contl = 4'b0100; jump2 = 1; // 運算為零跳躍
        #10 contl = 4'b0110; jump2 = 1; // 進位旗號1跳躍
        #10 contl = 4'b1xxx; jump2 = 0; // 資料運算

        $display("Simulation complete at time = %0d ps", $time);
        #50 $finish; // End simulation
    end
endmodule