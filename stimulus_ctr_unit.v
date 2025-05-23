`timescale 1ns / 1ps

module ctr_unit_tb;

  	reg [5:0] op;
    	reg [5:0] func;

    	wire memread, memwrite, alusrc, jump, memtoreg, branch, regdst, regwrite;
    	wire bneorbeq, isjal, zeroextend, readrs, readrt;
    	wire issyscall, isjr, isshamt, iscop0;
    	wire [3:0] aluop;

  	ctr_unit dut (.op(op),
        	.func(func),
        	.memread(memread),
        	.memwrite(memwrite),
        	.alusrc(alusrc),
        	.jump(jump),
        	.memtoreg(memtoreg),
        	.branch(branch),
        	.regdst(regdst),
        	.regwrite(regwrite),
        	.bneorbeq(bneorbeq),
        	.isjal(isjal),
        	.zeroextend(zeroextend),
        	.readrs(readrs),
        	.readrt(readrt),
        	.issyscall(issyscall),
        	.isjr(isjr),
        	.isshamt(isshamt),
        	.iscop0(iscop0),
        	.aluop(aluop)
    	);


  	initial begin
  		$display("Time |    op    func  | regwrite regdst memread memwrite memtoreg alusrc branch bne/beq jump isjal zeroext readrs readrt issyscall isjr isshamt iscop0 aluop");
  		$monitor("%4dns | %b %b |     %b       %b       %b       %b        %b       %b      %b      %b      %b     %b      %b      %b      %b        %b      %b     %b      %b   %b",
           		$time, op, func, regwrite, regdst, memread, memwrite, memtoreg, alusrc,
           		branch, bneorbeq, jump, isjal, zeroextend, readrs, readrt,
           		issyscall, isjr, isshamt, iscop0, aluop);

    		// lw (op = 100011)
    		#10 op = 6'b100011; func = 6'bxxxxxx;

    		// sw (op = 101011)
    		#10 op = 6'b101011; func = 6'bxxxxxx;
	
    		// add (R-type, func = 100000)
    		#10 op = 6'b000000; func = 6'b100000;

    		// sub (func = 100010)
    		#10 func = 6'b100010;

    		// and (func = 100100)
    		#10 func = 6'b100100;

    		// or (func = 100101)
    		#10 func = 6'b100101;

    		// jr (func = 001000)
    		#10 func = 6'b001000;

    		// syscall (func = 001100)
    		#10 func = 6'b001100;

    		// sll (func = 000000)
    		#10 func = 6'b000000;

    		// beq (op = 000100)
    		#10 op = 6'b000100; func = 6'bxxxxxx;

    		// bne (op = 000101)
    		#10 op = 6'b000101;

    		// j (op = 000010)
    		#10 op = 6'b000010;

    		// jal (op = 000011)
    		#10 op = 6'b000011;

    		// andi (op = 001100)
    		#10 op = 6'b001100;

    		// ori (op = 001101)
    		#10 op = 6'b001101;

    		// mfc0 / mtc0 (cop0, op = 010000)
    		#10 op = 6'b010000;
	
    		#10 $finish;
  	end

endmodule
