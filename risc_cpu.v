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
            FS, SH, bus_A, bus_B, RW, DA, MD, V_xor_N, F, data_out} = 0;
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
            
            V_xor_N <= V_xor_N_wire;
            F <= F_wire;
            data_out <= data_out_wire;

        end
    end
endmodule 