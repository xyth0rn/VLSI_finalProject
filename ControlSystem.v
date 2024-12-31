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

    output jump2;       // jump control output to program counter
    output ret1;        // return to main program control
    output push2;       // push input enable
    output wen2;        // write in register enable

    // UNDONE
endmodule