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
![image](https://github.com/user-attachments/assets/cbde9a0b-d612-4579-885f-530cea7c0de5)


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

Result: 
![image](https://github.com/user-attachments/assets/f3ec9e30-8667-4aec-b618-f587022e94bf)

<img width="1030" alt="image" src="https://github.com/user-attachments/assets/d324c5b3-ea9f-439e-96a8-7f0acf6220b1" />

![image](https://github.com/user-attachments/assets/c842b443-a043-48ff-842c-8a153393075f)

然後就對了
```v
module GPT_stack_system (
    input wire [11:0] Pcx,  // 12-bit data input
    input wire Clk,         // Clock
    input wire Push,        // Push enable
    input wire [1:0] Sp,    // Stack pointer (2-bit)
    output reg [11:0] stk0  // Stack output
);

    // Stack registers
    reg [11:0] Q0, Q1, Q2, Q3;

    always @(posedge Clk) begin
        if (Push) begin
            // Write to stack based on stack pointer
            case (Sp)
                2'b00: Q0 <= Pcx;
                2'b01: Q1 <= Pcx;
                2'b10: Q2 <= Pcx;
                2'b11: Q3 <= Pcx;
            endcase
        end
    end

    // Multiplexer to output the value based on Sp
    always @(*) begin
        case (Sp)
            2'b00: stk0 = Q0;
            2'b01: stk0 = Q1;
            2'b10: stk0 = Q2;
            2'b11: stk0 = Q3;
        endcase
    end

    `probe(Pcx);  // Probe data input
    `probe(Clk);  // Probe clock
    `probe(Push); // Probe push enable
    `probe(Sp);   // Probe stack pointer
    `probe(stk0); // Probe stack output
    `probe(Q0);   // Probe Q0 register
    `probe(Q1);   // Probe Q1 register
    `probe(Q2);   // Probe Q2 register
    `probe(Q3);   // Probe Q3 register

endmodule


module top_module ();
    // Testbench signals
    reg [11:0] Pcx;
    reg Clk;
    reg Push;
    reg [1:0] Sp;
    wire [11:0] stk0;

    // Instantiate StackSystem
    GPT_stack_system uut (
        .Pcx(Pcx),
        .Clk(Clk),
        .Push(Push),
        .Sp(Sp),
        .stk0(stk0)
    );

    // Clock generation
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk; // Clock period = 10 time units
    end

    // Test sequence
    initial begin
        `probe_start; // Start the timing diagram

        // Initialize signals
        Pcx = 12'b0;
        Push = 0;
        Sp = 2'b00;

        // Test case 1: Push data into Q0
        #10 Pcx = 12'hA; Push = 1; Sp = 2'b00;
        #10 Push = 0; // Disable push

        // Test case 2: Push data into Q1
        #10 Pcx = 12'hB; Push = 1; Sp = 2'b01;
        #10 Push = 0; // Disable push

        // Test case 3: Push data into Q2
        #10 Pcx = 12'hC; Push = 1; Sp = 2'b10;
        #10 Push = 0; // Disable push

        // Test case 4: Push data into Q3
        #10 Pcx = 12'hD; Push = 1; Sp = 2'b11;
        #10 Push = 0; // Disable push

        // Test case 5: Read from Q0
        #10 Sp = 2'b00;
        #10 $display("Reading from Q0: stk0 = %h", stk0);

        // Test case 6: Read from Q1
        #10 Sp = 2'b01;
        #10 $display("Reading from Q1: stk0 = %h", stk0);

        // Test case 7: Read from Q2
        #10 Sp = 2'b10;
        #10 $display("Reading from Q2: stk0 = %h", stk0);

        // Test case 8: Read from Q3
        #10 Sp = 2'b11;
        #10 $display("Reading from Q3: stk0 = %h", stk0);

        $stop; // End simulation
    end

endmodule


```
### GPT_Program_counter1.v
Prompt
<img width="557" alt="image" src="https://github.com/user-attachments/assets/171bb723-1f91-4cf6-b4c1-ceddd37ee8e3" />
Result:
![image](https://github.com/user-attachments/assets/cc1f5a5c-79bb-4793-8de5-1e5943c1065b)
```v
module ProgramCounter1 (
    input wire [11:0] Pcounter,  // Current PC address input
    input wire [11:0] A1,        // Jump address input
    input wire jump,             // Jump enable
    output reg [11:0] PCadd      // Program counter output
);

    always @(*) begin
        if (jump)
            PCadd = Pcounter + A1;  // Jump to PC + A1
        else
            PCadd = Pcounter + 1;   // Increment PC by 1
    end

    `probe(Pcounter);  // Debug: Probe Pcounter
    `probe(A1);        // Debug: Probe A1
    `probe(jump);      // Debug: Probe jump signal
    `probe(PCadd);     // Debug: Probe PCadd (output)

endmodule

module top_module ();

    // Testbench signals
    reg [11:0] Pcounter; // Current PC address input
    reg [11:0] A1;       // Jump address input
    reg jump;            // Jump enable signal
    wire [11:0] PCadd;   // Program counter output

    // Instantiate ProgramCounter1
    ProgramCounter1 uut (
        .Pcounter(Pcounter),
        .A1(A1),
        .jump(jump),
        .PCadd(PCadd)
    );

    // Clock-like signal for visualization (optional)
    reg clk = 0;
    always #5 clk = ~clk; // Clock period = 10 units

    initial `probe_start; // Start probing for debugging

    `probe(clk);          // Probe clock signal (for reference)
    `probe(Pcounter);     // Probe PC input
    `probe(A1);           // Probe jump address
    `probe(jump);         // Probe jump signal
    `probe(PCadd);        // Probe PC output

    // Test sequence
    initial begin
        // Test case 1: Increment PC by 1
        Pcounter = 12'h001; A1 = 12'h000; jump = 0;
        #10 $display("Test 1: jump=0, PCadd=%h (should be PC+1)", PCadd);

        // Test case 2: Jump to PC + A1
        Pcounter = 12'h002; A1 = 12'h003; jump = 1;
        #10 $display("Test 2: jump=1, PCadd=%h (should be PC+A1)", PCadd);

        // Test case 3: Increment PC by 1 again
        Pcounter = 12'h005; A1 = 12'h000; jump = 0;
        #10 $display("Test 3: jump=0, PCadd=%h (should be PC+1)", PCadd);

        // Test case 4: Another jump to PC + A1
        Pcounter = 12'h008; A1 = 12'h002; jump = 1;
        #10 $display("Test 4: jump=1, PCadd=%h (should be PC+A1)", PCadd);

        // End simulation
        $finish;
    end
endmodule
```


### GPT_Program_counter2.v
Prompt:
![image](https://github.com/user-attachments/assets/d2009493-b769-48e1-94cf-a49bf367fce3)
發現接腳是錯的
<img width="962" alt="image" src="https://github.com/user-attachments/assets/8d1f647c-9b17-4955-9771-eb90eb14b2f0" />


Result :
![image](https://github.com/user-attachments/assets/78f8ca16-8374-4c9b-9926-841be6097bb0)


```v
module ProgramCounter2 (
    input wire clk,              // Clock signal
    input wire jump,             // Jump enable
    input wire ret,              // Return enable
    input wire [11:0] jumber,    // Jump address
    input wire [11:0] stk0,      // Stack data input
    output reg [11:0] pc         // PC address output
);

    always @(posedge clk) begin
        if (ret)
            pc <= stk0;          // Return to address from stack
        else if (jump)
            pc <= pc + jumber;   // Jump to specific address
        else
            pc <= pc + 1;        // Default increment
    end

    `probe(clk);   // Debug: clock signal
    `probe(jump);  // Debug: jump enable
    `probe(ret);   // Debug: return enable
    `probe(jumber); // Debug: jump address input
    `probe(stk0);  // Debug: stack input
    `probe(pc);    // Debug: program counter output
endmodule


module top_module ();
    reg clk = 0;                  // Clock signal
    reg jump = 0;                 // Jump enable
    reg ret = 0;                  // Return enable
    reg [11:0] jumber = 12'b0;    // Jump address input
    reg [11:0] stk0 = 12'b0;      // Stack data input
    wire [11:0] pc;               // PC address output

    // Instantiate ProgramCounter2
    ProgramCounter2 uut (
        .clk(clk),
        .jump(jump),
        .ret(ret),
        .jumber(jumber),
        .stk0(stk0),
        .pc(pc)
    );

    // Clock generation
    always #5 clk = ~clk; // Clock period = 10 units

    initial `probe_start; // Start probing for debugging

    `probe(clk);          // Probe clock
    `probe(jump);         // Probe jump
    `probe(ret);          // Probe return
    `probe(jumber);       // Probe jump address
    `probe(stk0);         // Probe stack input
    `probe(pc);           // Probe program counter output

    // Test sequence
    initial begin
        // Test case 1: Increment PC by 1
        #10 jump = 0; ret = 0; jumber = 12'h000; stk0 = 12'h000;
        #10 $display("PC = %h (should increment by 1)", pc);

        // Test case 2: Jump to PC + jumber
        #10 jump = 1; ret = 0; jumber = 12'h003; 
        #10 $display("PC = %h (should jump to PC + 3)", pc);

        // Test case 3: Increment PC by 1
        #10 jump = 0; ret = 0; 
        #10 $display("PC = %h (should increment by 1)", pc);

        // Test case 4: Return to stk0 address
        #10 jump = 0; ret = 1; stk0 = 12'h010; 
        #10 $display("PC = %h (should return to stk0)", pc);

        // End simulation
        $finish;
    end
endmodule
```
### GPT_Control_System_1.v
Prompt:
<img width="1026" alt="image" src="https://github.com/user-attachments/assets/853bb2d4-9b60-4b14-9098-d213d5045026" />

Result 1:
直接pass
![image](https://github.com/user-attachments/assets/beab3276-8460-4bd3-82c5-965012f67734)

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


### DataSelect.v
#### Submodule Structure
![image](https://github.com/user-attachments/assets/4d3005d7-e30c-47e8-9b2f-a0b6ac327611)

#### Submodule Truthtable
![image](https://github.com/user-attachments/assets/2e1bafbc-ab6e-4440-a034-9461f132b1c6)

### AddrCtrl.v
#### Submodule Structure
![image](https://github.com/user-attachments/assets/72f60ac4-9e6f-48d5-92dc-1fcecde44b8c)

#### Submodule Truthtable
![image](https://github.com/user-attachments/assets/e030016d-eb71-4203-96dc-715705f3ea88)

Result


### StackSys_StackIndex.v
#### Submodule Structure
![image](https://github.com/user-attachments/assets/ca90e25f-546e-469b-9ba9-137aff680581)
![image](https://github.com/user-attachments/assets/b4001f67-3581-4a37-88da-0f0d65d58cd0)

#### Submodule Truthtable
![image](https://github.com/user-attachments/assets/e43a7865-b468-4d7f-a301-030674cbbe2b)
![image](https://github.com/user-attachments/assets/28c4ba18-8160-40d5-bf98-420368589b29)

chatGPT testbench Result
![image](https://github.com/user-attachments/assets/7a436c3b-1762-476d-87ad-94523dfc1647)

### ProgramCounter.v
#### Submodule Structure
![image](https://github.com/user-attachments/assets/8509ff97-1c65-461d-88ef-2d4d9a51dd20)
![image](https://github.com/user-attachments/assets/ead66b93-d575-4b50-bb21-2b33dcc00a4f)

#### Submodule Truthtable
Program Counter 1
![image](https://github.com/user-attachments/assets/8d568e4b-de02-4ac9-a3ee-a470b0d9e200)
chatGPT revise:
<img width="974" alt="image" src="https://github.com/user-attachments/assets/9a6d3f8f-3a75-4a37-958b-e509e2a08291" />
chatGPT testbench result:
![image](https://github.com/user-attachments/assets/de172171-0959-40fa-93c7-d85f8d4babe8)


Program Counter 2
![image](https://github.com/user-attachments/assets/0b161ca9-4bd7-48dd-bacd-d6dc58314c33)
![image](https://github.com/user-attachments/assets/44dce9bc-f450-4326-ba50-874eef1af144)

chatgpt testbench result
![image](https://github.com/user-attachments/assets/58f608e0-cccd-498a-afec-a18301e0e082)


### ConditionCodeSystem.v
#### Submodule Structure
![image](https://github.com/user-attachments/assets/daa9612f-792e-4d0f-b824-b7b6819510a4)

#### Submodule Truthtable
![image](https://github.com/user-attachments/assets/36963ccf-81d4-406e-a5be-fc6c806c9c68)

### ControlSystem.v
#### Submodule Structure
Control System 1
![image](https://github.com/user-attachments/assets/de9a851d-df08-4c1e-84ea-f02a8d3e8938)
chatgpt testbench result 1:
![image](https://github.com/user-attachments/assets/311d92f0-f105-4ea0-9c67-11f85803d257)
revise:
<img width="975" alt="image" src="https://github.com/user-attachments/assets/b8bdca3c-2341-4113-81b3-1cecd52be320" />
chatgpt testbench result 2:
![image](https://github.com/user-attachments/assets/7d9aeb58-0732-48b7-bd65-6e5dc086bb6b)


Control System 2
![image](https://github.com/user-attachments/assets/62afad9f-77d8-4056-b95d-57006d3a9e7c)

#### Submodule Truthtable
![image](https://github.com/user-attachments/assets/0b07b666-a255-45ee-8626-95d108c7cdfe)
