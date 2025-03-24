module instruction_mem (
    input [13:0] PC,
    output [31:0] IR
);
    `include "asm_param.inc"

    reg [31:0] memword [16383:0];   // 16K words (64 KB total)
    assign IR = memword[PC];

    integer i;

    task insert_nops;
        input integer addr;  // Address where NOPs should be inserted
    begin
        memword[addr]   = {NOP, R0, R0, 15'd0};
        memword[addr+1] = {NOP, R0, R0, 15'd0};
        memword[addr+2] = {NOP, R0, R0, 15'd0};
    end
endtask

    initial begin
        memword[0] = {ADI, R5, R5, 15'd10};
        insert_nops(1);
        memword[4] = {ADI, R6, R6, 15'd15};
        insert_nops(5);
        memword[8] = {ADD, R7, R5, R6, 10'd0};
        insert_nops(9);
        memword[12] = {MOV, R10, R7, 15'd0};
        insert_nops(13);
        memword[16] = {ST, R5, R5, R10, 10'd0};
        insert_nops(17);
        memword[20] = {LD, R11, R5, 15'd0};
        insert_nops(21);
        memword[24] = {ADI, R5, R5, 15'd30};
        insert_nops(25);
        memword[28] = {JMP, R0, R0, 15'o77771}; // -1 in 15 bit octadecimal - Jump 1 line up


        for (i = 29; i < 16384; i = i + 1) begin
            memword[i] = {NOP, R0, R0, 15'd0};  //32'd0
        end
    end
endmodule