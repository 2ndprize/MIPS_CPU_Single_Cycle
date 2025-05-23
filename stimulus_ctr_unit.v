
`timescale 1ns / 1ps

module ctr_unit_tb;

    reg [5:0] op;
    reg [5:0] func;

    wire memread, memwrite, alusrc, jump, memtoreg, branch, regdst, regwrite;
    wire bneorbeq, isjal, zeroextend, readrs, readrt;
    wire issyscall, isjr, isshamt, iscop0;
    wire [3:0] aluop;

    // DUT instantiation
    ctr_unit dut (
        .op(op),
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
        $display("Time | OP     FUNC   | regwrite aluop isjr issyscall");
        $monitor("%4t | %b %b |    %b       %b    %b     %b", 
                 $time, op, func, regwrite, aluop, isjr, issyscall);

        // R-type instruction: ADD
        op = 6'b000000; func = 6'b100000; #10;

        // R-type instruction: JR
        op = 6'b000000; func = 6'b001000; #10;

        // R-type instruction: SYSCALL
        op = 6'b000000; func = 6'b001100; #10;

        // I-type instruction: LW
        op = 6'b100011; func = 6'b000000; #10;

        // I-type instruction: SW
        op = 6'b101011; func = 6'b000000; #10;

        // I-type instruction: ADDI
        op = 6'b001000; func = 6'b000000; #10;

        // J-type instruction: J
        op = 6'b000010; func = 6'b000000; #10;

        // J-type instruction: JAL
        op = 6'b000011; func = 6'b000000; #10;

        // Branch instruction: BEQ
        op = 6'b000100; func = 6'b000000; #10;

        // Branch instruction: BNE
        op = 6'b000101; func = 6'b000000; #10;

        // COP0 instruction
        op = 6'b010000; func = 6'b000000; #10;

        // Finish simulation
        $finish;
    end

endmodule
