`timescale 1ns/1ps

module pc_tb;
	
    	reg clk;
    	reg [31:0] present_pc;
    	reg [31:0] extend_inst;
    	reg [31:0] instr;
    	reg [31:0] regfile_r1;
    	reg [31:0] cp0_pcout;
    	reg equal, bneorbeq, branch, jump, isjr, iseret, iscop0, hasexp;

    	wire [31:0] next_pc;

    	// Instantiate the Unit Under Test (UUT)
    	pc uut (
        	.present_pc(present_pc),
        	.extend_inst(extend_inst),
        	.instr(instr),
        	.regfile_r1(regfile_r1),
        	.cp0_pcout(cp0_pcout),
        	.equal(equal),
        	.bneorbeq(bneorbeq),
        	.branch(branch),
        	.jump(jump),
        	.isjr(isjr),
        	.iseret(iseret),
        	.iscop0(iscop0),
        	.hasexp(hasexp),
        	.clk(clk),
        	.final_pc(next_pc)
    	);

    	// Clock generation: toggle every 5 ns
    	always #5 clk = ~clk;

    	// Update present_pc at every positive edge of the clock
    	always @(posedge clk) begin
        	present_pc <= next_pc;
    	end

    	// Test sequence
    	initial begin
        	$display("Time\t\tclk\tpresent_pc\tnext_pc");
        	$monitor("%0t\t%b\t%h\t%h", $time, clk, present_pc, next_pc);

        	// Initialize inputs
        	clk = 0;
        	present_pc = 32'h00000000;
        	extend_inst = 32'h00000004;  // Simulated branch offset
        	instr = 32'h0800000A;        // Example J-type instruction
        	regfile_r1 = 32'h00000000;
        	cp0_pcout = 32'h00000400;
        	equal = 0;
        	bneorbeq = 0;
        	branch = 0;
        	jump = 0;
        	isjr = 0;
        	iseret = 0;
        	iscop0 = 0;
        	hasexp = 0;
	
        	// Wait and observe normal PC increment
        	#20;
	
        	// Enable jump signal
        	jump = 1;
        	#10;
        	jump = 0;
	
        	// Enable branch (BEQ)
        	branch = 1;
        	equal = 1;
        	bneorbeq = 0;
        	#10;
        	branch = 0;
	
        	// Enable exception
        	hasexp = 1;
        	#10;
        	hasexp = 0;
	
        	// Enable ERET (exception return)
        	iseret = 1;
        	iscop0 = 1;
        	#10;
        	iseret = 0;
        	iscop0 = 0;
	
        	// Enable JR (jump register)
        	isjr = 1;
        	regfile_r1 = 32'h00000020;
        	#10;
        	isjr = 0;
	
        	// Run a few more cycles
        	#50;
	
        	$finish;
    	end

endmodule

