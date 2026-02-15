`timescale 1ns / 1ps

module RAM(
    output [15:0] data_out, 
    input [15:0] data_in,
    input [7:0] addr,
    input cs, write, clk
    );
    
    reg [15:0] memory[255:0];     // RAM 
    
    assign data_out = memory[addr];
    
    always @(posedge clk)
    begin
        if(cs && write)
            memory[addr] <= data_in;
    end
    
endmodule
