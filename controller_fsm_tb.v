`timescale 1ns / 1ps
module controller_fsm_tb();
    reg clk;
    reg done_conv; //done signal comes from 2-d conv circ
    reg start;
    wire shift_right; //enable signal to conv_input_reg 
    wire start_conv; //start signal to 2-d conv circ
    wire [14:0] address; //address to bram 128x128 grayscale image
                           // with padding 130x130=16900 total address
    wire done; //conv process for whole image is done
    
    controller_fsm uut(clk,done_conv,start,shift_right,start_conv,address,done);
    
    parameter CLK_PER=50;
	initial clk = 0; 
    always #(CLK_PER) clk = ~clk; 
    
    initial begin
    start = 1;
    done_conv = 0;
    #200;
    start = 0; //if start wouldnt set to be 0, circuit doesnt stop.
    repeat(16384) begin
        done_conv = 0; //assume 2-d conv circuit is running
        #(26*CLK_PER);
        done_conv = 1; //assume 2-d conv circ done
        #(2*CLK_PER);
    end
    #500;
    $finish();

    end
    
    

endmodule
