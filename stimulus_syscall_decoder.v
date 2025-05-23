`timescale 1ns / 1ps

module syscall_decoder_tb;

	reg [31:0] v0;
	reg [31:0] a0;
	reg enable;
	reg clk;
	reg rst;
	wire halt;
	wire [31:0] hex;

	syscall_decoder uut (
		.v0(v0),
		.a0(a0),
		.enable(enable),
		.clk(clk),
		.rst(rst),
		.halt(halt),
		.hex(hex)
	);

	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end

	always @(posedge clk) begin
		$display("T=%0t | v0=%h | a0=%h | enable=%b | halt=%b | hex=%h", $time, v0, a0, enable, halt, hex);
	end

	initial begin
		v0 = 0;
		a0 = 0;
		enable = 0;
		rst = 1;

		#10 rst = 0;

		v0 = 32'd1;
		a0 = 32'h12345678;
		enable = 1;
		#10;

		v0 = 32'd10;
		a0 = 32'hDEADBEEF;
		#10;

		enable = 0;
		#10;

		rst = 1;
		#10 rst = 0;

		#20 $finish;
	end

endmodule
