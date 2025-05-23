`timescale 1ns/1ps

module alu_tb;

  	reg [31:0] x;
  	reg [31:0] y;
  	reg [3:0] alu_op;

  	wire [31:0] result;
  	wire [31:0] result2;
  	wire of, cf, equal;

  	integer i;

  	// DUT
  	alu dut (
    	.x(x),
    	.y(y),
    	.alu_op(alu_op),
    	.result(result),
    	.result2(result2),
    	.of(of),
    	.cf(cf),
    	.equal(equal)
  	);

  	initial begin
    	// Test values
    	x = 32'h00000004;
    	y = 32'h00000002;

    	$display("Starting ALU Test\n");

    	for (i = 0; i <= 12; i = i + 1) begin
      		alu_op = i[3:0];
      		#10;  // wait for combinational logic to settle

      		$display("alu_op = %2d | x = 0x%08h | y = 0x%08h | result = 0x%08h | result2 = 0x%08h | of = %b | cf = %b | equal = %b",
                	alu_op, x, y, result, result2, of, cf, equal);
    	end

    	$display("\nFinished ALU Test");
    	$stop;
  	end

endmodule

