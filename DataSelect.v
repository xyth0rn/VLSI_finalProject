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