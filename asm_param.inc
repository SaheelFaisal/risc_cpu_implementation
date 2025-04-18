parameter [6:0]  NOP = 7'b0000000;
parameter [6:0]  ADD = 7'b0000010;
parameter [6:0]  SUB = 7'b0000101;
parameter [6:0]  SLT = 7'b1100101;
parameter [6:0]  AND = 7'b0001000;
parameter [6:0]  OR =  7'b0001010;
parameter [6:0]  XOR = 7'b0001100;
parameter [6:0]  ST =  7'b0000001;
parameter [6:0]  LD =  7'b0100001;
parameter [6:0]  ADI = 7'b0100010;
parameter [6:0]  SBI = 7'b0100101;
parameter [6:0]  NOT = 7'b0101110;
parameter [6:0]  ANI = 7'b0101000;
parameter [6:0]  ORI = 7'b0101010;
parameter [6:0]  XRI = 7'b0101100;
parameter [6:0]  AIU = 7'b1100010;
parameter [6:0]  SIU = 7'b1000101;
parameter [6:0]  MOV = 7'b1000000;
parameter [6:0]  LSL = 7'b0110000;
parameter [6:0]  LSR = 7'b0110001;
parameter [6:0]  JMR = 7'b1100001;
parameter [6:0]  BZ =  7'b0100000;
parameter [6:0]  BNZ = 7'b1100000;
parameter [6:0]  JMP = 7'b1000100;
parameter [6:0]  JML = 7'b0000111;

parameter [4:0]  R0  = 5'd0; 
parameter [4:0]  R1  = 5'd1;
parameter [4:0]  R2  = 5'd2;
parameter [4:0]  R3  = 5'd3;
parameter [4:0]  R4  = 5'd4;
parameter [4:0]  R5  = 5'd5;
parameter [4:0]  R6  = 5'd6;
parameter [4:0]  R7  = 5'd7;
parameter [4:0]  R8  = 5'd8;
parameter [4:0]  R9  = 5'd9;
parameter [4:0]  R10 = 5'd10;
parameter [4:0]  R11 = 5'd11;
parameter [4:0]  R12 = 5'd12;
parameter [4:0]  R13 = 5'd13;
parameter [4:0]  R14 = 5'd14;
parameter [4:0]  R15 = 5'd15;
parameter [4:0]  R16 = 5'd16;
parameter [4:0]  R17 = 5'd17;
parameter [4:0]  R18 = 5'd18;
parameter [4:0]  R19 = 5'd19;
parameter [4:0]  R20 = 5'd20;
parameter [4:0]  R21 = 5'd21;
parameter [4:0] R22 = 5'd22;
parameter [4:0] R23 = 5'd23;
parameter [4:0] R24 = 5'd24;
parameter [4:0] R25 = 5'd25;
parameter [4:0] R26 = 5'd26;
parameter [4:0] R27 = 5'd27;
parameter [4:0] R28 = 5'd28;
parameter [4:0] R29 = 5'd29;
parameter [4:0] R30 = 5'd30;
parameter [4:0] R31 = 5'd31;