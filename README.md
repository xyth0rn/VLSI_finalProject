# VLSI_finalProject
NYCUEE 11251210 黃仲璿, 111511011 李知器
## Abstract
In this final project, we attempt to use chatGPT to generate verilog code for a the submodules of a simple microcomputer architecture as a practice to learn to write verilog code using AI. Prompt is given in the form of both words and images of the desired structure and truth table. Pure hand-coding was also tested as a comparison with the chatGPT generated code using the same set of generated testbench.

Full microcomputer CPU architecture diagram

![image](https://github.com/user-attachments/assets/2d0383ae-9fd9-4da5-883c-339e9faa62c8)

## ChatGPT
Since the structure and truth table of each submodule is given in the homework instruction file, I first discribed the overall function and input output signals to ChatGPT and then guide it to do further corrections by providing more detailed truth table to ensure accuracy. Because there is a daily limit of image uploads to the free version of ChatGPT, the truth table and submodule structure are sometimes described in words instead of the actual image from the homeword instruction.

### GPT_DataReg_Addr.v
#### Prompt:
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

#### Result:
![image](https://github.com/user-attachments/assets/ef5b06dd-5c38-41c3-ad43-016c8ce2322b)


### GPT_DataSelect.v

#### Prompt:
```
for a microcomputer architecture, write a verilog code data selecter system submodule GPT_DataSelect.v
that has the structure of:

inputs: 8-bit Da, 8-bit Db, 8-bit romx, 1-bit ctl, clk
outputs: 8-bit dataa, 8-bit datab

structure:
Da feeds into a register dataa, dataa is then outputted.
Db and romx is fed into a multiplexer that is controlled by ctl. 
at every positive clock edge, if ctl == 0, the mux output (datab) is set to Db;
if clt == 1, the mux output (datab) is set to romx.

also write a testbench for this
```

#### Result:
![image](https://github.com/user-attachments/assets/5bcb8709-9049-48e1-9a78-0ff4f29a8cbe)

### GPT_AddrCtrl.v

#### Prompt:
```
依照這兩張的內容，幫我把address control 做出來 格式就是topmodule跟 內容
```
![image](https://github.com/user-attachments/assets/e1f37c99-f78b-454f-b0e5-67a95f82f017)
![image](https://github.com/user-attachments/assets/5f8073ed-4387-451c-8d0e-9608dca9c312)


#### Result:
![image](https://github.com/user-attachments/assets/70e72017-089a-4dc9-947d-a32f9df208c0)

### GPT_Stack_System.v

#### Prompt 1:
```
寫出這是什麼
```
![image](https://github.com/user-attachments/assets/8380317a-788f-4f6f-829b-995294ce6374)

#### Reply 1:
```v
module StackSystem (
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
endmodule
```
#### Prompt 2:
```
可以根據他的輸入幫我生一個testbench 嗎
```
#### Reply 2:
``` v
module top_module ();
    reg clk = 0; // Clock signal
    always #5 clk = ~clk; // Create clock with period=10

    initial `probe_start; // Start the timing diagram

    `probe(clk); // Probe clock signal

    // Testbench signals
    reg [11:0] Pcx;
    reg Push, Pop;
    wire [11:0] stk0;

    // Instantiate StackSystem
    StackSystem uut (
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
#### Prompt 3:
```
剛剛前面的stack system 應該是不用pop enable 
```
#### Reply 3:
```v
module StackSystem (
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
```

#### Result: 
![image](https://github.com/user-attachments/assets/c842b443-a043-48ff-842c-8a153393075f)

### GPT_Stack_index.v
#### Prompt 1:
```
幫我依照內容寫出stack index
```
![image](https://github.com/user-attachments/assets/57df0478-7e7f-46e2-bfd1-1651e937e774)

#### Reply:
```v
module StackIndex (
    input clk,         // Clock signal
    input push,        // Push enable signal
    input pop,         // Pop enable signal
    output reg [1:0] sp // Stack index output
);

    always @(posedge clk) begin
        if (pop)
            sp <= sp + 1; // Increment stack pointer on pop
        else if (push)
            sp <= sp - 1; // Decrement stack pointer on push
    end

endmodule

module top_module;
    reg clk;          // Test clock signal
    reg push;         // Test push enable signal
    reg pop;          // Test pop enable signal
    wire [1:0] sp;    // Stack index output

    // Instantiate the StackIndex module
    StackIndex uut (
        .clk(clk),
        .push(push),
        .pop(pop),
        .sp(sp)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Clock period = 10 units
    end

    initial `probe_start; // Start the timing diagram

    `probe(push);  // Probe push signal
    `probe(pop);   // Probe pop signal
    `probe(sp);    // Probe stack index output

    // Test sequence
    initial begin
        // Initialize inputs
        push = 0; pop = 0;

        // Test case 1: No operation, stack pointer should remain unchanged
        #10 $display("Test 1: sp = %b (expected unchanged)", sp);

        // Test case 2: Perform a pop operation, sp should increment
        #10 pop = 1;
        #10 pop = 0; // Disable pop
        #10 $display("Test 2: sp = %b (expected sp + 1)", sp);

        // Test case 3: Perform a push operation, sp should decrement
        #10 push = 1;
        #10 push = 0; // Disable push
        #10 $display("Test 3: sp = %b (expected sp - 1)", sp);

        // Test case 4: No operation, sp should remain unchanged
        #10 $display("Test 4: sp = %b (expected unchanged)", sp);

        // End simulation
        #20 $finish;
    end

endmodule
```
#### Prompt 2:
```
sp 可以初始化嗎
```
#### Reply:
```v
module StackIndex (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input push,        // Push enable signal
    input pop,         // Pop enable signal
    output reg [1:0] sp // Stack index output
);

    // Initialize or update stack pointer based on control signals
    always @(posedge clk or posedge reset) begin
        if (reset)
            sp <= 2'b00; // Initialize stack pointer to 0 on reset
        else if (pop)
            sp <= sp + 1; // Increment stack pointer on pop
        else if (push)
            sp <= sp - 1; // Decrement stack pointer on push
    end

endmodule
module top_module;
    reg clk;          // Test clock signal
    reg reset;        // Test reset signal
    reg push;         // Test push enable signal
    reg pop;          // Test pop enable signal
    wire [1:0] sp;    // Stack index output

    // Instantiate the StackIndex module
    StackIndex uut (
        .clk(clk),
        .reset(reset),
        .push(push),
        .pop(pop),
        .sp(sp)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Clock period = 10 units
    end

    initial `probe_start; // Start the timing diagram

    `probe(reset); // Probe reset signal
    `probe(push);  // Probe push signal
    `probe(pop);   // Probe pop signal
    `probe(sp);    // Probe stack index output

    // Test sequence
    initial begin
        // Initialize inputs
        reset = 1; push = 0; pop = 0; // Reset activated
        #10 reset = 0;                // Deactivate reset

        // Test case 1: No operation after reset
        #10 $display("Test 1: sp = %b (expected 00 after reset)", sp);

        // Test case 2: Perform a pop operation, sp should increment
        #10 pop = 1;
        #10 pop = 0; // Disable pop
        #10 $display("Test 2: sp = %b (expected 01)", sp);

        // Test case 3: Perform a push operation, sp should decrement
        #10 push = 1;
        #10 push = 0; // Disable push
        #10 $display("Test 3: sp = %b (expected 00)", sp);

        // Test case 4: Activate reset again, sp should be initialized to 00
        #10 reset = 1;
        #10 reset = 0;
        #10 $display("Test 4: sp = %b (expected 00 after reset)", sp);

        // End simulation
        #20 $finish;
    end

endmodule
```
#### Result:

![image](https://github.com/user-attachments/assets/d31dd26e-2467-4bd4-8101-377e41323ad7)


### GPT_Program_counter1.v

#### Prompt:
```
幫我依據上面topmodule那種方式生出testbench 跟program counter1
```
![image](https://github.com/user-attachments/assets/c39827a9-a509-4ead-8696-c912a1693486)
#### Reply
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

#### Result:
![image](https://github.com/user-attachments/assets/cc1f5a5c-79bb-4793-8de5-1e5943c1065b)


### GPT_Program_counter2.v

#### Prompt:
```
Program counter 1
Jump enable: jump
PC address input:Pcounter[11…….0]
Jump address input:A1
Adder output: PCadd[11…….0]
 

Jump enable	Input	Output
jump	PCcounter	A1	PCadd
0	PC	X	PC+1
1	PC	B	PC+B
Example 

請用同樣的方式幫我生出progrma counter2
```

#### Reply
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
#### Result:
![image](https://github.com/user-attachments/assets/78f8ca16-8374-4c9b-9926-841be6097bb0)


### GPT_Condition_Code_system.v
#### Prompt:
```
幫我生condition code system
```

#### Reply
```v
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
```
#### Result:
![image](https://github.com/user-attachments/assets/a8c5f5c5-8236-4bde-a8dc-84c720530d84)


### GPT_Control_System_1.v
#### Prompt:
```
 同樣先解釋之後把電路還有tesetbenchg生出來
```
![image](https://github.com/user-attachments/assets/35335c3c-5956-429c-a812-5909f78065a6)

#### Reply 
```v
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
```

#### Result:
![image](https://github.com/user-attachments/assets/beab3276-8460-4bd3-82c5-965012f67734)

### GPT_Control_System_2.v

#### Prompt 1:
```
幫我根據照片寫出control system 2
```
![image](https://github.com/user-attachments/assets/74203ac7-e25f-48e9-a00b-8e24d6c564fc)
![image](https://github.com/user-attachments/assets/51c70e0a-a703-46a2-94c9-0c50f0d35099)

#### Reply 1:
```v
module ControlSystem2 (
    input wire clk,            // Clock signal
    input wire [3:0] contl,    // Instruction control
    input wire tcnd,           // Condition control
    input wire jump2,          // Jump control input
    output reg ret1,           // Return to main program control
    output reg push2,          // Push input enable
    output reg wen2            // Write in register enable
);

    reg tempret, push1, wen1;  // Internal control signals
    wire temp1;                // Intermediate signal
    reg jump1;                 // Internal jump control

    // Combinational logic for temp1
    assign temp1 = jump1 & tcnd & jump2;

    // Synchronous logic for jump2
    always @(posedge clk) begin
        jump2 <= temp1;
    end

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
```

#### Result 1:
![image](https://github.com/user-attachments/assets/14893b6c-cae4-4824-a972-18dc9da1a369)

#### Prompt 2:
```
./top_module.v:20: error: 'jump2' is not a valid l-value for a procedural assignment.
./top_module.v:5:      : 'jump2' is declared here as a wire.
1 error(s) during elaboration.
```
#### Reply 2:
```v
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
```
#### Result 2:
![image](https://github.com/user-attachments/assets/8936d770-1193-4962-b965-6e1730ab190c)

#### Prompt 3:
```
./top_module.v:70: error: port jump2'' is not a port of uut.
./top_module.v:70: warning: Instantiating module ControlSystem2 with dangling input port 4 (jump2_in) floating.
1 error(s) during elaboration.
```
#### Reply 3:
```v
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
```
#### Result 3:
![image](https://github.com/user-attachments/assets/8ad503c6-aa76-49eb-83eb-0ae8c608e0d1)



## Homemade
Although this final project is intended for us to learn the verilog language through using ChatGPT, but I have learned a little bit of verilog previously during the course Digital Lab in the spring semester of year 2024, so I decided to take on the challenge of coding this final project on my own. For each submodule, I first inspected the structure to determine the IO wires, internal wires, and internal registers required. After initiallizing the submodule, I then write the functions according to the structure diagrams and the truthtable.
> [!Note]
> The ALU and the Real Time Data Control System specifications were not provided in the homework instruction file.

### DataReg_addr.v
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

#### chatGPT testbench result 1:
![image](https://github.com/user-attachments/assets/2ba461fb-7786-404a-86e1-78ec4f186256)

#### Revise prompt:
```
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
    DataReg_addr uut (
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
哪裡寫錯了
```
#### Reply:
```v
module DataReg_addr (
    input [7:0] D,        // data input 8-bit
    inout [7:0] B1, B2,   // IO
    input [1:0] addr,     // address input (ROM)
    input [1:0] cha, chb, // address input (register)
    input clk,            // clock
    input WE,             // write enable
    output [7:0] B0, B3,  // data output
    output [7:0] Da, Db,  // mux output
    output reg [7:0] Q0, Q1, Q2, Q3 // data registers as outputs
);

    wire [7:0] K1, K2;

    // Data register
    always @ (posedge clk) begin
        if (WE) begin
            case (addr)
                2'b00: Q0 <= D;
                2'b01: Q1 <= D;
                2'b10: Q2 <= D;
                2'b11: Q3 <= D;
            endcase
        end
    end

    // Tristate buffers
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

    // Address register
    always @ (posedge clk) begin
        Da <= (cha == 2'b00) ? Q0 :
              (cha == 2'b01) ? K1 :
              (cha == 2'b10) ? K2 : Q3;

        Db <= (chb == 2'b00) ? Q0 :
              (chb == 2'b01) ? K1 :
              (chb == 2'b10) ? K2 : Q3;
    end

endmodule
```

#### chatGPT testbench result 2:
![image](https://github.com/user-attachments/assets/d45e9005-48ce-44d5-8f23-da5284ccf7ae)
#### Revise prompt:
```
./top_module.v:83: error: port add'' is not a port of uut.
./top_module.v:53: error: 'Da' is not a valid l-value for a procedural assignment.
./top_module.v:9:      : 'Da' is declared here as a wire.
./top_module.v:57: error: 'Db' is not a valid l-value for a procedural assignment.
./top_module.v:9:      : 'Db' is declared here as a wire.
./top_module.v:83: warning: Instantiating module DataReg_addr with dangling input port 4 (addr) floating.
3 error(s) during elaboration.
```
#### Reply:
```v
module DataReg_addr (
    input [7:0] D,        // data input 8-bit
    inout [7:0] B1, B2,   // IO
    input [1:0] addr,     // address input (ROM)
    input [1:0] cha, chb, // address input (register)
    input clk,            // clock
    input WE,             // write enable
    output [7:0] B0, B3,  // data output
    output reg [7:0] Da,  // mux output
    output reg [7:0] Db,  // mux output
    output reg [7:0] Q0, Q1, Q2, Q3 // data registers as outputs
);

    wire [7:0] K1, K2;

    // Data register
    always @ (posedge clk) begin
        if (WE) begin
            case (addr)
                2'b00: Q0 <= D;
                2'b01: Q1 <= D;
                2'b10: Q2 <= D;
                2'b11: Q3 <= D;
            endcase
        end
    end

    // Tristate buffers
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

    // Address register
    always @ (posedge clk) begin
        Da <= (cha == 2'b00) ? Q0 :
              (cha == 2'b01) ? K1 :
              (cha == 2'b10) ? K2 : Q3;

        Db <= (chb == 2'b00) ? Q0 :
              (chb == 2'b01) ? K1 :
              (chb == 2'b10) ? K2 : Q3;
    end

endmodule
```

#### chatGPT testbench result 3:
![image](https://github.com/user-attachments/assets/b6c1bf00-9aa3-4779-884f-c8fd5ed6d9f4)


### DataSelect.v
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

#### chatGPT testbench Result 1:
![image](https://github.com/user-attachments/assets/841ab3d8-1c0c-4527-9375-30684933cac7)
#### Revise prompt:
```
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

module top_module;
    reg [7:0] Da;     // Test input Da
    reg [7:0] Db;     // Test input Db
    reg [7:0] romx;   // Test input romx
    reg ctl;          // Test control signal
    reg clk;          // Test clock
    wire [7:0] dataa; // Output dataa
    wire [7:0] datab; // Output datab

    // Instantiate the DataSelect module
    DataSelect uut (
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

    probe(Da);    // Probe input Da
    probe(Db);    // Probe input Db
    probe(romx);  // Probe input romx
    probe(ctl);   // Probe control signal
    probe(clk);   // Probe clock signal
    probe(dataa); // Probe output dataa
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
module 哪裡有寫錯嗎
```

#### Reply:
```v
module DataSelect (
    input [7:0] Da, Db, romx,
    input clk, Ctl,
    output reg [7:0] dataa, datab
);

    always @ (posedge clk) begin
        dataa <= Da;
    end

    always @ (posedge clk) begin
        case (Ctl)
            0: datab <= Db;
            1: datab <= romx;
        endcase
    end

endmodule
```
#### chatGPT testbench Result 2:
![image](https://github.com/user-attachments/assets/91d2ef59-5abe-4e19-a0c7-98d32beffc5f)



### AddrCtrl.v
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

#### chatGPT testbench Result 1:
![image](https://github.com/user-attachments/assets/7d11cedd-19a2-4b19-aad3-d5c6688afba5)

#### Revise prompt: 
```
./top_module.v:29: error: port ctl'' is not a port of uut.
./top_module.v:29: warning: Instantiating module AddrCtrl with dangling input port 4 (Ctl) floating.
1 error(s) during elaboration.
```
#### Reply: 
```v
module AddrCtrl (D0, D1, clk, Ctl, addr);
    input  [3:0] D0, D1;
    input  clk, Ctl;
    output reg [3:0] addr;

    reg [3:0] ir1, ir2;

    // Multiplexer controlled by Ctl
    always @ (posedge clk) begin
        case (Ctl)
            1'b0: ir1 = D0;
            1'b1: ir1 = D1;
        endcase
    end

    // IR2 and address update
    always @ (posedge clk) begin
        addr = ir2;
        ir2 = ir1;
    end
endmodule
```

#### chatGPT testbench Result 2:
![image](https://github.com/user-attachments/assets/e1c3f088-65e4-4cd2-a0a0-03860e25eba3)


### StackSys_StackIndex.v
#### Source Code
```v
// stack system
// stack is used for storing return addresses and temporary data.
Stack Index tracks the top of the stack, enabling push and pop operations.
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

#### chatGPT testbench Result
![image](https://github.com/user-attachments/assets/7a436c3b-1762-476d-87ad-94523dfc1647)


### ProgramCounter.v
#### Program Counter 1 Source Code
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
```

#### chatGPT revise prompt:
```
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
可以幫我改成不是clk trigger嗎
```
#### Reply:
```v
module ProgramCounter1 (
    input wire jump,            // Jump enable
    input wire [11:0] PCcounter, // PC address input
    input wire [11:0] A1,        // Jump address
    output reg [11:0] PCadd      // Adder output
);

    // Combinational logic (triggered on any input change)
    always @(*) begin
        if (jump)
            PCadd = PCcounter + A1;  // Jump to PC + A1
        else
            PCadd = PCcounter + 1;   // Increment PC by 1
    end

endmodule

修正內容總結

	1.	修正 case 語法錯誤（移除多餘的冒號）。
	2.	保持信號大小寫一致（Ctl）。
	3.	聲明 output reg。
	4.	在 Testbench 初始化所有信號。

```


#### chatGPT testbench result:
![image](https://github.com/user-attachments/assets/de172171-0959-40fa-93c7-d85f8d4babe8)


### Program Counter 2 Source Code
```v
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

#### chatgpt testbench result
![image](https://github.com/user-attachments/assets/58f608e0-cccd-498a-afec-a18301e0e082)


### ConditionCodeSystem.v
#### Source Code
```v
module ConditionCodeSystem (cont, aluo, tcnd);
    input  [3:0] cont;   // instruction control line
    input  [8:0] aluo;  // ALU output (digit 8 is carry digit
    output tcnd;        // condition control output

    // DEBUG: need clock or not?
    always @(*) begin
        case (cont)
            4'b0001: tcnd = 4'b0001;
            4'b0010: tcnd = 4'b0001;
            4'b0011: tcnd = 4'b0001;
            4'b0100: tcnd = (aluo == 0) ? 4'b0001 : 4'b0000;
            4'b0101: tcnd = (aluo != 0) ? 4'b0001 : 4'b0000;
            4'b0110: tcnd = alou[8];
            4'b0111: tcnd = !alou[8];
            default: tcnd = 1'b0;
        endcase
    end
endmodule
```

#### chatgpt testbench result 1:
![image](https://github.com/user-attachments/assets/1a4d6c23-5f3c-4eb0-b097-ae0df4c8c6ff)

#### Revise prompt:
```
./top_module.v:27: error: Unknown module type: ConditionCode
2 error(s) during elaboration.
*** These modules were missing:
        ConditionCode referenced 1 times.
***
哪裡有錯
```
#### Reply:
```v
module ConditionCodeSystem (
    input [3:0] cont,   // Instruction control line
    input [8:0] aluo,   // ALU output (bit 8 is carry bit)
    output reg tcnd     // Condition control output
);

    always @(*) begin
        case (cont)
            4'b0001: tcnd = 1'b1;                      // RET: tcnd = 1
            4'b0010: tcnd = 1'b1;                      // JUMP: tcnd = 1
            4'b0011: tcnd = 1'b1;                      // CALL: tcnd = 1
            4'b0100: tcnd = (aluo == 9'b0) ? 1'b1 : 1'b0; // JZ: tcnd = 1 if ALU result is 0
            4'b0101: tcnd = (aluo != 9'b0) ? 1'b1 : 1'b0; // JNZ: tcnd = 1 if ALU result is non-zero
            4'b0110: tcnd = aluo[8];                   // JC: tcnd = 1 if carry flag is 1
            4'b0111: tcnd = ~aluo[8];                  // JNC: tcnd = 1 if carry flag is 0
            default: tcnd = 1'b0;                      // Default: tcnd = 0
        endcase
    end

endmodule
```
#### chatgpt testbench result 2:
![image](https://github.com/user-attachments/assets/e89facae-825d-40c4-8d54-32468b492671)


### Control System 1
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
```

#### chatgpt testbench result 1:
![image](https://github.com/user-attachments/assets/311d92f0-f105-4ea0-9c67-11f85803d257)

#### Revise prompt:
```
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

根據前面的control system 1 這一個哪裡寫錯了
```

#### Reply:
```v
module ControlSystem1 (
    input clk,
    input [3:0] cont,   // instruction control
    input jump2,        // jump control input
    
    output reg jump1,   // jump control output to program counter
    output reg ret1,    // return to main program control
    output reg push1,   // push input enable
    output reg wen1     // write in register enable
);

    always @(posedge clk) begin
        case (cont)
            4'b0001: begin
                jump1 = !jump2;
                ret1  = !jump2;
                push1 = 0;
                wen1  = 0;
            end
            4'b0010: begin
                jump1 = !jump2;
                ret1  = 0;
                push1 = 0;
                wen1  = 0;
            end
            4'b0011: begin
                jump1 = !jump2;
                ret1  = 0;
                push1 = !jump2;
                wen1  = 0;
            end
            4'b0100: begin
                jump1 = !jump2;
                ret1  = 0;
                push1 = 0;
                wen1  = 0;
            end
            4'b0101: begin
                jump1 = !jump2;
                ret1  = 0;
                push1 = 0;
                wen1  = 0;
            end
            4'b0110: begin
                jump1 = !jump2;
                ret1  = 0;
                push1 = 0;
                wen1  = 0;
            end
            4'b0111: begin
                jump1 = !jump2;
                ret1  = 0;
                push1 = 0;
                wen1  = 0;
            end
            default: begin
                if (cont[3] == 1) begin
                    jump1 = 0;
                    ret1  = 0;
                    push1 = 0;
                    wen1  = !jump2;
                end else begin
                    jump1 = 0;
                    ret1  = 0;
                    push1 = 0;
                    wen1  = 0;
                end
            end
        endcase
    end

endmodule
```
#### chatgpt testbench result 2:
![image](https://github.com/user-attachments/assets/7d9aeb58-0732-48b7-bd65-6e5dc086bb6b)

### Control System 2
#### Source Code
```v
module ControlSystem2 (clk, cont, tcnd, jump2, ret1, push2, wen2);
    input clk;
    input [3:0] cont;   // instruction control
    input tcnd;         // condition control

    output reg jump2;       // jump control output to program counter
    output ret1;        // return to main program control
    output reg push2;       // push input enable
    output reg wen2;        // write in register enable

    reg jump1, tempret, push1, wen1;

    assign temp1 = jump1 & tcnd & !jump2;

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

#### chatgpt testbench result:
![image](https://github.com/user-attachments/assets/9191e003-01fa-4e0f-924e-236e8a863e2c)


## Summary
In this project, we tested verilog coding using chatGPT and understood how powerful AI-driven coding could be. Only a few minutes or even a seconds are required to write out a functioning submodule if appropriate prompt was given. Comparing to hand-coding, it becomes clear that using AI to write programs is easier and significantly more efficient. However, we cannot ignore the possibility that the accuracy of chatGPT's code is a result of the near 100 students enrolled in this course being tasked on the same final project, thus training the AI to be specifically good at writing verilog code for submodules of this microcomputer architecture. Overall, this project gave us an insight on how AI can be used to assist (or even lead) verilog coding, and how much more efficient it is to write code with the right prompts instead of coding eveything by hand.
