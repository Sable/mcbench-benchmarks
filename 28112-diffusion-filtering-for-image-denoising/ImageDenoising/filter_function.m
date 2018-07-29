% CAP 6516 Medical Image Processing Programming Assignment 1
% Author: Ritwik K Kumar, Dept. of CISE, UFL
% (c) 2006 Ritwik K Kumar

% this function is called by other m files

function [smth] = filter_function(image, sigma);
% This function smooths the image with a Gaussian filter of width sigma

smask = fspecial('gaussian', ceil(3*sigma), sigma);
smth = filter2(smask, image, 'same');