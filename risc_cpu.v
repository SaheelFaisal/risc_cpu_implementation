`include "instruction_mem.v"
`include "instruction_decoder.v"
`include "constant_unit.v"
`include "regfile.v"
`include "mux_A_B.v"
`include "function_unit.v"
`include "data_memory.v"
`include "mux_C.v"
`include "mux_D.v"

module risc_cpu (
    input clk, reset
);

    // Variables and module instantiations for each stage

    // Registers
    wire [31:0] R0;
    wire [31:0] R1;
    wire [31:0] R2;
    wire [31:0] R3;
    wire [31:0] R4;
    wire [31:0] R5;
    wire [31:0] R6;
    wire [31:0] R7;
    wire [31:0] R8;
    wire [31:0] R9;
    wire [31:0] R10;
    wire [31:0] R11;
    wire [31:0] R12;
    wire [31:0] R13;
    wire [31:0] R14;
    wire [31:0] R15;
    wire [31:0] R16;
    wire [31:0] R17;
    wire [31:0] R18;
    wire [31:0] R19;
    wire [31:0] R20;
    wire [31:0] R21;
    wire [31:0] R22;
    wire [31:0] R23;
    wire [31:0] R24;
    wire [31:0] R25;
    wire [31:0] R26;
    wire [31:0] R27;
    wire [31:0] R28;
    wire [31:0] R29;
    wire [31:0] R30;
    wire [31:0] R31;

    assign R0 = registers.data[0];
    assign R1 = registers.data[1];
    assign R2 = registers.data[2];
    assign R3 = registers.data[3];
    assign R4 = registers.data[4];
    assign R5 = registers.data[5];
    assign R6 = registers.data[6];
    assign R7 = registers.data[7];
    assign R8 = registers.data[8];
    assign R9 = registers.data[9];
    assign R10 = registers.data[10];
    assign R11 = registers.data[11];
    assign R12 = registers.data[12];
    assign R13 = registers.data[13];
    assign R14 = registers.data[14];
    assign R15 = registers.data[15];
    assign R16 = registers.data[16];
    assign R17 = registers.data[17];
    assign R18 = registers.data[18];
    assign R19 = registers.data[19];
    assign R20 = registers.data[20];
    assign R21 = registers.data[21];
    assign R22 = registers.data[22];
    assign R23 = registers.data[23];
    assign R24 = registers.data[24];
    assign R25 = registers.data[25];
    assign R26 = registers.data[26];
    assign R27 = registers.data[27];
    assign R28 = registers.data[28];
    assign R29 = registers.data[29];
    assign R30 = registers.data[30];
    assign R31 = registers.data[31];


    // IF
    reg [31:0] PC, PC_1, IR;
    wire [31:0] instruction, PC_incremented;

    assign PC_incremented = PC + 1;
    
    instruction_mem inst_mem(
        .PC(PC[13:0]),
        .IR(instruction)
    );

    // DOF
    reg [31:0] PC_2, bus_A, bus_B;
    reg RW_DOF, PS, MW;
    reg [1:0] MD_DOF, BS;
    reg [4:0] DA_DOF, FS, SH;
    wire RW_wire, PS_wire, MW_wire, MA_wire, MB_wire, CS_wire;
    wire [1:0] MD_wire, BS_wire;
    wire [4:0] DA_wire, FS_wire, SH_wire, AA_wire, BA_wire;
    wire [14:0] IM;
    wire [31:0] IM_extended, A_data, B_data, bus_A_wire, bus_B_wire;

    assign IM = IR[14:0];
    assign SH_wire = IR[4:0];

    instruction_decoder inst_dec(
        .IR(IR),
        .RW(RW_wire), .MW(MW_wire), .MB(MB_wire), .MA(MA_wire), .CS(CS_wire), .PS(PS_wire),
        .MD(MD_wire), .BS(BS_wire),
        .FS(FS_wire), .AA(AA_wire), .BA(BA_wire), .DA(DA_wire)
    );

    constant_unit const_unit(
        .CS(CS_wire), .IM(IM), .IM_extended(IM_extended)
    );

    regfile registers(
        .clk(clk), .reset(reset), .RW(RW),
        .AA(AA_wire), .BA(BA_wire), .DA(DA), .D_data(bus_D_wire),
        .A_data(A_data), .B_data(B_data)
    );

    mux_A_B muxAB(
        .MA(MA_wire), .MB(MB_wire),
        .PC_1(PC_1), .A_data(A_data), .B_data(B_data), .IM(IM_extended),
        .bus_A(bus_A_wire), .bus_B(bus_B_wire)
    );

    // EX
    reg RW, V_xor_N;
    reg [4:0] DA;
    reg [1:0] MD;
    reg [31:0] F, data_out;

    wire C, V, N, Z, V_xor_N_wire;
    wire [1:0] mux_C_sel_wire;
    wire [31:0] BrA, F_wire, data_out_wire, PC_wire;

    assign BrA = PC_2 + bus_B;
    assign mux_C_sel_wire = {BS[1], ( ((PS^Z) | BS[1]) & BS[0])};
    assign V_xor_N_wire = V^N;

    function_unit func_unit(
        .A(bus_A), .B(bus_B), .FS(FS), .SH(SH),
        .C(C), .V(V), .Z(Z), .N(N), .F(F_wire)
    );

    data_memory data_mem(
        .clk(clk), .addr(bus_A[13:0]), .MW(MW), .data_in(bus_B),
        .data_out(data_out_wire)
    );

    mux_C muxC(
        .sel(mux_C_sel_wire), .PC_1(PC_incremented), .BrA(BrA), .RAA(bus_A),
        .PC(PC_wire)
    );

    // WB
    wire [31:0] bus_D_wire;

    mux_D muxD(
        .MD(MD), .F(F), .data_out(data_out), .V_xor_N({31'b0, V_xor_N}),
        .bus_D(bus_D_wire)
    );

    always @(posedge clk) begin
        if (reset) begin
            {PC, PC_1, IR, PC_2, RW_DOF, DA_DOF, MD_DOF, BS, PS, MW,
            FS, SH, bus_A, bus_B, RW, DA, MD, V_xor_N, F, data_out} <= 0;
        end

        else begin
            // IF Stage
            PC_1 <= PC_incremented;
            IR <= instruction;

            // DOF Stage
            PC_2 <= PC_1;
            RW_DOF <= RW_wire;
            DA_DOF <= DA_wire;
            MD_DOF <= MD_wire;
            BS <= BS_wire;
            PS <= PS_wire;
            MW <= MW_wire;
            FS <= FS_wire;
            SH <= SH_wire;
            bus_A <= bus_A_wire;
            bus_B <= bus_B_wire;
            
            // EX Stage
            RW <= RW_DOF;
            DA <= DA_DOF;
            MD <= MD_DOF;
            PC <= PC_wire;
            
            V_xor_N <= V_xor_N_wire;
            F <= F_wire;
            data_out <= data_out_wire;

        end
    end
endmodule 