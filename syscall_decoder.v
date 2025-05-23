module syscall_decoder (
    	input wire [31:0] v0,
	input wire [31:0] a0,
    	input wire enable,
    	input wire clk,
	input rst,
    	output wire halt,
    	output reg [31:0] hex
);

	assign halt = (enable) ? (v0 == 32'h0000000a) : 1'b0;

   	always @(posedge clk or posedge rst) begin
		if (rst)
			hex <= 32'b0;
		else if (enable) 
			hex <= a0;
	end

endmodule
