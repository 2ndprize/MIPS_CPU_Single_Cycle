`timescale 1ns / 1ps

module statistics_tb;

    	reg clk;
    	reg reset;
    	reg [5:0] op;
    	wire [10:0] i, r, j, cnt_clk;

    	statistics uut (
        	.clk(clk),
	        .reset(reset),
	        .op(op),
	        .i(i),
	        .r(r),
	        .j(j),
		.cnt_clk(cnt_clk)
	    );

	    // Clock generation: 10ns period (100MHz)
	    always #5 clk = ~clk;
	
	    initial begin
	        $display("Time\tOPCODE\t\tI\tR\tJ");
	        $monitor("%0dns\t%06b\t%d\t%d\t%d", $time, op, i, r, j);
	
	        // Initialize
	        clk = 0;
	        reset = 1;
	        op = 6'b000000; // R-type (should increment R)
	        #10 reset = 0;
	
	        // Feed R-type
	        #10 op = 6'b000000;  // R
	        #10 op = 6'b000000;  // R
	
	        // Feed I-type instructions
	        #10 op = 6'b001000;  // addi (I)
	        #10 op = 6'b001101;  // ori (I)
	        #10 op = 6'b001100;  // andi (I)
	
	        // Feed J-type instructions
	        #10 op = 6'b000010;  // j (J)
	        #10 op = 6'b000011;  // jal (J)
	
	        // Mix again
	        #10 op = 6'b001000;  // addi (I)
	        #10 op = 6'b000000;  // R
	
	        // Stop simulation
	        #20 $finish;
	    end
	
endmodule

