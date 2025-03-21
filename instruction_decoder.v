module instruction_decoder (
    input [31:0] IR,
    output RW, MW, MB, MA, CS, PS,
    output [1:0] MD, BS,
    output [4:0] FS, AA, BA, DA
);

    assign DA = IR[24:20];
    assign AA = IR[19:15];
    assign BA = IR[14:10];

    wire opcode = IR[31:25];
    reg [14:0] control_word;

    always @(*) begin
        case (opcode)
            7'b0000000: control_word = 15'b0_00_00_0_0_00000_0_0_0;
            7'b0000010: control_word = 15'b0_00_00_0_0_00000_0_0_0;
            7'b0000101: control_word = 15'b0_00_00_0_0_00000_0_0_0;
            7'b1100101: control_word = 15'b0_00_00_0_0_00000_0_0_0;
            7'b0001000: control_word = 15'b0_00_00_0_0_00000_0_0_0;
            7'b0001010: control_word = 15'b0_00_00_0_0_00000_0_0_0;
            7'b0001100: control_word = 15'b0_00_00_0_0_00000_0_0_0;
            7'b0000001: control_word = 15'b0_00_00_0_0_00000_0_0_0;
            7'b0100001: control_word = 15'b0_00_00_0_0_00000_0_0_0;
            7'b0100010: control_word = 15'b0_00_00_0_0_00000_0_0_0;
            7'b0100101: control_word = 15'b0_00_00_0_0_00000_0_0_0;
            7'b0101110: control_word = 15'b0_00_00_0_0_00000_0_0_0;
            7'b0101000: control_word = 15'b0_00_00_0_0_00000_0_0_0;
            7'b0101010: control_word = 15'b0_00_00_0_0_00000_0_0_0;
            7'b0101100: control_word = 15'b0_00_00_0_0_00000_0_0_0;
            7'b1100010: control_word = 15'b0_00_00_0_0_00000_0_0_0;
            7'b1100101: control_word = 15'b0_00_00_0_0_00000_0_0_0;
            7'b1000000: control_word = 15'b0_00_00_0_0_00000_0_0_0;
            7'b0110000: control_word = 15'b0_00_00_0_0_00000_0_0_0;
            7'b0110001: control_word = 15'b0_00_00_0_0_00000_0_0_0;
            7'b1100001: control_word = 15'b0_00_00_0_0_00000_0_0_0;
            7'b0100000: control_word = 15'b0_00_00_0_0_00000_0_0_0;
            7'b1100000: control_word = 15'b0_00_00_0_0_00000_0_0_0;
            7'b1000100: control_word = 15'b0_00_00_0_0_00000_0_0_0;
            7'b0000111: control_word = 15'b0_00_00_0_0_00000_0_0_0;
            default: control_word = 15'bx;
        endcase
    end

    
endmodule
