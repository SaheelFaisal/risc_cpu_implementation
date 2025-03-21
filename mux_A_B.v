module mux_A_B (
    input MA, MB,
    input [31:0] PC_1, A_data, IM, B_data,
    output [31:0] bus_A, bus_B
);

    assign bus_A = MA ? PC_1 : A_data;
    assign bus_B = MB ? IM : B_data;
    
endmodule