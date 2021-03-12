# 2dConvolutionVerilog
2D convolution implementation for 3x3 kernel and (128+1)x(128+1) image with 1 padding

# Summary
This repository has the documents I've coded in the 8th lecture of EHB 436E, İTÜ.

The design simply takes a 3x3 kernel and a (128+1)x(128+1) image with 1 padding stored in block ram (bram IP should be added, initial memory is memory.coe). It produces the output, 2d convolution of a pixel, in every 14 clock cycle. After all the iterations is done, it writes the output to a txt file, output_image.txt line by line for every pixel. 

It is possible to check the outcomes with MATLAB. input_image.txt is the original image in the format that every line has one pixel information (grayscale). matlab file applies 2d convolution to both input_image.txt and output_image.txt and shows images.

There are detailed information in the experiment file, exp8.pdf.

Max frequency of the design is about 11.1 MHz (90 ns clock period). Only tested in simulation with Nexys4-DDR in Vivado.
