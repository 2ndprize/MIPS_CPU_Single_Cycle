module sign_extend(
	input [15:0] inst,
	input zero_extend,
	output [31:0] extend_inst);

	wire [31:0] temp1, temp2;

	assign temp1 = {{16{inst[15]}}, inst};
	assign temp2 = {{16{1'b0}}, inst};

	assign extend_inst = (zero_extend) ? temp2 : temp1;

endmodule
