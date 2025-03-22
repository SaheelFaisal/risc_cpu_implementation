module data_memory(
    input clk,
    input [13:0] addr,
    input MW,
    input [31:0] data_in,
    output [31:0] data_out
    );

    reg [31:0] memword [16383:0];   // 16K words (64 KB total)
    integer i;

    initial
        begin
        for(i=0; i<256; i=i+1)
            memword[i] <= i;					// for easier debugging
        end

    always @ (posedge clk)
        begin
            if(MW)
            memword[addr] <= data_in;
        end

    assign data_out = memword[addr];

    endmodule