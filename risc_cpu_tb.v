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

    task print_memory;
        begin
            $display("----- Memory Dump -----");
            $display("R0 = %d", UUT.R0);
            $display("R1 = %d", UUT.R1);
            $display("R2 = %d", UUT.R2);
            $display("R3 = %d", UUT.R3);
            $display("R4 = %d", UUT.R4);
            $display("R5 = %d", UUT.R5);
            $display("R6 = %d", UUT.R6);
            $display("R7 = %d", UUT.R7);
            $display("R8 = %d", UUT.R8);
            $display("R9 = %d", UUT.R9);
            $display("R10 = %d", UUT.R10);
            $display("R11 = %d", UUT.R11);
            $display("R12 = %d", UUT.R12);
            $display("R13 = %d", UUT.R13);
            $display("R14 = %d", UUT.R14);
            $display("R15 = %d", UUT.R15);
            $display("R16 = %d", UUT.R16);
            $display("R17 = %d", UUT.R17);
            $display("R18 = %d", UUT.R18);
            $display("R19 = %d", UUT.R19);
            $display("R20 = %d", UUT.R20);
            $display("R21 = %d", UUT.R21);
            $display("R22 = %d", UUT.R22);
            $display("R23 = %d", UUT.R23);
            $display("R24 = %d", UUT.R24);
            $display("R25 = %d", UUT.R25);
            $display("R26 = %d", UUT.R26);
            $display("R27 = %d", UUT.R27);
            $display("R28 = %d", UUT.R28);
            $display("R29 = %d", UUT.R29);
            $display("R30 = %d", UUT.R30);
            $display("R31 = %d", UUT.R31);
            $display("-----------------------");
        end
    endtask   

    initial begin
        $dumpfile("risc_cpu_tb.vcd");
        $dumpvars(0, risc_cpu_tb);

        clk = 0;
        reset = 1;
        #20
        print_memory();

        reset = 0;

        for (i = 0; i < 2; i = i + 1) begin
            #200
            print_memory();
        end
        #400
        print_memory();
        $finish;
    end
endmodule
