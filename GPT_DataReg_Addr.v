// Updated Verilog Code for Data Register with Address and Tristate Gate

module GPT_DataReg_Addr (
    input [7:0] D,        // 8-bit data input
    input clk,            // clock signal
    input WE,             // write enable
    input [1:0] add,      // address input (ROM)
    input [1:0] cha,      // address register input A
    input [1:0] chb,      // address register input B
    output reg [7:0] Q0,  // Data register Q0
    output reg [7:0] Q1,  // Data register Q1
    output reg [7:0] Q2,  // Data register Q2
    output reg [7:0] Q3,  // Data register Q3
    output [7:0] B0,      // Data output B0
    output [7:0] B1,      // I/O B1
    output [7:0] B2,      // I/O B2
    output [7:0] B3,      // Data output B3
    output [7:0] Da,      // Multiplexer output A
    output [7:0] Db       // Multiplexer output B
);

    // Internal tristate signals
    wire [7:0] data_out[3:0];

    // Decoder for write enable to specific register
    always @(posedge clk) begin
        if (WE) begin
            case (add)
                2'b00: Q0 <= D;
                2'b01: Q1 <= D;
                2'b10: Q2 <= D;
                2'b11: Q3 <= D;
                default: ;
            endcase
        end
    end

    // Assign outputs to tristate buffers
    assign data_out[0] = Q0;
    assign data_out[1] = Q1;
    assign data_out[2] = Q2;
    assign data_out[3] = Q3;

    // Tristate gate for DataOutput
    assign B0 = data_out[0];
    assign B1 = data_out[1];
    assign B2 = data_out[2];
    assign B3 = data_out[3];

    // Multiplexer for output Da
    assign Da = (cha == 2'b00) ? Q0 :
                (cha == 2'b01) ? Q1 :
                (cha == 2'b10) ? Q2 :
                (cha == 2'b11) ? Q3 : 8'b0;

    // Multiplexer for output Db
    assign Db = (chb == 2'b00) ? Q0 :
                (chb == 2'b01) ? Q1 :
                (chb == 2'b10) ? Q2 :
                (chb == 2'b11) ? Q3 : 8'b0;

endmodule

// Updated Testbench for Data Register
module GPT_DataReg_Addr_tb;
    reg [7:0] D;
    reg clk;
    reg WE;
    reg [1:0] add;
    reg [1:0] cha;
    reg [1:0] chb;
    wire [7:0] Q0;
    wire [7:0] Q1;
    wire [7:0] Q2;
    wire [7:0] Q3;
    wire [7:0] B0;
    wire [7:0] B1;
    wire [7:0] B2;
    wire [7:0] B3;
    wire [7:0] Da;
    wire [7:0] Db;

    GPT_DataReg uut (
        .D(D),
        .clk(clk),
        .WE(WE),
        .add(add),
        .cha(cha),
        .chb(chb),
        .Q0(Q0),
        .Q1(Q1),
        .Q2(Q2),
        .Q3(Q3),
        .B0(B0),
        .B1(B1),
        .B2(B2),
        .B3(B3),
        .Da(Da),
        .Db(Db)
    );

    initial begin
        // Initialize signals
        clk = 0;
        WE = 0;
        add = 2'b00;
        cha = 2'b00;
        chb = 2'b00;
        D = 8'h00;

        // Write operations
        #10 WE = 1; D = 8'hA0; add = 2'b00; // Write to Q0
        #10 WE = 1; D = 8'hB1; add = 2'b01; // Write to Q1
        #10 WE = 1; D = 8'hC2; add = 2'b10; // Write to Q2
        #10 WE = 1; D = 8'hD3; add = 2'b11; // Write to Q3

        // Read operations
        #10 WE = 0; cha = 2'b00; chb = 2'b01; // Read Q0 to Da, Q1 to Db
        #10 cha = 2'b10; chb = 2'b11;         // Read Q2 to Da, Q3 to Db

        #20 $finish;
    end

    // Clock generation
    always #5 clk = ~clk;

endmodule
