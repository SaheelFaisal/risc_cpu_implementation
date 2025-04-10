module data_memory(
    input clk,
    input [13:0] addr,
    input MW,
    input [31:0] data_in,
    output [31:0] data_out
    );

    reg [31:0] memword [16383:0];   // 16K words (64 KB total)
    integer i;
    wire [31:0] mem_5, mem_6, mem_10;    // To view in the simulation
    assign mem_5 = memword[5];
    assign mem_6 = memword[6];
    assign mem_10 = memword[10];

    initial begin
        memword[0] = 32'h7FFFFFFF;
        for(i=1; i<16384; i=i+1)
            memword[i] <= 0;					// for easier debugging
    end

    always @ (posedge clk) begin
        if(MW)
            memword[addr] <= data_in;
    end

    assign data_out = memword[addr];

    endmodule