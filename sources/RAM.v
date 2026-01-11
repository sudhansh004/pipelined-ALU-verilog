`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/28/2025 03:23:14 PM
// Design Name: 
// Module Name: RAM
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


module RAM(
    output [15:0] data_out, 
    input [15:0] data_in,
    input [7:0] addr,
    input cs, write, clk
    );
    
    reg [15:0] memory[255:0];
    
    assign data_out = memory[addr];
    
    always @(posedge clk)
    begin
        if(cs && write)
            memory[addr] <= data_in;
    end
    
endmodule
