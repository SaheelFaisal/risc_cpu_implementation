module mux_C (
    input [1:0] sel,
    input [31:0] PC_1, BrA, RAA,
    output reg [31:0] PC
);
    always @(*) begin
        case (sel)
            2'b00: PC = PC_1;
            2'b01: PC = BrA;
            2'b10: PC = RAA;
            2'b11: PC = BrA;
            default: PC <= PC_1;
        endcase
    end
endmodule