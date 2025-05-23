`timescale 1ns / 1ps

module data_memory_tb;

  	// Inputs
  	reg clk;
  	reg memwrite;
  	reg memread;
  	reg [9:0] address;
  	reg [31:0] write_data;

  	// Output
  	wire [31:0] read_data;

  	// Instantiate the Unit Under Test (UUT)
 	 data_memory uut (
    	.clk(clk),
    	.memwrite(memwrite),
    	.memread(memread),
    	.address(address),
    	.write_data(write_data),
    	.read_data(read_data)
  	);

  	// Clock generation
  	always #5 clk = ~clk;

  	initial begin
    	// Initialize inputs
	    clk = 0;
	    memwrite = 0;
	    memread = 0;
	    address = 0;
	    write_data = 0;
	
	    // Write to address 10
	    #10;
	    address = 10;
	    write_data = 32'hDEADBEEF;
	    memwrite = 1;
	    #10;
	    memwrite = 0;
	
	    // Write to address 20
	    #10;
	    address = 20;
	    write_data = 32'hCAFEBABE;
	    memwrite = 1;
	    #10;
	    memwrite = 0;
	
	    // Read from address 10
	    #10;
	    address = 10;
	    memread = 1;
	    #10;
	    $display("Read from address 10: 0x%08X", read_data);
	    memread = 0;
	
	    // Read from address 20
	    #10;
	    address = 20;
	    memread = 1;
	    #10;
	    $display("Read from address 20: 0x%08X", read_data);
	    memread = 0;
	
	    // Read from an unwritten address (should return 0)
	    #10;
	    address = 100;
	    memread = 1;
	    #10;
	    $display("Read from address 100: 0x%08X", read_data);
	    memread = 0;
	
	    $finish;
	end
endmodule

