# VLSI_finalProject
## ChatGPT
Since the structure and truth table of each submodule is given in the homework instruction file, I first discribed the overall function and input output signals to ChatGPT and then guide it to do further corrections by providing more detailed truth table to ensure accuracy. Because there is a daily limit of image uploads to the free version of ChatGPT, the truth table and submodule structure are sometimes described in words instead of the actual image from the homeword instruction.

### GPT_DataReg_Addr.v
Prompt:
```
For a microcomputer architecture, write a verilog code data register for address and also make corresponding testbench.
The DataReg(address) should:
1. 8-bit data input D
2. clock signal clk
3. write enable WE
4. 8-bit Data registers Q0~Q3 
5. Address input(ROM): add(1,0)
6. Address register input: cha(1,0),chb(1,0).
7. Data output:B0(7~0),B3(7~0).
8. I/O:B2(7~0),B1(7~0).
9. Multiplexer output: Da(7~0),Db(7,0)

adjust the verilog code so that the module has the structure and output truth table of:
```
![image](https://github.com/user-attachments/assets/ed085325-c34a-4ead-b840-c7883633a391)
![image](https://github.com/user-attachments/assets/6cbf334f-69ed-4ae4-aa51-5a50ea2478e1)

Result:
```v
// Verilog Code for Data Register with Address and Tristate Gate

module GPT_DataReg (
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

// Testbench for Data Register
module DataReg_tb;
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
```

### GPT_DataSelect.v
Prompt:
```
for a microcomputer architecture, write a verilog code data selecter system submodule GPT_DataSelect.v that has the structure of:

inputs: 8-bit Da, 8-bit Db, 8-bit romx, 1-bit ctl, clk
outputs: 8-bit dataa, 8-bit datab

structure:
Da feeds into a register dataa, dataa is then outputted.
Db and romx is fed into a multiplexer that is controlled by ctl. 
at every positive clock edge, if ctl == 0, the mux output (datab) is set to Db;
if clt == 1, the mux output (datab) is set to romx.

also write a testbench for this
```

Result:
```v
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
```

## Homemade
