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

// version 2

module AddrCtrl (D0, D1, clk, ctl, addr);
    input  [3:0] D0, D1;
    input  clk, ctl;
    output reg [3:0] addr;

    reg [3:0] ir1, ir2;

    // Multiplexer controlled by ctl
    always @ (posedge clk) begin
        case (ctl)
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