`timescale 1ns / 1ps

module alu(
    input [15:0] A, B,
    input [3:0] opcode,
    output reg [15:0] Z,
    output reg overflow, carry,
    output zero, negative
    );
    
    reg signed [31:0] temp;
    
    parameter ADD = 4'b0000, SUB = 4'b0001, MUL = 4'b0010, SELA = 4'b0011, SELB = 4'b0100, AND = 4'b0101, OR = 4'b0110, 
              XOR = 4'b0111, NEGA = 4'b1000, NEGB = 4'b1001, SRA = 4'b1010, SLA = 4'b1011;
    
    
    always@(*)
    begin
        carry = 1'b0;
        overflow = 1'b0;
        temp = 32'b0;
        case(opcode)
            ADD : begin 
                   {carry, Z} = {1'b0, A} + {1'b0, B};
                    overflow = (~(A[15]^B[15]) & (A[15]^Z[15])); 
                  end
            SUB : begin
                    {carry, Z} = {1'b0, A} - {1'b0, B};
                    overflow = (A[15]^B[15]) & (A[15]^Z[15]);
                  end
            MUL : begin
                    temp = $signed(A) * $signed(B);
                    Z = temp[15:0];
                    overflow = |(temp[31:16]^{16{Z[15]}});
                  end
            SELA : Z = A;
            SELB : Z = B;
            AND : Z = A & B;
            OR : Z = A | B;
            XOR : Z = A ^ B;
            NEGA : Z = - A;
            NEGB : Z = - B;
            SRA : Z = A >> 1;
            SLA : Z = A << 1;
            default : Z = 16'h0000;
         endcase    
    end
    
    assign zero = ~|Z;
    assign negative = Z[15];
                       
endmodule
