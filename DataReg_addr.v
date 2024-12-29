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