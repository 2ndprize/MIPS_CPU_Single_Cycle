module cp0_tb;

    reg [31:0] inst;
    reg [31:0] pc_in;
    reg [31:0] d_in;
    reg expsrc0, expsrc1, expsrc2;
    reg clk, enable;
    wire exregwrite, iseret, hasexp, expblock;
    wire [31:0] pc_out;
    wire [31:0] d_out;

    // Instantiate cp0
    cp0 uut (
        .inst(inst),
        .pc_in(pc_in),
        .d_in(d_in),
        .expsrc0(expsrc0),
        .expsrc1(expsrc1),
        .expsrc2(expsrc2),
        .clk(clk),
        .enable(enable),
        .exregwrite(exregwrite),
        .iseret(iseret),
        .hasexp(hasexp),
        .expblock(expblock),
        .pc_out(pc_out),
        .d_out(d_out)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // Initial values
        inst = 32'b0;
        pc_in = 32'h1000_0000;
        d_in = 32'hDEAD_BEEF;
        expsrc0 = 0;
        expsrc1 = 0;
        expsrc2 = 0;
        enable = 0;

        #10;

        // Write to Status register (sel = 01)
        inst[12:11] = 2'b01;
        enable = 1;
        #10 enable = 0;

        // Write to Block register (sel = 10)
        inst[12:11] = 2'b10;
        d_in = 32'h0000_0007;  // All block bits set
        enable = 1;
        #10 enable = 0;

        // Simulate exception from expsrc0
        expsrc0 = 1;
        #10 expsrc0 = 0;

        // Check if EPC was saved and hasexp asserted
        #20;

        // Read from EPC (sel = 00)
        inst[12:11] = 2'b00;
        #10;

        // Read from Status (sel = 01)
        inst[12:11] = 2'b01;
        #10;

        // Read from Block (sel = 10)
        inst[12:11] = 2'b10;
        #10;

        // Read from Cause (sel = 11)
        inst[12:11] = 2'b11;
        #10;

        // Test iseret detection (bits 5~0 = 6'b010000)
        inst[5:0] = 6'b010000;
        #10;

        $finish;
    end

endmodule

