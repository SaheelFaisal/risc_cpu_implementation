module function_unit (
    input [31:0] A, B,
    input [4:0] FS, SH,
    output reg C, V,
    output Z, N,
    output reg [31:0] F
);
    assign Z = ~|F;
    assign N = F[31];

    always @(*) begin
        case (FS)
            5'b00000: {C, F} = A; 
            5'b00001: {C, F} = A + 1;
            5'b00010: {C, F} = A + B;
            5'b00011: {C, F} = A + B + 1;
            5'b00100: {C, F} = A + (~B);
            5'b00101: {C, F} = A - B;
            5'b00110: {C, F} = A - 1;
            5'b00111: {C, F} = A;
            5'b01000: {C, F} = A & B;
            5'b01001: {C, F} = A | B;
            5'b01010: {C, F} = A ^ B;
            5'b01011: {C, F} = ~A;
            5'b11100: {C, F} = B;
            5'b11101: {C, F} = A << SH;
            5'b11110: {C, F} = A >> SH;
            default: {C, F} = 0;
        endcase

        V = ( (FS == 5'b00001 | FS == 5'b00010 ) & ( (~A[31] & ~B[31] & F[31]) | (A[31] & B[31] & ~F[31])) ) | // For addition and inc
            ( (FS == 5'b00101 | FS == 5'b00110 ) & ( (~A[31] & B[31] & F[31]) | (A[31] & ~B[31] & ~F[31])) ) ; // For subtraction and dec
    end
endmodule