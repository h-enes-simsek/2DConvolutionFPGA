`timescale 1ns / 1ps


module exp8_tb();
	
    reg clk;
    wire done_conv; //done signal comes from 2-d conv circ 3x3 conv is done
    reg start;
    wire shift_right; //enable signal from ctrl fms to conv_input_reg 
    wire start_conv; //start signal from ctrl fms to 2-d conv circ
    wire [14:0] address; //address to bram 128x128 grayscale image
                           // with padding 130x130=16900 total address
    wire done; //conv process for whole image is done
    wire [7:0] data_out_bram; //bram output data
    wire [71:0] data_out_conv_input_reg; //output data from conv input reg
    wire [23:0] result; //result of the 3x3 conv
    wire [3:0] state_reg; //state reg of fsm
    wire [3:0] state_next; //next state

    top 
    UUT(
        .clk(clk),
        .start(start),
		.done(done),
        .result(result),
        .done_conv(done_conv),
        .shift_right(shift_right),
        .start_conv(start_conv),
        .address(address),
        .data_out_bram(data_out_bram),
        .data_out_conv_input_reg(data_out_conv_input_reg),
        .state_reg(state_reg),
        .state_next(state_next)
    );

	
	integer out_file;  // Output file handler ID
	

    parameter CLK_PER=45;
	initial clk = 0; 
    always begin
        #(CLK_PER) clk = ~clk; 
            
        if(done) begin
            $fclose(out_file);
           $finish();
        end
	end

	
	
	
		
	initial begin
	   #120; //VERY IMPORTANT, we need to wait at least 100ns to get correct values 
	   //from post synt and post imp sim. FPGA is under global reset for 100ns
	   
       start = 1; 
	   out_file= $fopen("output_image.txt","w");
       #(2*CLK_PER);
       start = 0;
       
	end

    always @ (posedge done_conv)  
	begin
	   #(CLK_PER/10);
	   // This will prevent recording any uncalculated results at the beginning.
	   if(result[10] === 1'bx) ;
	   else
	       $fdisplay(out_file,"%d",result);
	 end

	
endmodule
