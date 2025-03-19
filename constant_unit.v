module constant_unit (
    input CS,
    input [14:0] IM,
    output [31:0] IM_extended
);

    assign IM_extended = CS ? {{17{IM[14]}}, IM}: {17'b0, IM};
    
endmodule