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
        memword[24] = {SUB, R12, R5, R11, 10'd0};   // R5 - R11 = 10 - 25 = -5
        insert_nops(25);
        memword[28] = {SLT, R13, R5, R10, 10'd0}; // R13 = 1, if R5 < R10
        insert_nops(29);
        memword[32] = {ADI, R8, R8, 15'd5};     // 5 in R8
        insert_nops(33);
        memword[36] = {AND, R9, R5, R8, 10'd0}; // 5 & 10 = 0
        insert_nops(37);
        memword[40] = {OR, R10, R5, R8, 10'd0}; // 5 | 10 = 15 : R14 = 15
        insert_nops(41);
        memword[44] = {XOR, R12, R5, R8, 10'd0}; // 5 ^ 10 = 15: R15 = 15
        insert_nops(45);
        memword[48] = {SBI, R10, R11, 15'd3}; // R16 = R11 - 3 = 25 - 3 = 22
        insert_nops(49);
        memword[52] = {NOT, R10, R5, 15'd30};
        insert_nops(53);
        memword[54] = {ANI, R10, R5, 15'd12}; // 
        insert_nops(55);
        memword[58] = {ORI, R10, R5, 15'd10}; // R10 = 15
        insert_nops(59);
        memword[62] = {XRI, R10, R5, 15'd15}; // R10 = 5
        insert_nops(63);
        memword[66] = {AIU, R10, R5, 15'o77771}; // R10 = 32767 + 5
        insert_nops(67);
        memword[70] = {SIU, R10, R5, 15'o77771}; // R10 = 5
        insert_nops(71);
        memword[74] = {ADI, R5, R5, 15'd30};
        insert_nops(75);
        memword[78] = {JMP, R0, R0, 15'o77771}; // -1 in 15 bit octadecimal - Jump 1 line up


        for (i = 79; i < 16384; i = i + 1) begin
            memword[i] = {NOP, R0, R0, 15'd0};  //32'd0
        end
    end
endmodule