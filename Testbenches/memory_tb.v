`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/28/2025 03:35:12 PM
// Design Name: 
// Module Name: memory_tb
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


module memory_tb();

    wire [15:0] data_out;
    reg [15:0] data_in;
    reg [7:0] addr;
    reg cs, write, clk;
    integer k, myseed;
    
    initial clk = 0;
    
    always clk = #5 ~clk;
    
    RAM uut(data_out, data_in, addr, cs, write, clk);
    
    initial 
    begin
        for(k = 0; k < 50; k = k+1)
        begin
            addr = k;
            data_in = (k+k) % 256; write = 1; cs = 1;
            #9; //write = 0; cs = 0;    
        end
        
        repeat(20)
        begin
            #2 addr = $random(myseed) % 50;
            write = 0; cs = 1;
            $display ("Address: %5d, Data: %4d", addr, data_out);
        end 
    end
    
    initial myseed = 35;

endmodule
