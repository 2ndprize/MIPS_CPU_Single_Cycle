module registerfile_tb;
  reg [4:0] reg1_in, reg2_in, rw;
  reg [31:0] write_data;
  reg we, clk;
  wire [31:0] reg1_out, reg2_out, a0, v0;

  registerfile uut (
    .reg1_in(reg1_in),
    .reg2_in(reg2_in),
    .rw(rw),
    .write_data(write_data),
    .we(we),
    .clk(clk),
    .reg1_out(reg1_out),
    .reg2_out(reg2_out),
    .a0(a0),
    .v0(v0)
  );

  // Clock generation
  always #5 clk = ~clk;

  initial begin
    // ???
    clk = 0;
    we = 0;
    reg1_in = 0;
    reg2_in = 0;
    rw = 0;
    write_data = 0;

    // 10ns ?? ???? ?? ??? (??? 00000000? ??? ??)
    #10;
    we = 1;  // write enable? 1? ??
    write_data = 32'b0; // ???? 0?? ??
    rw = 5'd0;  // Register 0? ? ??
    #10; // clk ?? ?? ??
    we = 0; // ?? we? 0?? ??

    #10;

    // Register 2? ? ??
    rw = 5'd2;
    write_data = 32'hAAAAAAAA;
    we = 1;
    #10; // clk ?? ?? ??
    we = 0;

    // Register 2 ?? (reg1? ??)
    reg1_in = 5'd2;
    #10; // clk ??? ??? ??? ??

    // Register 4? ? ??
    rw = 5'd4;
    write_data = 32'hBBBBBBBB;
    we = 1;
    #10;
    we = 0;

    // Register 4 ?? (reg2? ??)
    reg2_in = 5'd4;
    #10;

    $stop;
  end
endmodule

