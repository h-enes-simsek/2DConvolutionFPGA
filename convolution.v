`timescale 1ns / 1ps
module convolution(
    input [71:0] data_in, //data_in contains 9 byte pixel inf
    input [71:0] kernel, //kernel matrix
    input clk, reset, start,
    output reg [23:0] result, 
    output reg done
    );
    
    wire [7:0] f11, f12, f13, f21, f22, f23, f31, f32, f33, 
               w11, w12, w13, w21, w22, w23, w31, w32, w33;
               
    //data_in is parsed into pixels inf
    assign f11 = data_in[7:0];
    assign f12 = data_in[15:8];
    assign f13 = data_in[23:16];
    assign f21 = data_in[31:24];
    assign f22 = data_in[39:32];
    assign f23 = data_in[47:40];
    assign f31 = data_in[55:48];
    assign f32 = data_in[63:56];
    assign f33 = data_in[71:64];
    
    //kernel is parsed into pixels inf
    assign w33 = kernel[7:0];
    assign w32 = kernel[15:8];
    assign w31 = kernel[23:16];
    assign w23 = kernel[31:24];
    assign w22 = kernel[39:32];
    assign w21 = kernel[47:40];
    assign w13 = kernel[55:48];
    assign w12 = kernel[63:56];
    assign w11 = kernel[71:64];
    
    wire [15:0] m1,m2,m3,m4,m5,m6,m7,m8,m9; //output of multipliers
    wire done1,done2,done3,done4,done5,done6,done7,done8,done9; 
    
    multiplier_behavioral mult1(clk,reset,start,f11,w33,m1,done1);
    multiplier_behavioral mult2(clk,reset,start,f12,w32,m2,done2);
    multiplier_behavioral mult3(clk,reset,start,f13,w31,m3,done3);
    multiplier_behavioral mult4(clk,reset,start,f21,w23,m4,done4);
    multiplier_behavioral mult5(clk,reset,start,f22,w22,m5,done5);
    multiplier_behavioral mult6(clk,reset,start,f23,w21,m6,done6);
    multiplier_behavioral mult7(clk,reset,start,f31,w13,m7,done7);
    multiplier_behavioral mult8(clk,reset,start,f32,w12,m8,done8);
    multiplier_behavioral mult9(clk,reset,start,f33,w11,m9,done9);
    
    
    //carry bits of rca's, but it will be zero.
    //CO's are just procedural
    wire CO1,CO2,CO3,CO4,CO5,CO6,CO7,CO8;
    wire [23:0] S1,S2,S3,S4,S5,S6,S7,resultTEMP;
    
    parametric_RCA #(24) rca1({8'd0,m1},{8'd0,m2},0,CO1,S1);
    parametric_RCA #(24) rca2({8'd0,m3},{8'd0,m4},0,CO2,S2);
    parametric_RCA #(24) rca3({8'd0,m5},{8'd0,m6},0,CO3,S3);
    parametric_RCA #(24) rca4({8'd0,m7},{8'd0,m8},0,CO4,S4);
    
    parametric_RCA #(24) rca5(S1,S2,0,CO5,S5);
    parametric_RCA #(24) rca6(S3,S4,0,CO6,S6);
    
    parametric_RCA #(24) rca7(S5,S6,0,CO7,S7);
    
    parametric_RCA #(24) rca8(S7,{8'd0,m9},0,CO8,resultTEMP);

/*
    always @(resultTEMP) begin
        if(start) begin
            if (^resultTEMP === 1'bX)
                done <= 0;
            else begin
                result <= resultTEMP;
                done <= 1;
            end
         end 
         else
            done <= 0;
    end*/
    
    initial begin
        done = 0; //to prevent xx in the beginning
        result = 0; //to prevent xx in the beginning
    end
    
    reg delay = 0;
    reg delay2 = 0;
    always @(posedge clk) begin
        if ((delay==0) & (start==1)) 
            delay <= start;
        
        else if((delay==1) & (start==1)) begin
            result <= resultTEMP;
            done <= 1;
            delay <=0;
        end
        if(delay2==1) begin
            done <= 0;
            delay <= 0;
        end
        delay2 <= delay;
    end
    
    /*
    //to set done to zero after two clock cycle
    reg done_temp = 0;
    always @(posedge clk) begin
        if(done_temp==1)
            done = 0;
        done_temp = done;
    end
    */

    
endmodule
