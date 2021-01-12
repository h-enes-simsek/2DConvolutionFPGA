# 2dConvolutionVerilog
2D convolution implementation with 3x3 kernel and 128x128 image

#Summary
This repository has the documents I've coded in the 8th lecture of EHB 436E, İTÜ.

The design simply takes a 3x3 kernel and a 128x128 image with 1 padding stored in block ram (memeory.coe). It produces the output, 2d convolution of a pixel, in every 14 clock cycle. After all the iterations is done, it writes the output to a txt file line by line for every pixel. 

There are detailed information in the experiment file, exp8.pdf.
