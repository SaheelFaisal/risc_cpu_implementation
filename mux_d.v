module mux_D (
    input [1:0] MD,
    input [31:0] F, data_out, V_xor_N,
    output reg [31:0] bus_D
);

    always @(*) begin
        case (MD)
            0: bus_D = F;
            1: bus_D = data_out;
            2: bus_D = V_xor_N; 
            default: bus_D = 32'bx;
        endcase
    end

    
endmodule