# VLSI_finalProject
## Project Overview
Full microcomputer CPU architecture diagram
![image](https://github.com/user-attachments/assets/2d0383ae-9fd9-4da5-883c-339e9faa62c8)

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

### GPT_AddrCtrl.v
#### Prompt
```
for a microcomputer architecture, write a verilog code address control system submodule GPT_AddrCtrl.v that has the structure
and truth table of the following images. Also write a testbench GPT_AddrCtrl_tb.v for this submodule.
```
![image](https://github.com/user-attachments/assets/ca63657e-c050-4139-9080-ec6c48dd1f9a)

#### Result
```v
module GPT_AddrCtrl (
    input wire [3:0] D0,     // 4-bit input D0
    input wire [3:0] D1,     // 4-bit input D1
    input wire ctl,          // 1-bit control input
    input wire clk,          // clock signal
    output reg [3:0] addr    // 4-bit output addr
);

    // Intermediate register IR1
    reg [3:0] IR1;

    // On positive clock edge, update IR1 and addr
    always @(posedge clk) begin
        // Multiplexer logic for IR1
        if (ctl == 0) begin
            IR1 <= D0;
        end else begin
            IR1 <= D1;
        end

        // Assign IR1 to addr (IR2 behavior)
        addr <= IR1;
    end
endmodule

// testbench
module GPT_AddrCtrl_tb;

    // Inputs
    reg [3:0] D0;
    reg [3:0] D1;
    reg ctl;
    reg clk;

    // Outputs
    wire [3:0] addr;

    // Instantiate the Unit Under Test (UUT)
    GPT_AddrCtrl uut (
        .D0(D0),
        .D1(D1),
        .ctl(ctl),
        .clk(clk),
        .addr(addr)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Test sequence
    initial begin
        // Initialize inputs
        D0 = 4'b0000;
        D1 = 4'b0000;
        ctl = 0;

        // Wait for global reset
        #10;

        // Test case 1: ctl = 0, IR1 should take D0
        D0 = 4'b1010;
        ctl = 0;
        #10;
        $display("ctl=0, IR1=%b, addr=%b", uut.IR1, addr);

        // Test case 2: ctl = 1, IR1 should take D1
        D1 = 4'b1100;
        ctl = 1;
        #10;
        $display("ctl=1, IR1=%b, addr=%b", uut.IR1, addr);

        // Test case 3: Change D0 and D1 while ctl = 0
        D0 = 4'b0110;
        ctl = 0;
        #10;
        $display("ctl=0, IR1=%b, addr=%b", uut.IR1, addr);

        // Test case 4: Change ctl to 1, addr should follow D1
        D1 = 4'b1111;
        ctl = 1;
        #10;
        $display("ctl=1, IR1=%b, addr=%b", uut.IR1, addr);

        // End of test
        $stop;
    end
endmodule
```
#### Simulation

### GPT_Stack_System.v
Prompt:
![image](https://github.com/user-attachments/assets/01ccee98-897a-4906-a42d-e60fe70d77f3)
![image](https://github.com/user-attachments/assets/20180472-0867-42ae-8d23-903098ddd7e0)

Result 1: Passed first try
![image](https://github.com/user-attachments/assets/f3ec9e30-8667-4aec-b618-f587022e94bf)
![image](https://github.com/user-attachments/assets/ae276894-de80-40a6-b6ee-1223e22cf0b6)
然後就對了
```v
module GPT_StackSystem (
    input [11:0] Pcx,     // Data input
    input Clk,            // Clock
    input Push,           // Push enable
    input Pop,            // Pop enable
    output reg [11:0] stk0 // Stack output
);
    reg [11:0] Q0, Q1, Q2, Q3; // Stack registers
    reg [1:0] Sp;             // Stack pointer (2 bits to select 4 slots)

    always @(posedge Clk) begin
        if (Push) begin
            case (Sp)
                2'b00: Q0 <= Pcx;
                2'b01: Q1 <= Pcx;
                2'b10: Q2 <= Pcx;
                2'b11: Q3 <= Pcx;
            endcase
            Sp <= Sp - 1; // Update stack pointer on push
        end
        else if (Pop) begin
            Sp <= Sp + 1; // Update stack pointer on pop
        end
    end

    // Multiplexer for stack output
    always @(*) begin
        case (Sp)
            2'b00: stk0 = Q0;
            2'b01: stk0 = Q1;
            2'b10: stk0 = Q2;
            2'b11: stk0 = Q3;
        endcase
    end

    `probe(Pcx);   // Probe input data
    `probe(Clk);   // Probe clock
    `probe(Push);  // Probe push signal
    `probe(Pop);   // Probe pop signal
    `probe(stk0);  // Probe stack output
    `probe(Sp);    // Probe stack pointer
    `probe(Q0);    // Probe stack register Q0
    `probe(Q1);    // Probe stack register Q1
    `probe(Q2);    // Probe stack register Q2
    `probe(Q3);    // Probe stack register Q3
endmodule

module GPT_StackSystem ();
    reg clk = 0; // Clock signal
    always #5 clk = ~clk; // Create clock with period=10

    initial `probe_start; // Start the timing diagram

    `probe(clk); // Probe clock signal

    // Testbench signals
    reg [11:0] Pcx;
    reg Push, Pop;
    wire [11:0] stk0;

    // Instantiate StackSystem
    GPT_StackSystem uut (
        .Pcx(Pcx),
        .Clk(clk),
        .Push(Push),
        .Pop(Pop),
        .stk0(stk0)
    );

    initial begin
        // Initialize signals
        Pcx = 12'b0;
        Push = 0;
        Pop = 0;

        // Test sequence
        #10 Pcx = 12'hA; Push = 1; Pop = 0; // Push A
        #10 Push = 0;                      // Disable push
        #10 Pcx = 12'hB; Push = 1;         // Push B
        #10 Push = 0;                      // Disable push
        #10 Pcx = 12'hC; Push = 1;         // Push C
        #10 Push = 0;                      // Disable push
        #10 Pcx = 12'hD; Push = 1;         // Push D
        #10 Push = 0;                      // Disable push

        #20 Pop = 1; Push = 0; // Pop to access Q2
        #10 Pop = 0;           // Disable pop
        #10 Pop = 1;           // Pop to access Q1
        #10 Pop = 0;           // Disable pop
        #10 Pop = 1;           // Pop to access Q0
        #10 Pop = 0;           // Disable pop
        
        $display ("Simulation complete at time = %0d ps", $time);
        #50 $finish; // End simulation
    end
endmodule
```
### GPT_Program_counter.v
Prompt:
![image](https://github.com/user-attachments/assets/d2009493-b769-48e1-94cf-a49bf367fce3)
Result 1:
直接pass
![image](https://github.com/user-attachments/assets/f00252a4-b0d1-48f7-9c61-38ac07749dc0)

```v
module ProgramCounter2 (
    input [11:0] Pcounter, // Current PC address input
    input [11:0] A1,       // Jump address input
    input Jump,            // Jump enable signal
    output reg [11:0] PCadd // Program counter output
);
    always @(*) begin
        if (Jump)
            PCadd = Pcounter + A1; // Jump to new address
        else
            PCadd = Pcounter + 1;  // Increment PC by 1
    end

    `probe(Pcounter); // Probe current PC address input
    `probe(A1);       // Probe jump address input
    `probe(Jump);     // Probe jump enable signal
    `probe(PCadd);    // Probe PC output
endmodule


module top_module ();
    reg [11:0] Pcounter; // Current PC address input
    reg [11:0] A1;       // Jump address input
    reg Jump;            // Jump enable signal
    wire [11:0] PCadd;   // Program counter output

    // Instantiate ProgramCounter2
    ProgramCounter2 uut (
        .Pcounter(Pcounter),
        .A1(A1),
        .Jump(Jump),
        .PCadd(PCadd)
    );

    reg clk = 0;
    always #5 clk = ~clk; // Generate clock with period = 10

    initial `probe_start; // Start the timing diagram

    `probe(clk);        // Probe clock signal
    `probe(Pcounter);   // Probe PC input
    `probe(A1);         // Probe jump address
    `probe(Jump);       // Probe jump signal
    `probe(PCadd);      // Probe PC output

    initial begin
        // Initialize signals
        Pcounter = 12'b0;
        A1 = 12'b0;
        Jump = 0;

        // Test sequence
        #10 Pcounter = 12'h001; Jump = 0; A1 = 12'h0; // Increment by 1
        #10 Pcounter = 12'h002; Jump = 1; A1 = 12'h003; // Jump to PC + A1
        #10 Pcounter = 12'h005; Jump = 0; A1 = 12'h0; // Increment by 1
        #10 Pcounter = 12'h006; Jump = 1; A1 = 12'h002; // Jump to PC + A1
        #10 Pcounter = 12'h008; Jump = 0; A1 = 12'h0; // Increment by 1

        $display("Simulation complete at time = %0d ps", $time);
        #50 $finish; // End simulation
    end
endmodule
```
### GPT_Control_System_1.v
Prompt:
<img width="1026" alt="image" src="https://github.com/user-attachments/assets/853bb2d4-9b60-4b14-9098-d213d5045026" />

Result 1:
直接pass
![image](https://github.com/user-attachments/assets/beab3276-8460-4bd3-82c5-965012f67734)

```v

## Homemade
Although this final project is intended for us to learn the verilog language through using ChatGPT, but I have learned a little bit of verilog previously during the course Digital Lab in the spring semester of year 2024, so I decided to take on the challenge of coding this final project on my own. For each submodule, I first inspected the structure to determine the IO wires, internal wires, and internal registers required. After initiallizing the submodule, I then write the functions according to the structure diagrams and the truthtable.
> [!Note]
> The ALU and the Real Time Data Control System specifications were not provided in the homework instruction file.

### DataReg_addr.v
#### Submodule Structure
![image](https://github.com/user-attachments/assets/33e95b4a-4653-4d05-b809-c85148da062c)

#### Submodule Truthtable
![image](https://github.com/user-attachments/assets/702e5f9b-450b-41b5-818d-c0930e6ae03b)
![image](https://github.com/user-attachments/assets/bda0a8ef-5e21-4308-b117-7cb30bf3334c)
![image](https://github.com/user-attachments/assets/b4986a3b-46bf-4083-8ce4-cb856f1cdee8)

#### Source Code
```v
// IO DataReg_addr
// Manages data exchange with external devices, storing the address or data being processed.
module DataReg_addr (D, B1, B2, addr, cha, chb, clk, WE, B0, B3, Da, Db);
    input    [7:0] D;               // data input 8-bit
    inout    [7:0] B1, B2;          // IO
    input    [1:0] addr;            // address input (ROM)
    input    [1:0] cha, chb;        // address input (register)
    input    clk;                   // clock
    input    WE;                    // write enable
    output   [7:0] B0, B3;          // data output
    output   [7:0] Da, Db;          // mux output

    reg      [7:0] Q3, Q2, Q1, Q0;  // data register
    reg      [1:0] choicetempA, choicetempB;
    reg      [7:0] Da, Db;
    wire     [7:0] K1, K2;          // calculation wire for B1 B2

    // data register
    always @ (posedge clk) begin
        if(WE) begin
            case (addr)
                0: Q0 = D;
                1: Q1 = D;
                2: Q2 = D;
                3: Q3 = D;
            endcase
        end
    end


    // tristate buffer and IO
    // bufif1 (output, input, control);
    bufif1 t1_0(K1[0], Q1[0], Q0[0]);
    bufif1 t1_1(K1[1], Q1[1], Q0[0]);
    bufif1 t1_2(K1[2], Q1[2], Q0[0]);
    bufif1 t1_3(K1[3], Q1[3], Q0[0]);
    bufif1 t1_4(K1[4], Q1[4], Q0[0]);
    bufif1 t1_5(K1[5], Q1[5], Q0[0]);
    bufif1 t1_6(K1[6], Q1[6], Q0[0]);
    bufif1 t1_7(K1[7], Q1[7], Q0[0]);

    bufif1 t2_0(K2[0], Q2[0], Q0[1]);
    bufif1 t2_1(K2[1], Q2[1], Q0[1]);
    bufif1 t2_2(K2[2], Q2[2], Q0[1]);
    bufif1 t2_3(K2[3], Q2[3], Q0[1]);
    bufif1 t2_4(K2[4], Q2[4], Q0[1]);
    bufif1 t2_5(K2[5], Q2[5], Q0[1]);
    bufif1 t2_6(K2[6], Q2[6], Q0[1]);
    bufif1 t2_7(K2[7], Q2[7], Q0[1]);

    assign B0 = Q0;
    assign B1 = K1;
    assign B2 = K2;
    assign B3 = Q3;


    // address register and IO
    always @ (posedge clk) begin
        choicetempA <= cha;
        choicetempB <= chb;
    end

    always @ (choicetempA or Q3 or K2 or K1 or Q0) begin
        case (choicetempA)
            0: Da = Q0;
            1: Da = K1;
            2: Da = K2;
            3: Da = Q3;
        endcase
    end


    // data register and IO
    always @ (choicetempB or Q3 or K2 or K1 or Q0) begin
        case (choicetempB)
            0: Db = Q0;
            1: Db = K1;
            2: Db = K2;
            3: Db = Q3;
        endcase
    end
endmodule
```

### DataSelect.v
#### Submodule Structure
![image](https://github.com/user-attachments/assets/4d3005d7-e30c-47e8-9b2f-a0b6ac327611)

#### Submodule Truthtable
![image](https://github.com/user-attachments/assets/2e1bafbc-ab6e-4440-a034-9461f132b1c6)

#### Source Code
```v
// DataSelecter (register)
// Routes data between the ALU and other components, acting as a multiplexer.
module DataSelect (Da, Db, romx, clk, Ctl, dataa, datab);
	input  [7:0] Da, Db, romx;
	input  clk, Ctl;
	output [7:0] dataa, datab;

	reg	   [7:0] dataa, datab;

	always @ (posedge clk) begin
		dataa <= Da;
	end

	always @ (posedge clk) begin
		case (Ctl):
			0: datab <= Db;
			1: datab <= romx;
		endcase
	end
endmodule
```
### AddrCtrl.v
#### Submodule Structure
![image](https://github.com/user-attachments/assets/72f60ac4-9e6f-48d5-92dc-1fcecde44b8c)

#### Submodule Truthtable
![image](https://github.com/user-attachments/assets/e030016d-eb71-4203-96dc-715705f3ea88)

#### Source Code
```v
// Address control system
// Handles address management for memory and I/O operations. (align timing issue using ir1 ir2)

module AddrCtrl (D0, D1, clk, Ctl, addr);
	input  [3:0] D0, D1;
	input  clk, Ctl;
	output [3:0] addr;

	reg    [3:0] addr, ir1, ir2;

	// always @ (Ctl or D0 or D1) begin
	always @ (posedge clk) begin
		case (Ctl)
			0: ir1 = D0;
			1: ir1 = D1;
		endcase
	end

	always @ (posedge clk) begin
		addr = ir2;
		ir2 = ir1;
	end
endmodule
```
### StackSys_StackIndex.v
#### Submodule Structure
![image](https://github.com/user-attachments/assets/ca90e25f-546e-469b-9ba9-137aff680581)
![image](https://github.com/user-attachments/assets/b4001f67-3581-4a37-88da-0f0d65d58cd0)

#### Submodule Truthtable
![image](https://github.com/user-attachments/assets/e43a7865-b468-4d7f-a301-030674cbbe2b)
![image](https://github.com/user-attachments/assets/28c4ba18-8160-40d5-bf98-420368589b29)

#### Source Code
```v
// stack system
// stack is used for storing return addresses and temporary data.
// Stack Index tracks the top of the stack, enabling push and pop operations.
module StackSys (pcx, clk, push, sp, stk0);
    input [11:0] pcx;
    input clk, push;    // push is decoder enable
    input [11:0] sp;    // decoder input from stack index
    output [11:0] stk0; // mux output

    reg [11:0] stk0;    // mux output
    reg [11:0] Q0, Q1, Q2, Q3;

    // write in
    always @(posedge clk) begin
        if (push) begin
            case (sp)
                0: Q0 <= pcx;
                1: Q1 <= pcx;
                2: Q2 <= pcx;
                3: Q3 <= pcx;
            endcase
        end

        else begin;
            Q0 <= Q0;
            Q1 <= Q1;
            Q2 <= Q2;
            Q3 <= Q3;
        end
    end

    always @(posedge clk) begin
        case (sp)
            0: stk0 <= Q0;
            1: stk0 <= Q1;
            2: stk0 <= Q2;
            3: stk0 <= Q3;
        endcase
    end
endmodule

module StackIndex (clk, push, pop, sp);
    input  clk;     // clock
    input  push;    // push enable
    input  pop;     // pop enable
    output [1:0] sp;

    reg [1:0] sp;

    always @(posedge clk) begin
        if (push) begin
            sp = sp + 1;
        end

        else if (pop) begin
            sp = sp - 1;
        end
    end
endmodule
```

### ProgramCounter.v
#### Submodule Structure
![image](https://github.com/user-attachments/assets/8509ff97-1c65-461d-88ef-2d4d9a51dd20)
![image](https://github.com/user-attachments/assets/ead66b93-d575-4b50-bb21-2b33dcc00a4f)

#### Submodule Truthtable
Program Counter 1
![image](https://github.com/user-attachments/assets/8d568e4b-de02-4ac9-a3ee-a470b0d9e200)

Program Counter 2
![image](https://github.com/user-attachments/assets/0b161ca9-4bd7-48dd-bacd-d6dc58314c33)
![image](https://github.com/user-attachments/assets/44dce9bc-f450-4326-ba50-874eef1af144)

#### Source Code
```v
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
```


### ConditionCodeSystem.v
#### Submodule Structure
![image](https://github.com/user-attachments/assets/daa9612f-792e-4d0f-b824-b7b6819510a4)

#### Submodule Truthtable
![image](https://github.com/user-attachments/assets/36963ccf-81d4-406e-a5be-fc6c806c9c68)

#### Source Code
```v
module ConditionCodeSystem (cont, aluo, tcnd);
    input [3:0] cont;   // instruction control line
    input  [7:0] aluo;  // ALU output
    output tcnd;        // condition control output

    // DEBUG: need clock or not?
    always @(*) begin
        case (cont)
            4'b0001: tcnd = 4'b0001;
            4'b0010: tcnd = 4'b0001;
            4'b0011: tcnd = 4'b0001;
            4'b0100: tcnd = (aluo == 0) ? 4'b0001 : 4'b0000;
            4'b0101: tcnd = (aluo != 0) ? 4'b0001 : 4'b0000;
            4'b0110: tcnd = 
            4'b0111: tcnd = 
        endcase
    end
endmodule
```

### ControlSystem.v
#### Submodule Structure
Control System 1
![image](https://github.com/user-attachments/assets/de9a851d-df08-4c1e-84ea-f02a8d3e8938)

Control System 2
![image](https://github.com/user-attachments/assets/62afad9f-77d8-4056-b95d-57006d3a9e7c)

#### Submodule Truthtable
![image](https://github.com/user-attachments/assets/0b07b666-a255-45ee-8626-95d108c7cdfe)

#### Source Code
```v
module ControlSystem1 (clk, cont, jump2, jupm1, ret1, push1, wen1);
    input  clk;
    input  [3:0] cont;   // instruction control
    input  jump2;        // jump control input
    
    output reg ret1;     // return to main program control
    output reg push1;    // push input enable
    output reg wen1;     // write in register enable
    output reg jump1;    // jump control output to program counter

    always @(posedge clk) begin
        case (cont)
            4'b0001: begin
                jump1 = !jump2;
                ret1  = !jump2;
                push1 = 4'b0000;
                wen1  = 4'b0000;
            end
            4'b0010: begin
                jump1 = !jump2;
                ret1  = 4'b0000;
                push1 = 4'b0000;
                wen1  = 4'b0000;
            end
            4'b0011: begin
                jump1 = !jump2;
                ret1  = 4'b0000;
                push1 = !jump2;
                wen1  = 4'b0000;
            end
            4'b0100: begin
                jump1 = !jump2;
                ret1  = 4'b0000;
                push1 = 4'b0000;
                wen1  = 4'b0000;
            end
            4'b0101: begin
                jump1 = !jump2;
                ret1  = 4'b0000;
                push1 = 4'b0000;
                wen1  = 4'b0000;
            end
            4'b0110: begin
                jump1 = !jump2;
                ret1  = 4'b0000;
                push1 = 4'b0000;
                wen1  = 4'b0000;
            end
            4'b0111: begin
                jump1 = !jump2;
                ret1  = 4'b0000;
                push1 = 4'b0000;
                wen1  = 4'b0000;
            end
            default: begin
                if(cont[3] == 1) begin
                    jump1 = 4'b0000;
                    ret1  = 4'b0000;
                    push1 = 4'b0000;
                    wen1  = !jump2;
                end
                else begin
                    jump1 = 4'b0000;
                    ret1  = 4'b0000;
                    push1 = 4'b0000;
                    wen1  = 4'b0000;
                end
            end
    
        endcase
    end

endmodule


module ControlSystem2 (clk, cont, tcnd, jump2, ret1, push2, wen2);
    input clk;
    input [3:0] cont;   // instruction control
    input tcnd;         // condition control

    output reg jump2;       // jump control output to program counter
    output ret1;        // return to main program control
    output reg push2;       // push input enable
    output reg wen2;        // write in register enable

    reg jump1, tempret, push1, wen1;

    assign temp1 = jump1 & tecnd & !jump2;

    always @(posedge clk) begin
        jump2 = temp1;
    end

    always @(posedge clk) begin
        tempret = 1'b0; wen1 = 1'b0; push1 = 1'b0; jump1 = 1'b0;
        case (cont) 
            1: begin 
                tempret = !jump2;
                jump1 = !jump2;
            end
            2: tempret = !jump2;
            3: begin
                push1 = !jump2;
                jump1 = !jump2;
            end
            4, 5, 6, 7: jump1 = !jump2;
            8, 9, 10, 11, 12,13, 14, 15: wen1 = !jump2;
        endcase
    end

    assign ret1 = tempret & !jump2;

    always @(posedge clk) begin
        push2 = push1 & !jump2;
        wen2 = wen1 & jump2;
    end

endmodule
```
