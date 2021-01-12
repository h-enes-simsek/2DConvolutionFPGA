
clc;clear;

fileID1 = fopen('input_image.txt','r');
fileID2 = fopen('output_image.txt','r');

IN = fscanf(fileID1, '%d\n');
OUT = fscanf(fileID2, '%d\n');

% --- Reformat input image to a 130x130 matrix
in_img_temp = transpose(reshape(IN,[130 130]));

% --- Remove zero padding from input image
in_img = in_img_temp(2:end-1,2:end-1);

% --- MATLAB output of the convolution done in simulation
kernel = [1 2 1;2 4 2;1 2 1];
in_img_conv = conv2(in_img,kernel,'same')/16;  % --- MATLAB's 2-D convolution

% --- Reformat output image to a 128x128 matrix
out_img = transpose(reshape(OUT,[128 128]));
out_img = floor(out_img/16);  %-Normalize

% --- Display original image, MATLAB's result and your result
figure
imshow(uint8(in_img), [0 255]);
xlabel('original img')
figure
imshow(uint8(out_img), [0 255]);
xlabel('output img')
figure
imshow(uint8(in_img_conv), [0 255]);
xlabel('expected output')

fclose(fileID1);
fclose(fileID2);
