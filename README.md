# 2dConvolutionVerilog
2D convolution implementation for 3x3 kernel and 128x128 image with 1 padding

# Summary
This repository has the documents I've coded in the 8th lecture of EHB 436E, İTÜ.

The design simply takes a 3x3 kernel and a 128x128 image with 1 padding stored in block ram (bram IP should be added, initial memory is memory.coe). It produces the output, 2d convolution of a pixel, in every 14 clock cycle. After all the iterations is done, it writes the output to a txt file line by line for every pixel. 

There are detailed information in the experiment file, exp8.pdf.

Max frequency of the design is 11.1 MHz (90 ns clock period).
