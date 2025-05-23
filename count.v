module count(
	input clk,
	input rst,
	output reg out
);

	reg [2:0] cnt;

	always@(posedge clk or posedge rst) begin
	if(rst) begin
		out = 1'b0;
		cnt = 3'd0;
	end
	else if(cnt == 3'd5)
		out = ~out;

	cnt = cnt + 1;

	end
endmodule
