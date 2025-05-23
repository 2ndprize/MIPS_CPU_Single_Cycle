module pc(
	input [31:0] present_pc,
	input [31:0] extend_inst,
	input [31:0] instr,
	input [31:0] regfile_r1,
	input [31:0] cp0_pcout,
	input equal, bneorbeq, branch, jump, isjr, iseret, iscop0, hasexp,
	input clk,
	output [31:0] final_pc);

	wire [31:0] pc_4;
	wire [31:0] logic_left_pc;
	wire [31:0] branch_pc;
	wire [31:0] temp_jump_pc;
	wire [31:0] jump_pc;
	wire [31:0] jr_pc;
	wire [31:0] eret_or_exp_pc;

	assign pc_4 = present_pc + 32'd4;
	assign logic_left_pc = extend_inst << 2;
	assign branch_pc = ((equal ^ bneorbeq)&branch) ? (pc_4 + logic_left_pc) : pc_4;

	assign temp_jump_pc = {pc_4[31:28], instr[25:0], 2'b00};
	assign jump_pc = (~jump) ? branch_pc : temp_jump_pc;
	
	assign jr_pc = (isjr) ? regfile_r1 : jump_pc;

	assign eret_or_exp_pc = (iseret & iscop0) ? cp0_pcout : jr_pc;

	assign final_pc = (~hasexp) ? eret_or_exp_pc : 32'h00000800;

endmodule
