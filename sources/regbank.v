`timescale 1ns / 1ps

module regbank(
    output [15:0] data_out1, data_out2,
    input [15:0] data_in,
    input [3:0] sr1, sr2, dr,
    input clk, write
);

    reg [15:0] regfile[15:0];   // regbank
    
    assign data_out1 = regfile[sr1];
    assign data_out2 = regfile[sr2];
    
    always @(posedge clk)
    begin
        if(write)
            regfile[dr] <= data_in;
    end    
endmodule
