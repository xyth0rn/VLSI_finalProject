// Verilog Code for Data Selector System Submodule

module GPT_DataSelect (
    input [7:0] Da,      // 8-bit input Da
    input [7:0] Db,      // 8-bit input Db
    input [7:0] romx,    // 8-bit input romx
    input ctl,           // 1-bit control signal
    input clk,           // clock signal
    output reg [7:0] dataa, // 8-bit register output dataa
    output reg [7:0] datab  // 8-bit multiplexer output datab
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

endmodule

// Testbench for Data Selector System Submodule
module GPT_DataSelect_tb;
    reg [7:0] Da;
    reg [7:0] Db;
    reg [7:0] romx;
    reg ctl;
    reg clk;
    wire [7:0] dataa;
    wire [7:0] datab;

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

    initial begin
        // Initialize signals
        clk = 0;
        Da = 8'h00;
        Db = 8'h00;
        romx = 8'h00;
        ctl = 0;

        // Apply test vectors
        #10 Da = 8'hAA; Db = 8'hBB; romx = 8'hCC; ctl = 0; // ctl = 0 -> datab = Db
        #10 Da = 8'h11; Db = 8'h22; romx = 8'h33; ctl = 1; // ctl = 1 -> datab = romx
        #10 Da = 8'hFF; Db = 8'h00; romx = 8'h77; ctl = 0; // ctl = 0 -> datab = Db
        #10 Da = 8'h88; Db = 8'h44; romx = 8'h99; ctl = 1; // ctl = 1 -> datab = romx

        #20 $finish;
    end

    // Clock generation
    always #5 clk = ~clk;

endmodule