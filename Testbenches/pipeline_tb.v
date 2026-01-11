`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/02/2026 11:26:30 AM
// Design Name: 
// Module Name: pipeline_tb
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


module pipeline_tb();

    wire [15:0] zout;
    reg [3:0] rs1, rs2, rd, func;
    reg [7:0] addr;
    reg clk1, clk2;
    integer k;
    
    pipeline uut(.rs1(rs1), .rs2(rs2), .rd(rd), .func(func), .addr(addr), .clk1(clk1), .clk2(clk2), .zout(zout));
    
    initial 
    begin
        clk1 = 0; clk2 = 0;
    end
    
    always
    begin
        #5 clk1 = 1; #5 clk1 = 0;
        #5 clk2 = 1; #5 clk2 = 0;
    end
    
    initial
    begin
        for(k = 0; k < 16; k = k+1)
        begin
            uut.bank1.regfile[k] = k;
        end
    end
    
    initial
    begin
        #5   rs1 = 3; rs2 = 5; rd = 10; func = 0; addr = 125;  // ADD
        #20  rs1 = 3; rs2 = 8; rd = 12; func = 2; addr = 126;  // MUL
        #20  rs1 = 10; rs2 = 5; rd = 14; func = 1; addr = 128;  // SUB
        #20  rs1 = 7; rs2 = 3; rd = 13; func = 11; addr = 127;  // SLA
        #20  rs1 = 10; rs2 = 5; rd = 15; func = 1; addr = 129; // SUB
        #20  rs1 = 12; rs2 = 13; rd = 14; func = 0; addr = 130; // ADD
    end
    
    initial
    begin
        $display("result = %3d", zout);
        #300 $finish;
    end
    
    
endmodule
