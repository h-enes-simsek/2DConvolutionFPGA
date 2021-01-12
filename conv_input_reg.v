`timescale 1ns / 1ps
// every clock conv_input_reg takes 8-bit pixel value from bram
// stores them in vector whose length 72bit=9byte 9 pixel
// sends to 2-d conv circuit
// every 9 clock 2-d conv circuit should be run
module conv_input_reg(
    input clk, enable,
    input [7:0] data_in,
    output reg [71:0] data_out
    );
    initial begin
        data_out = 0;
    end
    
    //there is problem with clock caused by negedge clk
    //enable should remain one more clock cycle
    reg extented_enable;
    initial 
        extented_enable = 0;
        
    always @(negedge clk) begin
        if(enable|extented_enable) begin
            //#50;
            data_out = data_out >> 8; //shift right 1 byte
            data_out[71:64] = data_in; //MSByte of data_out
        end
        extented_enable <= enable;
    end
endmodule
