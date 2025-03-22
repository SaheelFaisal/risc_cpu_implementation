`include "instruction_mem.v"
`include "instruction_decoder.v"
`include "constant_unit.v"
`include "regfile.v"
`include "mux_A_B.v"

module risc_cpu (
    input clk, reset
);

    // Variables and module instantiations for each stage

    // IF
    reg [31:0] PC, PC_1, IR;
    wire [31:0] instruction;
    
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
        .AA(AA_wire), .BA(BA_wire), .DA(DA),
        .A_data(A_data), .B_data(B_data)
    );

    mux_A_B muxAB(
        .MA(MA_wire), .MB(MB_wire),
        .PC_1(PC_1), .A_data(A_data), .B_data(B_data), .IM(IM_extended),
        .bus_A(bus_A_wire), .bus_B(bus_B_wire)
    );

    // EX
    reg RW;
    reg [4:0] DA;
    reg [1:0] MD;

    always @(posedge clk) begin
        if (reset) begin
            {PC, PC_1} = 0;
        end

        else begin
            // IF Stage
            PC_1 <= PC + 1;
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

        end
    end
    
    

endmodule 