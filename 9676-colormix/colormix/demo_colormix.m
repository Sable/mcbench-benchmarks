% This is the test script for the colormix function.
% Author: Atakan Varol

clc
close all
clear

I = imread('lena.tif');          % Read the grayscale image
figure(1);subplot 221; imshow(I),title('Original image')

% Mix the colors with different quantization levels
O1 = colormix(I,2,0); 
subplot 222; imshow(O1),title('n=2')
O2 = colormix(I,3,0); 
subplot 223; imshow(O2),title('n=3')
O3 = colormix(I,4,0); 
subplot 224; imshow(O3),title('n=4')
