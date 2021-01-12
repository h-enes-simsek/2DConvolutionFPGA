`timescale 1ns / 1ps

module half_adder(
    input A,B,
    output C,S
    );

(* dont_touch *) assign C = A & B;
(* dont_touch *) assign S = A ^ B; //XOR
    
endmodule

module full_adder(
    input A,B,CI,
    output CO,S
    );

wire half_adder1_s,half_adder1_c;
wire half_adder2_s,half_adder2_c;
(* dont_touch *) half_adder half_adder1(A,B,half_adder1_c,half_adder1_s);
(* dont_touch *) half_adder half_adder2(CI,half_adder1_s,half_adder2_c,half_adder2_s);
(* dont_touch *) assign CO = half_adder1_c | half_adder2_c;
(* dont_touch *) assign S = half_adder2_s;
endmodule

module ripple_carry_adder(    
    input [3:0] A, B, 
    input CI,
    output CO, 
    output [3:0] S);

wire fac0, fac1, fac2;
(* dont_touch *) full_adder fa0(A[0],B[0],CI,fac0,S[0]);
(* dont_touch *) full_adder fa1(A[1],B[1],fac0,fac1,S[1]);
(* dont_touch *) full_adder fa2(A[2],B[2],fac1,fac2,S[2]);
(* dont_touch *) full_adder fa3(A[3],B[3],fac2,CO,S[3]);
endmodule


module parametric_RCA #(parameter SIZE = 8)
(   input [SIZE-1:0] A, B, 
    input CI,
    output CO, 
    output [SIZE-1:0] S);
    
    wire fac[SIZE-1:0];//ith full adder carry bit
    
    genvar i;
    generate
        for (i = 0; i < SIZE; i = i + 1) begin: generated_fa
            //first fa gets CI as input
            if (i==0) begin: test1
                (* dont_touch *) full_adder fa(A[i],B[i],CI,fac[i],S[i]); 
            end else
            //carry of the last fa is the CO
            if (i==SIZE-1) begin: test2
                (* dont_touch *) full_adder fa(A[i],B[i],fac[i-1],CO,S[i]); 
            end else
            //fa's in the middle gets prev carry from prev fa,
            //send own carry to next fa
            (* dont_touch *) full_adder fa(A[i],B[i],fac[i-1],fac[i],S[i]);
        end
    endgenerate
endmodule

module CLA (   
    input [3:0] A, B, 
    input CI,
    output CO, 
    output [3:0] S);
    
wire p0,p1,p2,p3;
(* dont_touch *) assign p0 = A[0] ^ B[0];
(* dont_touch *) assign p1 = A[1] ^ B[1];
(* dont_touch *) assign p2 = A[2] ^ B[2];
(* dont_touch *) assign p3 = A[3] ^ B[3];

wire g0,g1,g2,g3;
(* dont_touch *) assign g0 = A[0] & B[0];
(* dont_touch *) assign g1 = A[1] & B[1];
(* dont_touch *) assign g2 = A[2] & B[2];
(* dont_touch *) assign g3 = A[3] & B[3];

wire c1,c2,c3;
(* dont_touch *) assign c1 = g0 | (p0&CI);
(* dont_touch *) assign c2 = g1 | (p1&g0) | (p1&p0&CI);
(* dont_touch *) assign c3 = g2 | (p2&g1) | (p2&p1&g0) | (p2&p1&p0&CI);
(* dont_touch *) assign CO = g3 | (p3&g2) | (p3&p2&g1) | (p3&p2&p1&g0) | (p3&p2&p1&p0&CI);
    
(* dont_touch *) assign S[0] = p0 ^ CI;
(* dont_touch *) assign S[1] = p1 ^ c1;
(* dont_touch *) assign S[2] = p2 ^ c2;
(* dont_touch *) assign S[3] = p3 ^ c3;
endmodule
    
module signed_RCA(    
    input [3:0] A, B, 
    input CI,
    output CO, 
    output [3:0] S);

wire fac0, fac1, fac2, fac3;
(* dont_touch *) full_adder fa0(A[0],B[0],CI,fac0,S[0]);
(* dont_touch *) full_adder fa1(A[1],B[1],fac0,fac1,S[1]);
(* dont_touch *) full_adder fa2(A[2],B[2],fac1,fac2,S[2]);
(* dont_touch *) full_adder fa3(A[3],B[3],fac2,fac3,S[3]);

//to prevent overflow
//(* dont_touch *) assign CO = fac3 & (fac3 ^ fac2);
(* dont_touch *) assign CO = ((fac3 ^ fac2) & fac3) |(!(fac3 ^ fac2) & S[3]);
endmodule