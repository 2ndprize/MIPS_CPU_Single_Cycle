module instruction_memory (
    	input [8:0] address,
	input signal,
	input clk,
    	output reg [31:0] instr
);

    	reg [31:0] rom_upper [511:0];
	reg [31:0] rom_lower [511:0];
	reg [31:0] temp;

    	initial begin
        	$readmemh("benchmark.hex", rom_upper);
		$readmemh("exception_service.hex", rom_lower);
    	end

    	always @(*) begin
        if (signal)
        	instr = rom_lower[address];
        else
            	instr = rom_upper[address];
    	end

endmodule
