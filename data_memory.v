module data_memory (
	input clk,
   	input memwrite,
    	input memread,
    	input [9:0] address,
    	input [31:0] write_data,
    	output reg [31:0] read_data
);

    	reg [31:0] memory [1023:0];

	initial begin
    		$readmemh("memory_init.hex", memory);
	end

    	always@(*) begin
        	if (memread)
            		read_data <= memory[address];
        	else
            		read_data <= 32'b0;
    	end

    	always@(posedge clk) begin
        	if (memwrite)
            		memory[address] <= write_data;
    	end

endmodule
