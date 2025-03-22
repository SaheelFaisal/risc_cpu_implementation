module instruction_mem (
    input [13:0] PC,
    output [31:0] IR
);
    `include "asm_param.inc"

    reg [31:0] memword [16383:0];   // 16K words (64 KB total)
    assign IR = memword[PC];

    integer i;

    initial begin
        memword[0] = {ADI, R5, R5, 15'd10};
        memword[1] = {ADI, R6, R6, 15'd15};
        memword[2] = {ADD, R7, R5, R6, 10'd0};
        memword[3] = {MOV, R10, R7, 15'd0};
        memword[4] = {ST, R5, R5, R10, 10'd0};
        memword[5] = {LD, R11, R5, 15'd0};
        memword[6] = {NOP, R0, R0, 15'd0};

        for (i = 7; i < 16384; i = i + 1) begin
            memword[i] = {NOP, R0, R0, 15'd0};  //32'd0
        end    
    end
endmodule