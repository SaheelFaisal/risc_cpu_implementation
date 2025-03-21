module regfile(
    input clk,
    input reset,
	input RW,
    input [4:0] AA,
    input [4:0] BA,
    input [4:0] DA,
    input [31:0] D_data,
    output [31:0] A_data,
    output [31:0] B_data
    );

reg [31:0] data [31:0];

assign A_data = data [AA];
assign B_data = data [BA];

integer counter;
		
initial
	for(counter = 0; counter < 32; counter = counter + 1)
		data [counter] = counter;									// for easier initial debugging

always @(posedge clk)
	begin
		if(reset)
			for(counter = 0; counter < 32; counter = counter + 1)
				data [counter] <= 0;									// clear all regs on reset
		else if(RW)														// if not clearing, then write
			data[DA] <= D_data;		
	end
	
endmodule
