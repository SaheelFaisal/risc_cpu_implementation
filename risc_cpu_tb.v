`timescale 1ns/1ps
`include "risc_cpu.v"

module risc_cpu_tb;
    reg clk;
    reg reset;

    risc_cpu UUT(
        .clk(clk),  
        .reset(reset)
    );

    always #5 clk = ~clk;

    integer i;

    initial begin
        $dumpfile("risc_cpu_tb.vcd");
        $dumpvars(0, risc_cpu_tb);

        clk = 0;
        reset = 1;
        #20

        reset = 0;

        #20000

        $finish;
    end
endmodule
