`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: -
// Engineer: Sudhanshu Sharma
// 
// Create Date: 12/28/2025 03:08:44 PM
// Design Name: 
// Module Name: regbank
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module regbank(
    output [15:0] data_out1, data_out2,
    input [15:0] data_in,
    input [3:0] sr1, sr2, dr,
    input clk, write
);

    reg [15:0] regfile[15:0];
    
    assign data_out1 = regfile[sr1];
    assign data_out2 = regfile[sr2];
    
    always @(posedge clk)
    begin
        if(write)
            regfile[dr] <= data_in;
    end    
endmodule
