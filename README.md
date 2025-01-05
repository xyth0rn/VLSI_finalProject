# VLSI_finalProject
## Project Overview
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

#### Result:
![image](https://github.com/user-attachments/assets/5bcb8709-9049-48e1-9a78-0ff4f29a8cbe)

### GPT_AddrCtrl.v

#### Prompt
```
依照這兩張的內容，幫我把address control 做出來 格式就是topmodule跟 內容
```
![image](https://github.com/user-attachments/assets/e1f37c99-f78b-454f-b0e5-67a95f82f017)
![image](https://github.com/user-attachments/assets/5f8073ed-4387-451c-8d0e-9608dca9c312)


#### Result:
![image](https://github.com/user-attachments/assets/70e72017-089a-4dc9-947d-a32f9df208c0)

#### Simulation

### GPT_Stack_System.v

#### Prompt 1:
```
這是什麼
```
![image](https://github.com/user-attachments/assets/8380317a-788f-4f6f-829b-995294ce6374)

#### Reply1
這是一個堆疊系統（Stack System）的設計描述，用於數位系統（特別是 CPU 或處理器設計）中處理資料的堆疊操作。堆疊是一種資料結構，遵循**後進先出（LIFO, Last In First Out）**的原則，常用於函數呼叫、資料暫存和控制流處理。

以下是這段文字和表格的要點解析：

1. 堆疊系統的基本結構

	•	輸入端（Counter Input）: Pcx[11...0]
堆疊系統的輸入資料，寬度為 12 bits。
	•	時脈（Clock）: Clk
控制操作的時脈信號。
	•	堆疊指標（Stack Pointer, SP）: Sp[11...0]
堆疊指標用來選擇當前操作的堆疊位址。由解碼器（Decoder）來控制指向具體的堆疊儲存器。
	•	寄存器（Registers）: Q0[11...0], Q1[11...0], Q2[11...0], Q3[11...0]
每個堆疊槽（stack slot）對應一個 12-bit 寄存器。
	•	多工器輸出（Multiplexer Output）: stk0[11...0]
多工器的輸出，根據堆疊指標選擇的資料。

2. 堆疊系統的寫入（Write-In）真值表

這個表描述了在不同控制信號下，數據如何被寫入堆疊系統的各個寄存器中。

Data in (Pcx)	Clk	Push	Sp	Q0	Q1	Q2	Q3
A	↑	1	0	A	unchange	unchange	unchange
A	↑	1	1	unchange	A	unchange	unchange
A	↑	1	2	unchange	unchange	A	unchange
A	↑	1	3	unchange	unchange	unchange	A
X	↑	0	X	unchange	unchange	unchange	unchange

	•	A: 代表輸入資料。
	•	↑: 表示時脈的上升沿。
	•	Push = 1: 啟用堆疊的推入操作，依據 Sp 將資料寫入對應的寄存器（Q0、Q1、Q2 或 Q3）。
	•	unchange: 表示寄存器值保持不變。
	•	Push = 0: 表示沒有進行寫入操作。

3. 堆疊系統的輸出真值表

這個表描述了當堆疊指標（SP）變化時，多工器輸出的內容。

Control (Sp)	Multiplexer Output (stk0)
0	Q0
1	Q1
2	Q2
3	Q3

多工器根據堆疊指標 Sp，輸出對應的寄存器內容到 stk0。

4. 堆疊指標（Stack Index）的真值表

這個表描述了堆疊指標 Sp 在 Push 和 Pop 操作時如何變化。

Clk	Pop	Push	Sp (Stack Index Output)
↑	1	X	sp + 1
↑	0	1	sp - 1
↑	0	0	UC (Unchanged)

	•	Pop = 1: 表示彈出操作，Sp 增加（向上移動）。
	•	Push = 1: 表示推入操作，Sp 減少（向下移動）。
	•	UC: 表示堆疊指標不變。

5. 示例

在設計時，這些表格幫助你明確如何根據控制信號操作堆疊。你可以用 Verilog 將這些行為實現。

Verilog 代碼範例（簡單實現 Stack System）

以下是基於上述表格的堆疊系統 Verilog 代碼範例：

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

說明：

	•	推入操作（Push）：依據堆疊指標將資料寫入對應寄存器。
	•	彈出操作（Pop）：更新堆疊指標以指向下一層。
	•	多工器（Multiplexer）：輸出目前指標指向的堆疊槽內容。

這樣的實現方式符合你提供的描述。如果需要進一步修改或解釋，可以繼續討論！

#### Prompt 2:
```
可以根據他的輸入幫我生一個testbench 嗎
```
#### Reply
以下是將之前的 Stack System 模組 和 Testbench 轉換成您所要求的格式，包含 probe 語法的完整程式碼。

1. Stack System 模組

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

2. Testbench (Top Module)

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

說明：

	1.	probe：
	•	在 StackSystem 模組中，我們對所有關鍵信號（如 Pcx、Push、Pop、stk0 和寄存器 Q0-Q3）都加上了 probe，便於在波形圖中觀察。
	2.	時脈（Clock）：
	•	透過 always #5 生成一個時脈周期為 10 的方波。
	3.	測試信號（Test Signals）：
	•	利用 initial 區塊模擬 Push 和 Pop 操作，觀察堆疊的行為。
	4.	訊息顯示（Display Messages）：
	•	在測試過程中，利用 $display 來輸出模擬時間點。
	5.	模擬停止（Finish Simulation）：
	•	利用 #50 $finish 結束模擬。

執行後，您可以在波形圖或模擬日誌中觀察堆疊系統的行為。
#### Result: 
![image](https://github.com/user-attachments/assets/f3ec9e30-8667-4aec-b618-f587022e94bf)

<img width="1030" alt="image" src="https://github.com/user-attachments/assets/d324c5b3-ea9f-439e-96a8-7f0acf6220b1" />

![image](https://github.com/user-attachments/assets/c842b443-a043-48ff-842c-8a153393075f)


### GPT_Program_counter1.v

#### Prompt
<img width="557" alt="image" src="https://github.com/user-attachments/assets/171bb723-1f91-4cf6-b4c1-ceddd37ee8e3" />

#### Result 1:
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
以下是 Program Counter 2 的設計和 Verilog 實現，基於您提供的 Program Counter 1 的邏輯：

1. Program Counter 2 模組

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

2. Testbench (Top Module)

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

說明：

	1.	ProgramCounter2 模組：
	•	根據 Jump 信號決定是否執行跳躍：
	•	Jump = 0：PC 只增加 1。
	•	Jump = 1：PC 跳到 PC + A1。
	2.	Testbench：
	•	產生一系列測試用例，模擬不同的 Jump 和 A1 組合。
	•	利用 probe 觀察所有關鍵信號。
	3.	時脈生成（Clock Generation）：
	•	使用 always #5 產生一個 10 時間單位的時脈信號，方便與其他模組同步測試。
	4.	模擬結果驗證：
	•	在波形圖中檢查 PCadd 的正確性，確保模組邏輯正確。

<img width="962" alt="image" src="https://github.com/user-attachments/assets/8d1f647c-9b17-4955-9771-eb90eb14b2f0" />

#### Result 1:
![image](https://github.com/user-attachments/assets/78f8ca16-8374-4c9b-9926-841be6097bb0)



### GPT_Condition_Code_system.v
#### Prompt:
<img width="967" alt="image" src="https://github.com/user-attachments/assets/2ce38452-fbb2-4891-82ab-ec7963c425d6" />
#### Result 1:
![image](https://github.com/user-attachments/assets/a8c5f5c5-8236-4bde-a8dc-84c720530d84)


### GPT_Control_System_1.v
#### Prompt:
<img width="1026" alt="image" src="https://github.com/user-attachments/assets/853bb2d4-9b60-4b14-9098-d213d5045026" />

#### Result 1:
直接pass
![image](https://github.com/user-attachments/assets/beab3276-8460-4bd3-82c5-965012f67734)

### GPT_Control_System_2.v
#### Prompt:
<img width="1002" alt="image" src="https://github.com/user-attachments/assets/49cbc41e-25e1-421f-9ea9-67ab93ea08a5" />
##### Result 1:
![image](https://github.com/user-attachments/assets/14893b6c-cae4-4824-a972-18dc9da1a369)

##### Revise Prompt:
直接把error 貼過去
<img width="955" alt="image" src="https://github.com/user-attachments/assets/14d4f6f3-1145-453b-afa0-b4b27eeab2b0" />

##### Result 2:
![image](https://github.com/user-attachments/assets/8936d770-1193-4962-b965-6e1730ab190c)

##### Revise Prompt:
直接把error 貼過去
<img width="965" alt="image" src="https://github.com/user-attachments/assets/59687dc4-99a1-4b7c-9553-642f551788df" />

##### Result 3:
![image](https://github.com/user-attachments/assets/8ad503c6-aa76-49eb-83eb-0ae8c608e0d1)



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

##### chatGPT testbench result 1:
![image](https://github.com/user-attachments/assets/2ba461fb-7786-404a-86e1-78ec4f186256)

##### Revise:
<img width="950" alt="image" src="https://github.com/user-attachments/assets/ba1778ad-a543-40ff-acfb-4fa80ada0794" />
##### chatGPT testbench result 2:
![image](https://github.com/user-attachments/assets/d45e9005-48ce-44d5-8f23-da5284ccf7ae)
##### Revise:
<img width="970" alt="image" src="https://github.com/user-attachments/assets/904739c6-a732-49f6-9d1e-7583bf5e76d1" />
##### chatGPT testbench result 3:
![image](https://github.com/user-attachments/assets/b6c1bf00-9aa3-4779-884f-c8fd5ed6d9f4)


### DataSelect.v
#### Submodule Structure
![image](https://github.com/user-attachments/assets/4d3005d7-e30c-47e8-9b2f-a0b6ac327611)

##### chatGPT testbench Result 1:
![image](https://github.com/user-attachments/assets/841ab3d8-1c0c-4527-9375-30684933cac7)
##### Revise prompt:
<img width="1007" alt="image" src="https://github.com/user-attachments/assets/c11ba746-3578-435c-8f21-c3475e642773" />

##### chatGPT testbench Result 2:
![image](https://github.com/user-attachments/assets/91d2ef59-5abe-4e19-a0c7-98d32beffc5f)


#### Submodule Truthtable

![image](https://github.com/user-attachments/assets/2e1bafbc-ab6e-4440-a034-9461f132b1c6)

### AddrCtrl.v
#### Submodule Structure
![image](https://github.com/user-attachments/assets/72f60ac4-9e6f-48d5-92dc-1fcecde44b8c)

#### Submodule Truthtable
![image](https://github.com/user-attachments/assets/e030016d-eb71-4203-96dc-715705f3ea88)

##### chatGPT testbench Result 1:
![image](https://github.com/user-attachments/assets/7d11cedd-19a2-4b19-aad3-d5c6688afba5)

##### Revise prompt
<img width="979" alt="image" src="https://github.com/user-attachments/assets/c14c9107-bb35-403c-a4a9-7afe5f4fb62e" />

##### chatGPT testbench Result 2:
![image](https://github.com/user-attachments/assets/e1c3f088-65e4-4cd2-a0a0-03860e25eba3)


### StackSys_StackIndex.v
#### Submodule Structure
![image](https://github.com/user-attachments/assets/ca90e25f-546e-469b-9ba9-137aff680581)
![image](https://github.com/user-attachments/assets/b4001f67-3581-4a37-88da-0f0d65d58cd0)

#### Submodule Truthtable
![image](https://github.com/user-attachments/assets/e43a7865-b468-4d7f-a301-030674cbbe2b)
![image](https://github.com/user-attachments/assets/28c4ba18-8160-40d5-bf98-420368589b29)

##### chatGPT testbench Result
![image](https://github.com/user-attachments/assets/7a436c3b-1762-476d-87ad-94523dfc1647)

### ProgramCounter.v

#### Submodule Structure
![image](https://github.com/user-attachments/assets/8509ff97-1c65-461d-88ef-2d4d9a51dd20)
![image](https://github.com/user-attachments/assets/ead66b93-d575-4b50-bb21-2b33dcc00a4f)

#### Submodule Truthtable

#### Program Counter 1
![image](https://github.com/user-attachments/assets/8d568e4b-de02-4ac9-a3ee-a470b0d9e200)
chatGPT revise:
<img width="974" alt="image" src="https://github.com/user-attachments/assets/9a6d3f8f-3a75-4a37-958b-e509e2a08291" />

##### chatGPT testbench result:
![image](https://github.com/user-attachments/assets/de172171-0959-40fa-93c7-d85f8d4babe8)


#### Program Counter 2
![image](https://github.com/user-attachments/assets/0b161ca9-4bd7-48dd-bacd-d6dc58314c33)
![image](https://github.com/user-attachments/assets/44dce9bc-f450-4326-ba50-874eef1af144)

##### chatgpt testbench result
![image](https://github.com/user-attachments/assets/58f608e0-cccd-498a-afec-a18301e0e082)


### ConditionCodeSystem.v
#### Submodule Structure
![image](https://github.com/user-attachments/assets/daa9612f-792e-4d0f-b824-b7b6819510a4)

#### Submodule Truthtable
![image](https://github.com/user-attachments/assets/36963ccf-81d4-406e-a5be-fc6c806c9c68)

### ControlSystem.v
#### Submodule Structure
#### Control System 1
![image](https://github.com/user-attachments/assets/de9a851d-df08-4c1e-84ea-f02a8d3e8938)

##### chatgpt testbench result 1:
![image](https://github.com/user-attachments/assets/311d92f0-f105-4ea0-9c67-11f85803d257)
revise:
<img width="975" alt="image" src="https://github.com/user-attachments/assets/b8bdca3c-2341-4113-81b3-1cecd52be320" />
chatgpt testbench result 2:
![image](https://github.com/user-attachments/assets/7d9aeb58-0732-48b7-bd65-6e5dc086bb6b)


#### Control System 2
![image](https://github.com/user-attachments/assets/62afad9f-77d8-4056-b95d-57006d3a9e7c)

#### Submodule Truthtable
![image](https://github.com/user-attachments/assets/0b07b666-a255-45ee-8626-95d108c7cdfe)
