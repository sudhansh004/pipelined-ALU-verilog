`timescale 1ns / 1ps

module pipeline_tb();

    wire [15:0] zout;
    reg [3:0] rs1, rs2, rd, func;
    reg [7:0] addr;
    reg clk, rst_n;
    integer k;
    
    pipeline uut(.rs1(rs1), .rs2(rs2), .rd(rd), .func(func), .addr(addr), .clk(clk), .rst_n(rst_n), .zout(zout));
    
    initial
    begin
        clk = 1'b0;
        rst_n = 1'b1;
        forever #5 clk = ~clk;
    end
    
    always @(posedge clk)
    begin
        $display("Time=%0t | zout=%0d", $time, zout);
    end
    
    initial 
    begin
        $dumpfile("pipeline.vcd");
        $dumpvars(0, pipeline_tb.uut);
    end
    
    
    // register initialisation
    initial
    begin      
        for(k = 0; k < 16; k = k+1)
        begin
            uut.bank1.regfile[k] = k;
        end
    end
    
    initial
    begin
        #5   rs1 = 3; rs2 = 5; rd = 10; func = 0; addr = 125;    // ADD
        #20  rs1 = 3; rs2 = 8; rd = 12; func = 2; addr = 126;    // MUL
        #20  rs1 = 10; rs2 = 5; rd = 14; func = 1; addr = 128;   // SUB
        #20  rs1 = 7; rs2 = 3; rd = 13; func = 11; addr = 127;   // SLA
        #20  rs1 = 10; rs2 = 5; rd = 15; func = 1; addr = 129;   // SUB
        #20  rs1 = 12; rs2 = 13; rd = 14; func = 0; addr = 130;  // ADD
        #40 rst_n = 1'b0;
    end
    
    initial 
    begin
        #300 $finish;
    end
    
    
endmodule
