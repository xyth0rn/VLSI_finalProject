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