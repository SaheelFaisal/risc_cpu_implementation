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
        // Store number A into R1
        memword[0] = {LD, R1, R0, 15'd0};  // A =  0x7fffffff
        insert_nops(1);

        // Store number B into R2
        memword[4] = {LD, R2, R0, 15'd0};   // B = 0x7fffffff
        insert_nops(5);

        // Check and store absolute values
        memword[8]  = {SLT, R8, R1, R0, 10'd0}; // If A < 0, R8 = 1
        insert_nops(9);
        memword[12] = {BZ, R0, R8, 15'd8};     // If A >= 0, skip negation (jump to POS_A) 12+1+8=21
        insert_nops(13);
        memword[16] = {SUB, R3, R0, R1, 10'd0}; // R3 = -A (absolute value of A)
        insert_nops(17);
        memword[20] = {JMP, R0, R0, 15'd4};    // Jump to AFTER_A (address 28)
        insert_nops(21);

        // POS_A: If A >= 0, use R1 as is (positive A)
        memword[24] = {MOV, R3, R1, 15'd0};     // R3 = A (already positive)
        insert_nops(25);

        // AFTER_A: Check if B is negative
        memword[28] = {SLT, R8, R2, R0, 10'd0}; // If B < 0, R8 = 1
        insert_nops(29);
        memword[32] = {BZ, R0, R8, 15'd8};    // If B >= 0, skip negation (jump to POS_B)
        insert_nops(33);
        memword[36] = {SUB, R4, R0, R2, 10'd0}; // R4 = -B (absolute value of B)
        insert_nops(37);
        memword[40] = {JMP, R0, R0, 15'd4};    // Jump to AFTER_B (address 48)
        insert_nops(41);

        // POS_B: If B >= 0, use R2 as is (positive B)
        memword[44] = {MOV, R4, R2, 15'd0};     // R4 = B (already positive)
        insert_nops(45);

        // AFTER_B: Initialize result registers (R5 for lower 32 bits, R6 for upper 32 bits)
        memword[48] = {MOV, R5, R0, 15'd0};     // Lower 32 bits = 0
        insert_nops(49);
        memword[52] = {MOV, R6, R0, 15'd0};     // Upper 32 bits = 0
        insert_nops(53);
        memword[56] = {MOV, R7, R4, 15'd0};     // Loop counter = B (R4)
        insert_nops(57);

        // LOOP: Multiplication loop
        memword[60] = {BZ, R0, R7, 15'd36};      // If counter is 0, exit loop. Jump to DONE 60+1+36=97
        insert_nops(61);
        memword[64] = {ANI, R8, R7, 15'd1};     // Check if LSB of counter is 1
        insert_nops(65);
        memword[68] = {BZ, R0, R8, 15'd16};     // If not, skip addition (jump to SKIP_ADD) 68+1+16=85
        insert_nops(69);
        memword[72] = {ADD, R5, R5, R3, 10'd0}; // Add R3 (A) to result lower part
        insert_nops(73);

        // Handle carry
        memword[76] = {SLT, R8, R5, R3, 10'd0};      // If R5 < R3 after addition, carry occurred
        insert_nops(77);
        memword[80] = {BZ, R0, R8, 15'd4};          // If no carry, skip incrementing R6
        insert_nops(81);
        memword[84] = {ADI, R6, R6, 15'd1};      // Increment upper 32-bit part due to carry
        insert_nops(85);

        // NO_CARRY: SKIP_ADD
        memword[88] = {LSL, R3, R3, 15'd1};           // Left shift A (R3)
        insert_nops(89);
        memword[92] = {LSR, R7, R7, 15'd1};          // Right shift counter
        insert_nops(93);
        memword[96] = {JMP, R0, R0, 15'o77730};         // JMP LOOP 96+1-40=57
        insert_nops(97);

        // DONE:
        memword[100] = {XOR, R8, R1, R2, 10'd0};     // XOR R8, R1, R2      // If A and B had different signs, R8 = 1
        insert_nops(101);
        memword[104] = {LSR, R8, R8, 15'd31};            // LSR R8, R8, 31      // Shift R8 to isolate the sign bit (32 bits shift)
        insert_nops(105);
        memword[108] = {BZ, R0, R8, 15'd8};        // BZ END              // If same sign, result is correct 108+1+8=117
        insert_nops(109);
        memword[112] = {SUB, R5, R0, R5, 10'd0};     // SUB R5, R0, R5      // Negate lower 32 bits
        insert_nops(113);
        memword[116] = {SUB, R6, R0, R6, 10'd0};     // SUB R6, R0, R6      // Negate upper 32 bits

        // END:
        memword[117] = {NOP, R0, R0, 15'd0};         // Final NOP
        
        for (i = 118; i < 16384; i = i + 1) begin
            memword[i] = {NOP, R0, R0, 15'd0};  //32'd0
        end
    end
endmodule