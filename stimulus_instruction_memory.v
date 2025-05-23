`timescale 1ns/1ps

module instruction_memory_tb;
	
    	reg [8:0] address;
    	reg signal;
    	reg clk;
    	wire [31:0] instr;

    	// Instantiate the DUT (Device Under Test)
    	instruction_memory dut (
    	    .address(address),
    	    .signal(signal),
    	    .clk(clk),
    	    .instr(instr)
    	);

    	// Clock generation
    	always #5 clk = ~clk;
	
    	initial begin
    	    // Initialize signals
    	    clk = 0;
    	    address = 0;
    	    signal = 0;
	
    	    // Wait for ROM to be initialized
    	    #10;
	
    	    // Test with signal = 0 (read from rom_upper)
    	    $display("Reading from rom_upper:");
    	    signal = 0;
    	    address = 9'd0; #10;
    	    $display("addr = %d, instr = %h", address, instr);
	
    	    address = 9'd1; #10;
    	    $display("addr = %d, instr = %h", address, instr);
	
    	    address = 9'd2; #10;
    	    $display("addr = %d, instr = %h", address, instr);
	
    	    // Test with signal = 1 (read from rom_lower)
    	    $display("Reading from rom_lower:");
    	    signal = 1;
    	    address = 9'd0; #10;
    	    $display("addr = %d, instr = %h", address, instr);
	
    	    address = 9'd1; #10;
    	    $display("addr = %d, instr = %h", address, instr);
	
    	    address = 9'd2; #10;
    	    $display("addr = %d, instr = %h", address, instr);
	
    	    // Done
    	    $finish;
    	end
	
endmodule

