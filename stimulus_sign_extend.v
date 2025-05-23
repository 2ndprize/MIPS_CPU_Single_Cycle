module sign_extend_tb;

  	reg [15:0] in1;
  	reg zero_extend;
  	wire [31:0] out1;


  	sign_extend uut (
    		.inst(in1),
    		.zero_extend(zero_extend),
    		.extend_inst(out1)
  	);

 	initial begin
    	$display("Time\tZeroExt\tInput\t\tExtended Output");
    	$monitor("%t\t%b\t%h\t%h", $time, zero_extend, in1, out1);

	zero_extend = 0;

    	in1 = 16'h8fc0;
    	#1 in1 = 16'h2020;
    	#1 in1 = 16'h0022;
    	#1 in1 = 16'h000c;

    	#1 zero_extend = 1;
    	in1 = 16'h8fc0;
    	#1 in1 = 16'h2020;
    	#1 in1 = 16'h0022;
    	#1 in1 = 16'h000c;

    	#10 $finish;
  	end

endmodule

