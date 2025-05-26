`timescale 1ns/1ps

module single_cycle_cpu_tb;

	reg external_clk, reset;
	reg expsrc0, expsrc1, expsrc2;
	wire [10:0] cnt_i, cnt_r, cnt_j, cnt_clk;
	wire [31:0] hex;

	// 1clk = 10ns
	always #5 external_clk = ~external_clk;

	initial begin 
		external_clk = 0;
		reset = 1;
		expsrc0 = 0; 
		expsrc1 = 0;
		expsrc2 = 0;

		#20 reset = 0;

		#17000 $finish;
	end

	single_cycle_cpu my_cpu(
		.external_clk(external_clk),
		.reset(reset),
		.expsrc0(expsrc0),
		.expsrc1(expsrc1),
		.expsrc2(expsrc2),
		.cnt_i(cnt_i),
		.cnt_r(cnt_r),
		.cnt_j(cnt_j),
		.cnt_clk(cnt_clk),
		.hex(hex)
	);

endmodule

