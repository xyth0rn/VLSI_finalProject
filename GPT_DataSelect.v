module GPT_DataSelect (
    input wire [7:0] Da,      // 8-bit input Da
    input wire [7:0] Db,      // 8-bit input Db
    input wire [7:0] romx,    // 8-bit input romx
    input wire ctl,           // 1-bit control signal
    input wire clk,           // clock signal
    output reg [7:0] dataa,   // 8-bit register output dataa
    output reg [7:0] datab    // 8-bit multiplexer output datab
);

    always @(posedge clk) begin
        // Register dataa is assigned Da
        dataa <= Da;

        // Multiplexer controlled by ctl
        if (ctl == 1'b0) begin
            datab <= Db;
        end else begin
            datab <= romx;
        end
    end

    `probe(Da);    // Probe input Da
    `probe(Db);    // Probe input Db
    `probe(romx);  // Probe input romx
    `probe(ctl);   // Probe control signal
    `probe(clk);   // Probe clock signal
    `probe(dataa); // Probe output dataa
    `probe(datab); // Probe output datab

endmodule

module top_module;
    reg [7:0] Da;     // Test input Da
    reg [7:0] Db;     // Test input Db
    reg [7:0] romx;   // Test input romx
    reg ctl;          // Test control signal
    reg clk;          // Test clock
    wire [7:0] dataa; // Output dataa
    wire [7:0] datab; // Output datab

    // Instantiate the DataSelect module
    GPT_DataSelect uut (
        .Da(Da),
        .Db(Db),
        .romx(romx),
        .ctl(ctl),
        .clk(clk),
        .dataa(dataa),
        .datab(datab)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Generate clock with period = 10 units
    end

    initial `probe_start; // Start the timing diagram

    `probe(Da);    // Probe input Da
    `probe(Db);    // Probe input Db
    `probe(romx);  // Probe input romx
    `probe(ctl);   // Probe control signal
    `probe(clk);   // Probe clock signal
    `probe(dataa); // Probe output dataa
    `probe(datab); // Probe output datab

    // Test sequence
    initial begin
        // Test case 1: ctl = 0, datab should take Db
        Da = 8'hAA; Db = 8'hBB; romx = 8'hCC; ctl = 0;
        #10 $display("Test 1: ctl=0, datab=%h (expected Db=BB)", datab);

        // Test case 2: ctl = 1, datab should take romx
        Da = 8'h11; Db = 8'h22; romx = 8'h33; ctl = 1;
        #10 $display("Test 2: ctl=1, datab=%h (expected romx=33)", datab);

        // Test case 3: ctl = 0, datab should take Db
        Da = 8'hFF; Db = 8'h00; romx = 8'h77; ctl = 0;
        #10 $display("Test 3: ctl=0, datab=%h (expected Db=00)", datab);

        // Test case 4: ctl = 1, datab should take romx
        Da = 8'h88; Db = 8'h44; romx = 8'h99; ctl = 1;
        #10 $display("Test 4: ctl=1, datab=%h (expected romx=99)", datab);

        // End simulation
        #20 $finish;
    end

endmodule