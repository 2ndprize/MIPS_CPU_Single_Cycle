`timescale 1ns/1ps

module count_tb;

    reg clk;
    reg rst;
    wire out;

    count uut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );


    always #5 clk = ~clk;

    initial begin

        clk = 0;
        rst = 1;


        #15;
        rst = 0;


        #100;

 
        $finish;
    end


    initial begin
        $monitor("Time = %0t | rst = %b | cnt = %b | out = %b", $time, rst, uut.cnt, out);
    end

endmodule

