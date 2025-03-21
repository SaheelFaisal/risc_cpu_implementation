`timescale 1ns / 1ps
`include "regfile.v"

module regfile_tb( );
    reg clk;
    reg reset;
    reg RW;
    reg [4:0] AA;
    reg [4:0] BA;
    reg [4:0] DA;
    reg [31:0] D_data;
    wire [31:0] A_data;
    wire [31:0] B_data;

    regfile UUT(
        .clk(clk),
        .reset(reset),
        .RW(RW),
        .AA(AA),
        .BA(BA),
        .DA(DA),
        .D_data(D_data),
        .A_data(A_data),
        .B_data(B_data)
    );
        always #5 clk = ~clk;
        // Task to print memory contents
        task print_memory;
            integer i;
            begin
                $display("----- Memory Dump -----");
                for (i = 0; i < 32; i = i + 1) begin
                    $display("R%0d = %d", i, UUT.data[i]);
                end
                $display("-----------------------");
            end
        endtask    
        initial begin
            $dumpfile("regfile_tb.vcd");
            $dumpvars(0, regfile_tb);

            {clk, RW, AA, BA, DA, D_data} = 0;
            print_memory();
            reset = 1;
            #20
            print_memory();
            reset = 0;
            RW = 1;
            AA = 5'd0;
            BA = 5'd0;
            DA = 5'd5;
            D_data = 32'd1000; // Writing into R5
            #20
            print_memory();
            AA = 5'd0;
            BA = 5'd0;
            DA = 5'd11;
            D_data = 32'd1500; // Writing into R11
            #20
            print_memory();
            AA = 5'd5;  // R5
            BA = 5'd11; // R11
            DA = 5'd0;
            D_data = 32'd0;
            #20
            print_memory();
            reset = 1;
            #20
            print_memory();
            reset = 0;
            $finish;
        end
endmodule