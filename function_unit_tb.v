`timescale 1ns/1ps
`include "function_unit.v"

module function_unit_tb;
    reg [31:0] A, B;
    reg [4:0] FS, SH;

    wire [31:0] F;
    wire C, V, N, Z;

    function_unit uut(
        .A(A),
        .B(B),
        .FS(FS),
        .SH(SH),
        .F(F),
        .C(C),
        .V(V),
        .N(N),
        .Z(Z)
    );

    integer i;

    initial begin

        $dumpfile("funtion_unit_tb.vcd");
        $dumpvars(0, function_unit_tb);

        {A, B, FS, SH} = 0;
        #10

        A = 32'hFFFF_FFFF;
        B = 32'hAAAA_5555;
        FS = 0; // Transfer A
        #10
        FS = 1; // INC - C, V, Z flags set
        #10
        FS = 7; // Transfer A
        #10
        FS = 12; // XOR - 5555_AAAA expected
        #10
        FS = 14; //NOT - Z flag set
        #10
        SH = 31;
        FS = 16; //LSL - 8000_0000 expected
        #10
        FS = 17; //LSR - 0000_0001 expected
        #10
        {A, B, FS, SH} = 0;
        #10
        A = 32'hAAAA_5555;
        B = 32'hAAAA_5555;
        FS = 2; // ADD - 5554_AAAA expected, C, V flags set
        #10
        FS = 3; // ADD with Carry
        #10
        FS = 4; // A + (~B) - FFFF_FFFF expected
        #10
        FS = 5; // SUB - 0000_0000 expected, Z flag set
        #10
        FS = 6; //DEC - AAAA_5554 expected
        #10
        {A, B, FS, SH} = 0;
        #10
        A = 32'h5555_AAAA;
        B = 32'hAAAA_5555;
        FS = 8; // AND - 0000_0000 expected, Z flag set
        #10
        FS = 10; // OR - FFFF_FFFF expected
        #20;

        $finish;
    end
endmodule