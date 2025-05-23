module statistics(
    	input clk,
    	input reset,
    	input [5:0] op,
    	output reg [10:0] i,
    	output reg [10:0] r,
    	output reg [10:0] j,
	output reg [10:0] cnt_clk
);

    	wire is_i, is_r, is_j;

   	// R-type
   	wire [9:0] judge_i;
    	and(judge_i[0], op[5], ~op[4], ~op[3], ~op[2], op[1], op[0]);
    	and(judge_i[1], op[5], ~op[4], op[3], ~op[2], op[1], op[0]);
    	and(judge_i[2], ~op[5], ~op[4], ~op[3], op[2], ~op[1], op[0]);
    	and(judge_i[3], ~op[5], ~op[4], ~op[3], op[2], ~op[1], ~op[0]);
    	and(judge_i[4], ~op[5], ~op[4], op[3], op[2], ~op[1], ~op[0]);
    	and(judge_i[5], ~op[5], ~op[4], op[3], op[2], ~op[1], op[0]);
    	and(judge_i[6], ~op[5], ~op[4], op[3], ~op[2], op[1], ~op[0]);
    	and(judge_i[7], ~op[5], ~op[4], op[3], ~op[2], ~op[1], ~op[0]);
    	and(judge_i[8], ~op[5], ~op[4], op[3], ~op[2], ~op[1], op[0]);
    	and(judge_i[9], ~op[5], ~op[4], op[3], ~op[2], ~op[1], ~op[0]);
    	assign is_i = |judge_i;

    	// R-type
    	assign is_r = ~op[5] & ~op[4] & ~op[3] & ~op[2] & ~op[1] & ~op[0];

    	// J-type
    	wire [1:0] judge_j;
    	and(judge_j[0], ~op[5], ~op[4], ~op[3], ~op[2], op[1], ~op[0]);
    	and(judge_j[1], ~op[5], ~op[4], ~op[3], ~op[2], op[1], op[0]);
    	assign is_j = |judge_j;
	
    	always @(posedge clk or posedge reset) begin
    		if (reset) begin
    	        	i <= 0;
    	        	r <= 0;
    	        	j <= 0;
			cnt_clk <= 0;
    		end else begin
			cnt_clk <= cnt_clk + 1;
    	    		if (is_i) i <= i + 1;
    	        	if (is_r) r <= r + 1;
    	        	if (is_j) j <= j + 1;
    	    	end
    	end

endmodule

