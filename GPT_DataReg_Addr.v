module GPT_DataReg_Addr (
    input wire [7:0] D,       // 8-bit data input
    input wire clk,           // clock signal
    input wire WE,            // write enable
    input wire [1:0] add,     // address input (ROM)
    input wire [1:0] cha,     // address register input A
    input wire [1:0] chb,     // address register input B
    output reg [7:0] Q0,      // Data register Q0
    output reg [7:0] Q1,      // Data register Q1
    output reg [7:0] Q2,      // Data register Q2
    output reg [7:0] Q3,      // Data register Q3
    output wire [7:0] B0,     // Data output B0
    output wire [7:0] B1,     // I/O B1
    output wire [7:0] B2,     // I/O B2
    output wire [7:0] B3,     // Data output B3
    output wire [7:0] Da,     // Multiplexer output A
    output wire [7:0] Db      // Multiplexer output B
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

    `probe(D);      // Probe data input
    `probe(clk);    // Probe clock
    `probe(WE);     // Probe write enable
    `probe(add);    // Probe address input
    `probe(cha);    // Probe address register input A
    `probe(chb);    // Probe address register input B
    `probe(Q0);     // Probe Q0 register
    `probe(Q1);     // Probe Q1 register
    `probe(Q2);     // Probe Q2 register
    `probe(Q3);     // Probe Q3 register
    `probe(B0);     // Probe output B0
    `probe(B1);     // Probe output B1
    `probe(B2);     // Probe output B2
    `probe(B3);     // Probe output B3
    `probe(Da);     // Probe multiplexer output A
    `probe(Db);     // Probe multiplexer output B

endmodule

module top_module;
    reg [7:0] D;       // Test data input
    reg clk;           // Test clock
    reg WE;            // Test write enable
    reg [1:0] add;     // Test address input
    reg [1:0] cha;     // Test address register input A
    reg [1:0] chb;     // Test address register input B
    wire [7:0] Q0;     // Data register Q0
    wire [7:0] Q1;     // Data register Q1
    wire [7:0] Q2;     // Data register Q2
    wire [7:0] Q3;     // Data register Q3
    wire [7:0] B0;     // Data output B0
    wire [7:0] B1;     // Data output B1
    wire [7:0] B2;     // Data output B2
    wire [7:0] B3;     // Data output B3
    wire [7:0] Da;     // Multiplexer output A
    wire [7:0] Db;     // Multiplexer output B

    // Instantiate the Data Register module
    GPT_DataReg_Addr uut (
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

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Generate clock with period = 10 units
    end

    initial `probe_start; // Start the timing diagram

    `probe(D);    // Probe data input
    `probe(clk);  // Probe clock signal
    `probe(WE);   // Probe write enable signal
    `probe(add);  // Probe address input
    `probe(cha);  // Probe address register input A
    `probe(chb);  // Probe address register input B
    `probe(Q0);   // Probe Q0 register
    `probe(Q1);   // Probe Q1 register
    `probe(Q2);   // Probe Q2 register
    `probe(Q3);   // Probe Q3 register
    `probe(B0);   // Probe output B0
    `probe(B1);   // Probe output B1
    `probe(B2);   // Probe output B2
    `probe(B3);   // Probe output B3
    `probe(Da);   // Probe multiplexer output A
    `probe(Db);   // Probe multiplexer output B

    // Test sequence
    initial begin
        // Initialize signals
        WE = 0; add = 2'b00; cha = 2'b00; chb = 2'b00; D = 8'h00;

        // Test case 1: Write to Q0
        #10 WE = 1; D = 8'hA0; add = 2'b00;
        #10 $display("Test 1: Q0 = %h (expected A0)", Q0);

        // Test case 2: Write to Q1
        #10 WE = 1; D = 8'hB1; add = 2'b01;
        #10 $display("Test 2: Q1 = %h (expected B1)", Q1);

        // Test case 3: Write to Q2
        #10 WE = 1; D = 8'hC2; add = 2'b10;
        #10 $display("Test 3: Q2 = %h (expected C2)", Q2);

        // Test case 4: Write to Q3
        #10 WE = 1; D = 8'hD3; add = 2'b11;
        #10 $display("Test 4: Q3 = %h (expected D3)", Q3);

        // Test case 5: Read Q0 to Da, Q1 to Db
        #10 WE = 0; cha = 2'b00; chb = 2'b01;
        #10 $display("Test 5: Da = %h (expected Q0), Db = %h (expected Q1)", Da, Db);

        // Test case 6: Read Q2 to Da, Q3 to Db
        #10 cha = 2'b10; chb = 2'b11;
        #10 $display("Test 6: Da = %h (expected Q2), Db = %h (expected Q3)", Da, Db);

        // End simulation
        #20 $finish;
    end

endmodule