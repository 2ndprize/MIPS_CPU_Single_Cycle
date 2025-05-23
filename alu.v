module alu(
    	input [31:0] x,
    	input [31:0] y,
    	input [3:0]  alu_op,
    	output [31:0] result,
	output [31:0] result2,
    	output of, cf, equal
);

	reg [31:0] temp_result;
	reg [31:0] temp_result2;
	reg [1:0] temp_of_cf;
	
	wire [31:0] arith_shift_result;
	wire [31:0] mul_result;
	wire [31:0] mul_cout;
	wire [31:0] div_result;
	wire [31:0] div_rem;
	wire [31:0] add_result;
	wire [1:0] add_of_cf;
	wire [31:0] sub_result;
	wire [1:0] sub_of_cf;
	wire com_result;
	wire [31:0] ext_com_result;

	arithmetic_right_shift ars (x, y[4:0], arith_shift_result);
	multiplier_32b mul1 (x, y, mul_result, mul_cout);
	divider_32b div1 (x, y, div_result, div_rem);
	adder_32b_of add1 (x, y, add_result, add_of_cf[1], add_of_cf[0]);
	subtractor_32b_of sub1 (x, y, sub_result, sub_of_cf[1], sub_of_cf[0]);
	comparator com1 (x, y, com_result);

	assign ext_com_result = {{31{1'b0}}, com_result};

	assign equal = (x == y) ? 1 : 0;

	always@(*)
	case(alu_op)
		4'd0 : temp_result = x << y[4:0];
		4'd1 : temp_result = arith_shift_result;
		4'd2 : temp_result = x >> y[4:0];
		4'd3 : temp_result = mul_result;
		4'd4 : temp_result = div_result;
		4'd5 : temp_result = add_result;
		4'd6 : temp_result = sub_result;
		4'd7 : temp_result = x & y;
		4'd8 : temp_result = x | y;
		4'd9 : temp_result = x ^ y;
		4'd10 : temp_result = ~(x | y);
		4'd11 : temp_result = ext_com_result;
		4'd12 : temp_result = ext_com_result;
		default : temp_result = 32'h0;
	endcase
	assign result = temp_result;
	
	always@(*)
	case(alu_op)
		4'd3 : temp_result2 = mul_cout;
		4'd4 : temp_result2 = div_rem;
		default : temp_result2 = 32'h0;
	endcase
	assign result2 = temp_result2;

	always@(*)
	case(alu_op)
		4'd5 : temp_of_cf = add_of_cf;
		4'd6 : temp_of_cf = sub_of_cf;
		default : temp_of_cf = 2'b0;
	endcase
	assign of = temp_of_cf[1];
	assign cf = temp_of_cf[2];

endmodule

module arithmetic_right_shift (
    input [31:0] in,
    input [4:0] shamt,
    output [31:0] out
);

    wire msb = in[31];
    wire [31:0] shifted = in >> shamt;
    wire [31:0] sign_fill = {32{msb}} << (32 - shamt);

    assign out = shifted | sign_fill;

endmodule

module multiplier_32b (
    	input  [31:0] x,
    	input  [31:0] y,
    	output [31:0] result,
    	output [31:0] carry_out
);

    	wire [63:0] product;

    	assign product = x * y;
    	assign result = product[31:0];
    	assign carry_out = product[63:32];

endmodule

module divider_32b (
    	input  [31:0] x,
    	input  [31:0] y,
    	output [31:0] quotient,
    	output [31:0] remainder
);

    	assign quotient  = (y == 0) ? x : x / y;
    	assign remainder = (y == 0) ? 0 : x % y;

endmodule

module adder_32b_of (
	input [31:0] x,
	input [31:0] y,
	output [31:0] result,
	output of, cf
);

	wire cout_32b, cout_1b;
	adder_32b add32b (x[30:0], y[30:0], cout_32b, result[30:0]);
	adder_1b add1b (x[31], y[31], cout_32b, cout_1b, result[31]);

	assign cf = cout_1b;
	assign of = cout_32b ^ cout_1b;

endmodule

module adder_32b (
	input [30:0] x,
	input [30:0] y,
	output cout,
	output [30:0] result
);

	assign {cout, result} = {1'b0, x} + {1'b0, y};

endmodule

module adder_1b (
	input x, y, cin,
	output cout, result
);

	assign result = x ^ y ^ cin;
	assign cout = x&y | x&cin | y&cin;

endmodule

module subtractor_32b_of (
	input [31:0] x,
	input [31:0] y,
	output [31:0] result,
	output of, cf
);

	wire bout_32b, bout_1b;
	subtractor_32b sub32b (x[30:0], y[30:0], bout_32b, result[30:0]);
	subtractor_1b sub1b (x[31], y[31], bout_32b, bout_1b, result[31]);

	assign cf = bout_1b;
	assign of = bout_32b ^ bout_1b;

endmodule

module subtractor_32b (
	input [30:0] x,
	input [30:0] y,
	output bout,
	output [30:0] result
);

	assign {bout, result} = {1'b0, x} - {1'b0, y};

endmodule

module subtractor_1b (
	input x, y, bin,
	output bout, result
);

	assign result = x ^ y ^ bin;
	assign bout = (~x & y) | ((~x | y) & bin);

endmodule

module comparator (
	input [31:0] x,
	input [31:0] y,
	output result
);

	wire x_sign, y_sign;
    	assign x_neg = x[31];
    	assign y_neg = y[31];

    	wire when_same_sign;
    	assign when_same_sign = (x < y);

    	assign result = (x_neg & ~y_neg) ? 1'b1 :
        		(~x_neg & y_neg) ? 1'b0 :
                    	when_same_sign;

endmodule
