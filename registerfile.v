module registerfile(
	input [4:0] reg1_in,
	input [4:0] reg2_in,
	input [4:0] rw,
	input [31:0] write_data,
	input we, clk,
	output [31:0] reg1_out,
	output [31:0] reg2_out,
	output [31:0] a0,
	output [31:0] v0
);
	
	wire [3:0] dmx_ena;
	dmx_1to4 dmx0(
		.ena(we),
		.sel(rw[4:3]),
		.out(dmx_ena)
	);

	wire [7:0] sel_reg0;
	dmx_1to8 dmx1(
		.ena(dmx_ena[0]),
		.sel(rw[2:0]),
		.out(sel_reg0)
	);

	wire [7:0] sel_reg1;
	dmx_1to8 dmx2(
		.ena(dmx_ena[1]),
		.sel(rw[2:0]),
		.out(sel_reg1)
	);

	wire [7:0] sel_reg2;
	dmx_1to8 dmx3(
		.ena(dmx_ena[2]),
		.sel(rw[2:0]),
		.out(sel_reg2)
	);

	wire [7:0] sel_reg3;
	dmx_1to8 dmx4(
		.ena(dmx_ena[3]),
		.sel(rw[2:0]),
		.out(sel_reg3)
	);

	//Register
	wire [31:0] reg_file [31:0];

	reg_32b reg_file0(.datain(write_data), .ena(sel_reg0[0]), .dataout(reg_file[0]));
	reg_32b reg_file1(.datain(write_data), .clk(clk), .ena(sel_reg0[1]), .dataout(reg_file[1]));
	reg_32b reg_file2(.datain(write_data), .clk(clk), .ena(sel_reg0[2]), .dataout(reg_file[2]));
	reg_32b reg_file3(.datain(write_data), .clk(clk), .ena(sel_reg0[3]), .dataout(reg_file[3]));
	reg_32b reg_file4(.datain(write_data), .clk(clk), .ena(sel_reg0[4]), .dataout(reg_file[4]));
	reg_32b reg_file5(.datain(write_data), .clk(clk), .ena(sel_reg0[5]), .dataout(reg_file[5]));
	reg_32b reg_file6(.datain(write_data), .clk(clk), .ena(sel_reg0[6]), .dataout(reg_file[6]));
	reg_32b reg_file7(.datain(write_data), .clk(clk), .ena(sel_reg0[7]), .dataout(reg_file[7]));

	reg_32b reg_file8(.datain(write_data), .clk(clk), .ena(sel_reg1[0]), .dataout(reg_file[8]));
	reg_32b reg_file9(.datain(write_data), .clk(clk), .ena(sel_reg1[1]), .dataout(reg_file[9]));
	reg_32b reg_file10(.datain(write_data), .clk(clk), .ena(sel_reg1[2]), .dataout(reg_file[10]));
	reg_32b reg_file11(.datain(write_data), .clk(clk), .ena(sel_reg1[3]), .dataout(reg_file[11]));
	reg_32b reg_file12(.datain(write_data), .clk(clk), .ena(sel_reg1[4]), .dataout(reg_file[12]));
	reg_32b reg_file13(.datain(write_data), .clk(clk), .ena(sel_reg1[5]), .dataout(reg_file[13]));
	reg_32b reg_file14(.datain(write_data), .clk(clk), .ena(sel_reg1[6]), .dataout(reg_file[14]));
	reg_32b reg_file15(.datain(write_data), .clk(clk), .ena(sel_reg1[7]), .dataout(reg_file[15]));

	reg_32b reg_file16(.datain(write_data), .clk(clk), .ena(sel_reg2[0]), .dataout(reg_file[16]));
	reg_32b reg_file17(.datain(write_data), .clk(clk), .ena(sel_reg2[1]), .dataout(reg_file[17]));
	reg_32b reg_file18(.datain(write_data), .clk(clk), .ena(sel_reg2[2]), .dataout(reg_file[18]));
	reg_32b reg_file19(.datain(write_data), .clk(clk), .ena(sel_reg2[3]), .dataout(reg_file[19]));
	reg_32b reg_file20(.datain(write_data), .clk(clk), .ena(sel_reg2[4]), .dataout(reg_file[20]));
	reg_32b reg_file21(.datain(write_data), .clk(clk), .ena(sel_reg2[5]), .dataout(reg_file[21]));
	reg_32b reg_file22(.datain(write_data), .clk(clk), .ena(sel_reg2[6]), .dataout(reg_file[22]));
	reg_32b reg_file23(.datain(write_data), .clk(clk), .ena(sel_reg2[7]), .dataout(reg_file[23]));

	reg_32b reg_file24(.datain(write_data), .clk(clk), .ena(sel_reg3[0]), .dataout(reg_file[24]));
	reg_32b reg_file25(.datain(write_data), .clk(clk), .ena(sel_reg3[1]), .dataout(reg_file[25]));
	reg_32b reg_file26(.datain(write_data), .clk(clk), .ena(sel_reg3[2]), .dataout(reg_file[26]));
	reg_32b reg_file27(.datain(write_data), .clk(clk), .ena(sel_reg3[3]), .dataout(reg_file[27]));
	reg_32b reg_file28(.datain(write_data), .clk(clk), .ena(sel_reg3[4]), .dataout(reg_file[28]));
	reg_32b reg_file29(.datain(write_data), .clk(clk), .ena(sel_reg3[5]), .dataout(reg_file[29]));
	reg_32b reg_file30(.datain(write_data), .clk(clk), .ena(sel_reg3[6]), .dataout(reg_file[30]));
	reg_32b reg_file31(.datain(write_data), .clk(clk), .ena(sel_reg3[7]), .dataout(reg_file[31]));
	
	assign reg1_out = reg_file[reg1_in];
	assign reg2_out = reg_file[reg2_in];
	
	assign a0 = reg_file[4];
	assign v0 = reg_file[2];

endmodule

module dmx_1to4 (
	input wire ena,
    	input wire [1:0] sel,
    	output reg [3:0] out
);

    	always @(*) begin
        if (ena) begin
        case (sel)
        	2'b00: out = 4'b0001;
                2'b01: out = 4'b0010;
                2'b10: out = 4'b0100;
                2'b11: out = 4'b1000;
        endcase
        end else begin
            	out = 4'b0000;
        end
    	end

endmodule

module dmx_1to8 (
    	input wire ena,
    	input wire [2:0] sel,
    	output reg [7:0] out
);

    	always @(*) begin
        if (ena) begin
        case (sel)
        	3'b000: out = 8'b00000001;
                3'b001: out = 8'b00000010;
		3'b010: out = 8'b00000100;
		3'b011: out = 8'b00001000;
		3'b100: out = 8'b00010000;
		3'b101: out = 8'b00100000;
		3'b110: out = 8'b01000000;
		3'b111: out = 8'b10000000;
        endcase
        end else begin
        	out = 8'b00000000;
        end
    	end

endmodule

module reg_32b (
    	input wire [31:0] datain,
    	input wire clk, ena,
    	output reg [31:0] dataout
);
	initial begin
		dataout = 32'b0;
	end

	always @(posedge clk) begin
    		if (ena)
        	dataout <= datain;
	end
endmodule
