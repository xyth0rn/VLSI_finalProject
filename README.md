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
Result 1:
![image](https://github.com/user-attachments/assets/5bcb8709-9049-48e1-9a78-0ff4f29a8cbe)

### GPT_AddrCtrl.v
#### Prompt
```
for a microcomputer architecture, write a verilog code address control system submodule GPT_AddrCtrl.v that has the structure
and truth table of the following images. Also write a testbench GPT_AddrCtrl_tb.v for this submodule.
```
![image](https://github.com/user-attachments/assets/ca63657e-c050-4139-9080-ec6c48dd1f9a)

#### Result

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


### GPT_Program_counter1.v

#### Prompt
<img width="557" alt="image" src="https://github.com/user-attachments/assets/171bb723-1f91-4cf6-b4c1-ceddd37ee8e3" />

#### Result 1:
![image](https://github.com/user-attachments/assets/cc1f5a5c-79bb-4793-8de5-1e5943c1065b)


### GPT_Program_counter2.v

#### Prompt:
![image](https://github.com/user-attachments/assets/d2009493-b769-48e1-94cf-a49bf367fce3)

發現接腳是錯的

<img width="962" alt="image" src="https://github.com/user-attachments/assets/8d1f647c-9b17-4955-9771-eb90eb14b2f0" />

#### Result 1:
![image](https://github.com/user-attachments/assets/78f8ca16-8374-4c9b-9926-841be6097bb0)

### GPT_Control_System_1.v
#### Prompt:
<img width="1026" alt="image" src="https://github.com/user-attachments/assets/853bb2d4-9b60-4b14-9098-d213d5045026" />

#### Result 1:
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
