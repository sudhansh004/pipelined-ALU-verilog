`timescale 1ns / 1ps

module pipeline(
    input [3:0] rs1, rs2, rd, func,
    input [7:0] addr,
    input clk, rst_n, 
    output [15:0] zout
    );
    
    // latch 1-2
    reg [15:0] L12_A, L12_B;        
    reg [3:0] L12_rd, L12_func;
    reg [7:0] L12_addr;
    reg L12_reg_write, L12_mem_write, L12_cs;
    
    // latch 2-3
    reg [15:0] L23_z;               
    reg [3:0] L23_rd;
    reg [7:0] L23_addr;
    reg L23_reg_write, L23_mem_write, L23_cs;
    
    // latch 3-4
    reg [15:0] L34_z;               
    reg [7:0] L34_addr;
    reg L34_mem_write, L34_cs;
    
    // regbank and memory ports
    wire [15:0] reg_out1, reg_out2, reg_in, mem_out, mem_in;
    wire [7:0] mem_addr;
    
    // alu ports
    wire [15:0] alu_out;
    wire overflow, zero, negative, carry;
    reg [3:0] flag_register;
    
    // regbank and memory instantiation
    regbank bank1(.data_out1(reg_out1), .data_out2(reg_out2), .data_in(reg_in), .sr1(rs1), .sr2(rs2), .dr(L23_rd), .clk(clk), .write(L23_reg_write));
    RAM mem1(.data_out(mem_out), .data_in(mem_in), .addr(mem_addr), .cs(L34_cs), .write(L34_mem_write), .clk(clk));
    
    //ALU instantiation
    alu alu_inst(.A(L12_A), .B(L12_B), .opcode(L12_func), .Z(alu_out), .overflow(overflow), .carry(carry), .zero(zero), .negative(negative));
    
    assign zout = L34_z;
    assign reg_in = L23_z;
    assign mem_in = L34_z;
    assign mem_addr = L34_addr;
    
    // stage 1
    always @(posedge clk or negedge rst_n)          
    begin
        if(!rst_n)
        begin
            L12_A <= 0;
            L12_B <= 0;
            L12_rd <= 0;
            L12_func <= 0;
            L12_addr <= 0;
            L12_reg_write <= 0;
            L12_mem_write <= 0;
            L12_cs <= 0;
        end
        else
        begin
            L12_A <= reg_out1;
            L12_B <= reg_out2;
            L12_rd <= rd;
            L12_func <= func;
            L12_addr <= addr;
            L12_reg_write <= 1'b1;
            L12_mem_write <= 1'b1;
            L12_cs <= 1'b1;
        end
        
    end
    
    //stage 2
    always@(posedge clk or negedge rst_n)           
    begin
        if(!rst_n)
        begin
            L23_z <= 0;
            L23_rd <= 0;
            L23_addr <= 0;
            L23_reg_write <= 0;
            L23_mem_write <= 0;
            L23_cs <= 0; 
            flag_register <= 0;
        end
        else
        begin
            L23_z <= alu_out;
            L23_rd <= L12_rd;
            L23_addr <= L12_addr;
            flag_register <= {overflow, carry, zero, negative};
            L23_reg_write <= L12_reg_write;
            L23_mem_write <= L12_mem_write;
            L23_cs <= L12_cs; 
        end
    end
    
    // stage 3
    always@(posedge clk or negedge rst_n)           
    begin
        if(!rst_n)
        begin
            L34_z <= 0;
            L34_addr <= 0;
            L34_mem_write <= 0;
            L34_cs <= 0;
        end
        else
        begin
            L34_z <= L23_z;
            L34_addr <= L23_addr;
            L34_mem_write <= L23_mem_write;
            L34_cs <= L23_cs; 
        end
    end  
    
endmodule
