module cp0(
	input [31:0] inst,
	input [31:0] pc_in,
	input [31:0] d_in,
	input expsrc0, expsrc1, expsrc2,
	input clk, enable, reset,
	output exregwrite, iseret, hasexp, expblock,
	output [31:0] pc_out,
	output reg [31:0] d_out
);

	wire [1:0] sel;
	wire [2:0] blocksrc;
	wire out_q1, out_q2;

	// Signal Decoding
	assign exregwrite = ~inst[23];
	assign sel = inst[12:11];
	assign iseret = ~inst[5] & inst[4] & inst[3] & ~inst[2] & ~inst[1] & ~inst[0];


	// Exception Signals
	wire [2:0] expsrc;
	wire expclick;
	assign expsrc[0] = (blocksrc[0]) ? 0 : expsrc0;
	assign expsrc[1] = (blocksrc[1]) ? 0 : expsrc1;
	assign expsrc[2] = (blocksrc[2]) ? 0 : expsrc2;
	assign expclick = (|expsrc) & (~expblock);

	counter_bit cnt1 (
		.clk(expclick),
		.clr(out_q2),
		.q(out_q1)
	);

	assign hasexp = clk & out_q1;

	counter_bit cnt2 (
		.clk(hasexp),
		.clr(~out_q1),
		.q(out_q2)
	);


	// Registers
	wire dmx_epc, dmx_status, dmx_block;
	wire jud_epc, jud_status, jud_block;
	wire enable_exregwrite;
	wire [31:0] epc_in;
	wire [31:0] epc_out;
	wire [31:0] status_out;
	wire [31:0] block_out;
	wire [31:0] cause_in;
	wire [31:0] cause_out;

	assign enable_exregwrite = enable & (~exregwrite);
	
	demux_1to4 u_demux(
		.data(1'b1),
		.sel(sel),
		.y0(dmx_epc),
		.y1(dmx_status),
		.y2(dmx_block)
	);
	
	assign jud_epc = hasexp | (enable_exregwrite & dmx_epc);
	assign jud_status = enable_exregwrite & dmx_status;
	assign jud_block = enable_exregwrite & dmx_block;

	assign epc_in = (~hasexp) ? d_in : pc_in;
	
	cp0_reg epc (
		.data(epc_in),
		.enable(jud_epc),
		.clk(clk),
		.clr(reset),
		.outdata(epc_out)
	);

	cp0_reg status (
		.data(d_in),
		.enable(jud_status),
		.clk(clk),
		.clr(reset),
		.outdata(status_out)
	);
	assign expblock = status_out[0];

	cp0_reg block (
		.data(d_in),
		.enable(jud_block),
		.clk(clk),
		.clr(reset),
		.outdata(block_out)
	);
	assign blocksrc[0] = block_out[0];
	assign blocksrc[1] = block_out[1];
	assign blocksrc[2] = block_out[2];

	tristate_buffer u_tri (expsrc0, expsrc1, expsrc2, cause_in);
	cp0_reg cause (
		.data(cause_in),
		.clk(expclick),
		.clr(reset),
		.outdata(cause_out)
	);
	
	assign pc_out = epc_out;
	always@(*) begin
	case (sel)
		2'b00 : d_out = epc_out;
		2'b01 : d_out = status_out;
		2'b10 : d_out = block_out;
		2'b00 : d_out = cause_out;
		default : d_out = 32'b0;
	endcase
	end

endmodule

module counter_bit (
    	input wire clk,
    	input wire clr,
    	output reg q
);

    	always @(posedge clk or posedge clr) begin
        	if (clr)
			q = 1'b0;
        	else 
			q = 1'b1;
        end

endmodule

module cp0_reg(
	input [31:0] data,
	input enable, clk, clr,
	output reg [31:0] outdata
);

	always@(posedge clk or posedge clr) begin
		if(clr) 
			outdata <= 32'd0;
		else if (enable) 
			outdata <= data;
	end

endmodule

module demux_1to4 (
    	input data,
    	input [1:0] sel,

    	output y0, y1, y2, y3
);

    	assign y0 = (sel == 2'b00) ? data : 1'b0;
    	assign y1 = (sel == 2'b01) ? data : 1'b0;
    	assign y2 = (sel == 2'b10) ? data : 1'b0;
    	assign y3 = (sel == 2'b11) ? data : 1'b0;

endmodule

module tristate_buffer (
    input en0, en1, en2,
    output wire [31:0] cause_in
);

    assign cause_in = en0 ? 32'h00000001 :
                      en1 ? 32'h00000003 :
                      en2 ? 32'h00000007 :
                      32'bz;

endmodule
