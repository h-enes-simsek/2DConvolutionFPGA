`timescale 1ns / 1ps
module top(
    input clk,
    output done_conv, //done signal comes from 2-d conv circ 3x3 conv is done
    input start,
    output shift_right, //enable signal from ctrl fms to conv_input_reg 
    output start_conv, //start signal from ctrl fms to 2-d conv circ
    output [14:0] address, //address to bram 128x128 grayscale image
                           // with padding 130x130=16900 total address
    output done, //conv process for whole image is done
    output [7:0] data_out_bram, //bram output data
    output [71:0] data_out_conv_input_reg, //output data from conv input reg
    output [23:0] result, //result of the 3x3 conv
    output [3:0] state_reg, //state reg of fsm
    output [3:0] state_next //nexT state
    );
    
    controller_fsm ctrl_fsm1(
        clk, //input
        done_conv, //input from conv2d
        start, //input
        shift_right,
        start_conv,
        address,
        done,
        state_reg,
        state_next
    );
    
    block_ram bram1 (
        .clka(clk),    // input wire clka
        .wea(0),      // input wire [0 : 0] write enable
        .addra(address),  // input wire [14 : 0] addra
        .dina(0),    // input wire [7 : 0] dina
        .douta(data_out_bram)  // output wire [7 : 0] douta
    );
    
    conv_input_reg conv_input_organizer(
        .clk(clk),
        .enable(shift_right), //enable is shift_right signal coming from ctrl_fsm
        .data_in(data_out_bram), //from bram to conv input reg
        .data_out(data_out_conv_input_reg) //from conv input reg to 2-d conv circ
    );
    
    wire [71:0] kernel = {{8'd1},{8'd2},{8'd1},
                          {8'd2},{8'd4},{8'd2},
                          {8'd1},{8'd2},{8'd1}};
    convolution conv2d(
    .data_in(data_out_conv_input_reg), //from conv_input_reg to 2-d conv circ
    .kernel(kernel), 
    .clk(clk), 
    .reset(0), 
    .start(start_conv),
    .result(result), 
    .done(done_conv) //3x3 conv is done
    );
endmodule
