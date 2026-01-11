`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/31/2025 07:19:51 PM
// Design Name: 
// Module Name: pipeline
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


module pipeline(
    input [3:0] rs1, rs2, rd, func,
    input [7:0] addr,
    input clk1, clk2, 
    output [15:0] zout
    );
    
    reg [15:0] L12_A, L12_B;        // latch 1-2
    reg [3:0] L12_rd, L12_func;
    reg [7:0] L12_addr;
    
    reg [15:0] L23_z;               // latch 2-3
    reg [3:0] L23_rd;
    reg [7:0] L23_addr;
    
    reg [15:0] L34_z;               // latch 3-4
    reg [7:0] L34_addr;
    
    reg reg_write, mem_write, cs;
    wire [15:0] reg_out1, reg_out2, reg_in, mem_out, mem_in;
    wire [7:0] mem_addr;
    
    parameter ADD = 4'b0000, SUB = 4'b0001, MUL = 4'b0010, SELA = 4'b0011, SELB = 4'b0100, AND = 4'b0101, OR = 4'b0110, 
              XOR = 4'b0111, NEGA = 4'b1000, NEGB = 4'b1001, SRA = 4'b1010, SLA = 4'b1011; 
    
    regbank bank1(.data_out1(reg_out1), .data_out2(reg_out2), .data_in(reg_in), .sr1(rs1), .sr2(rs2), .dr(L23_rd), .clk(clk1), .write(reg_write));
    RAM mem1(.data_out(mem_out), .data_in(mem_in), .addr(mem_addr), .cs(cs), .write(mem_write), .clk(clk2));
    
    
    assign zout = L34_z;
    assign reg_in = L23_z;
    assign mem_in = L34_z;
    assign mem_addr = L34_addr;
    
    always @(posedge clk1)          // stage 1
    begin
        L12_A <= reg_out1;
        L12_B <= reg_out2;
        L12_rd <= rd;
        L12_func <= func;
        L12_addr <= addr;
    end
    
    always@(posedge clk2)           //stage 2
    begin
        case(L12_func)
            ADD : L23_z <= L12_A + L12_B;
            SUB : L23_z <= L12_A - L12_B;
            MUL : L23_z <= L12_A * L12_B;
            SELA : L23_z <= L12_A;
            SELB : L23_z <= L12_B;
            AND : L23_z <= L12_A & L12_B;
            OR : L23_z <= L12_A | L12_B;
            XOR : L23_z <= L12_A ^ L12_B;
            NEGA : L23_z <= - L12_A;
            NEGB : L23_z <= - L12_B;
            SRA : L23_z <= L12_A >> 1;
            SLA : L23_z <= L12_A << 1;
            default : L23_z <= 16'h0000;
         endcase
         L23_rd <= L12_rd;
         L23_addr <= L12_addr;
    end
    
    always@(posedge clk1)           // stage 3
    begin
        //reg_write <= 1;
        L34_z <= L23_z;
        L34_addr <= L23_addr;  
    end
    
//    always@(posedge clk2)           // stage 4
//    begin
//        mem_write <= 1;
//        cs <= 1; 
//    end    

    always@(*)                        // stage 3
    begin
        if(clk1)
            reg_write = 1;
        else
            reg_write = 0;    
    end
    
    always@(*)                         // stage 4
    begin
        if(clk2) begin
            mem_write = 1;
            cs = 1; end
        else begin 
            mem_write = 0;
            cs = 0;  end
    end
    
endmodule
