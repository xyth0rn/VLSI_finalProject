// stack system
// stack is used for storing return addresses and temporary data. Stack Index tracks the top of the stack, enabling push and pop operations.
module stackSys (pcx, clk, push, sp, stk0);
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

module stackIndex (clk, push, pop, sp);
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