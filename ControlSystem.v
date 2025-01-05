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
