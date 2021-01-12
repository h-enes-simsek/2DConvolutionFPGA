`timescale 1ns / 1ps
module controller_fsm(
    input clk,
    input done_conv, //done signal comes from 2-d conv circ
    input start,
    output reg shift_right, //enable signal to conv_input_reg 
    output reg start_conv, //start signal to 2-d conv circ
    output reg [14:0] address, //address to bram 128x128 grayscale image
                           // with padding 130x130=16900 total address
    output reg done, //conv process for whole image is done
    output reg [3:0] state_reg, //current state
    output reg [3:0] state_next //nexT state
    );
    
    
    reg signed [14:0] i,j; // ith and jth pixels, max 127 //eskiden boyutu 7:0 idi
    reg signed [14:0] i_temp,j_temp; //neighbours of i and j, will be used in states 
    reg [3:0]    //state definitions
        IDLE = 4'd0,
        RP1 = 4'd1,
        RP2 = 4'd2,
        RP3 = 4'd3,
        RP4 = 4'd4,
        RP5 = 4'd5,
        RP6 = 4'd6,
        RP7 = 4'd7,
        RP8 = 4'd8,
        RP9 = 4'd9,
        CONV = 4'd10,
        INCREASE_J = 4'd11,
        INCREASE_I = 4'd12;
        
    initial begin
    state_reg = IDLE;   //initial state is idle
    i = 0;
    j = 0;
    start_conv = 0; //to prevent 2d conv start working at the beginning
    address = 0; //to prevent xx at the begginning
    shift_right = 0; //to prevent xx at the begginning
    done = 0; //to prevent xx at the begginning
    end
    

    
    //state transitions
    always @(posedge clk) begin
        //$display("i:%d j:%d",i,j);
        case(state_reg)
            IDLE: begin
                    if(start) begin 
                        done = 0;
                        i=0;
                        j=0;
                        state_next=RP1;
                    end
                    else 
                        state_next=IDLE;
                  end
            RP1: begin
                    shift_right = 1;
                    i_temp = i-1;
                    j_temp = j-1;
                    state_next=RP2; //unconditional
                 end
            RP2: begin
                    i_temp = i-1;
                    j_temp = j;
                    state_next=RP3; //unconditional
                 end
            RP3: begin
                    i_temp = i-1;
                    j_temp = j+1;
                    state_next=RP4; //unconditional
                 end
            RP4: begin
                    i_temp = i;
                    j_temp = j-1;
                    state_next=RP5; //unconditional
                 end
            RP5: begin
                    i_temp = i;
                    j_temp = j;
                    state_next=RP6; //unconditional
                 end
            RP6: begin
                    i_temp = i;
                    j_temp = j+1;
                    state_next=RP7; //unconditional
                 end
            RP7: begin
                    i_temp = i+1;
                    j_temp = j-1;
                    state_next=RP8; //unconditional
                 end
            RP8: begin
                    i_temp = i+1;
                    j_temp = j;
                    state_next=RP9; //unconditional
                 end
            RP9: begin
                    i_temp = i+1;
                    j_temp = j+1;
                    state_next=CONV; //unconditional
                 end
            CONV: begin
                    shift_right = 0;
                    start_conv = 1;
                    if(done_conv) state_next=INCREASE_J;
                    else          state_next=CONV;
                  end
            INCREASE_J: begin
                          start_conv = 0;
                          if(j==127) state_next=INCREASE_I;
                          else begin
                                     j = j + 1;
                                     state_next=RP1;
                          end
                        end
            INCREASE_I: begin
                          if(i==127) begin 
                                     done = 1;
                                     state_next=IDLE;
                          end
                          else begin
                                     j = 0;
                                     i = i + 1;
                                     state_next=RP1;
                          end
                        end
        endcase
        state_reg <= state_next;
    end
    
    // output address in terms of i and j
    always @(i_temp,j_temp) begin
        address = (130*(i_temp+1))+(j_temp+1);
        //$display("i_temp:%d j_temp:%d adress:%d",i_temp,j_temp,address);
    end
    
    
endmodule
