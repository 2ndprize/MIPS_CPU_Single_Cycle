`timescale 1ns / 1ps

module cp0_tb;

	reg [31:0] inst;
	reg [31:0] pc_in;
	reg [31:0] d_in;
	reg expsrc0, expsrc1, expsrc2;
	reg clk, enable, reset;
	wire exregwrite, iseret, hasexp, expblock;
	wire [31:0] pc_out;
	wire [31:0] d_out;

	cp0 uut (
		.inst(inst),
		.pc_in(pc_in),
		.d_in(d_in),
		.expsrc0(expsrc0),
		.expsrc1(expsrc1),
		.expsrc2(expsrc2),
		.clk(clk),
		.enable(enable),
		.reset(reset),
		.exregwrite(exregwrite),
		.iseret(iseret),
		.hasexp(hasexp),
		.expblock(expblock),
		.pc_out(pc_out),
		.d_out(d_out)
	);

	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end

	always @(posedge clk) begin
		$display("T=%0t | exregwrite=%b iseret=%b hasexp=%b expblock=%b pc_out=%h d_out=%h",
			$time, exregwrite, iseret, hasexp, expblock, pc_out, d_out);
	end

	initial begin
		inst = 32'd0;
		pc_in = 32'hDEADBEEF;
		d_in = 32'hCAFEBABE;
		expsrc0 = 0;
		expsrc1 = 0;
		expsrc2 = 0;
		enable = 0;
		reset = 1;

		#10 reset = 0;

		// epc write
		inst[12:11] = 2'b00;
		enable = 1;
		d_in = 32'h11112222;
		#10 enable = 0;

		// status write (expblock ON)
		inst[12:11] = 2'b01;
		enable = 1;
		d_in = 32'h00000001;
		#10 enable = 0;

		// block write to unblock exp
		inst[12:11] = 2'b10;
		enable = 1;
		d_in = 32'h00000000;
		#10 enable = 0;

		// trigger exception expsrc0
		#10 expsrc0 = 1;
		pc_in = 32'hABCD1234;
		#10 expsrc0 = 0;

		// cause read
		inst[12:11] = 2'b11;
		#10;

		// test iseret pattern: func = 6'b001100, i.e. [5:0] = 001100
		inst[5:0] = 6'b001100;
		#10;

		// test exregwrite from inst[23] (should be ~inst[23])
		inst[23] = 0;
		#10 inst[23] = 1;
		#10;

		#20 $finish;
	end

endmodule

