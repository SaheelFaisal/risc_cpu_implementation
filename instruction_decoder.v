module instruction_decoder (
    input [31:0] IR,
    output RW, MW, MB, MA, CS, PS,
    output [1:0] MD, BS,
    output [4:0] FS, AA, BA, DA
);

    assign DA = IR[24:20];
    assign AA = IR[19:15];
    assign BA = IR[14:10];

    wire [6:0] opcode;
    assign opcode = IR[31:25];
    reg [14:0] control_word;

    assign RW  = control_word[14];
    assign MD  = control_word[13:12];
    assign BS =  control_word[11:10];
    assign PS =  control_word[9];
    assign MW =  control_word[8];
    assign FS =  control_word[7:3];
    assign MB  = control_word[2];
    assign MA  = control_word[1];
    assign CS  = control_word[0];

    always @(*) begin
        case (opcode)
            7'b0000000: control_word = 15'b0_00_00_0_0_00000_0_0_0; // NOP
            7'b0000010: control_word = 15'b1_00_00_0_0_00010_0_0_0; // ADD
            7'b0000101: control_word = 15'b1_00_00_0_0_00101_0_0_0; // SUB
            7'b1100101: control_word = 15'b1_10_00_0_0_00101_0_0_0; // SLT
            7'b0001000: control_word = 15'b1_00_00_0_0_01000_0_0_0; // AND
            7'b0001010: control_word = 15'b1_00_00_0_0_01010_0_0_0; // OR
            7'b0001100: control_word = 15'b1_00_00_0_0_01100_0_0_0; // XOR
            7'b0000001: control_word = 15'b0_00_00_0_1_00000_0_0_0; // ST
            7'b0100001: control_word = 15'b1_01_00_0_0_00000_0_0_0; // LD
            7'b0100010: control_word = 15'b1_00_00_0_0_00010_1_0_1; // ADI
            7'b0100101: control_word = 15'b1_00_00_0_0_00101_1_0_1; // SBI
            7'b0101110: control_word = 15'b1_00_00_0_0_01110_0_0_0; // NOT
            7'b0101000: control_word = 15'b1_00_00_0_0_01000_1_0_0; // ANI
            7'b0101010: control_word = 15'b1_00_00_0_0_01010_1_0_0; // ORI
            7'b0101100: control_word = 15'b1_00_00_0_0_01100_1_0_0; // XRI
            7'b1100010: control_word = 15'b1_00_00_0_0_00010_1_0_0; // AIU
            7'b1000101: control_word = 15'b1_00_00_0_0_00101_1_0_0; // SIU
            7'b1000000: control_word = 15'b1_00_00_0_0_00000_0_0_0; // MOV
            7'b0110000: control_word = 15'b1_00_00_0_0_10000_0_0_0; // LSL
            7'b0110001: control_word = 15'b1_00_00_0_0_10001_0_0_0; // LSR
            7'b1100001: control_word = 15'b0_00_10_0_0_00000_0_0_0; // JMR
            7'b0100000: control_word = 15'b0_00_01_0_0_00000_1_0_1; // BZ
            7'b1100000: control_word = 15'b0_00_01_1_0_00000_1_0_1; // BNZ
            7'b1000100: control_word = 15'b0_00_11_0_0_00000_1_0_1; // JMP
            7'b0000111: control_word = 15'b1_00_11_0_0_00111_1_1_1; // JML
            default: control_word = 15'hxxxx;
        endcase
    end
endmodule
