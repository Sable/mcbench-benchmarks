%% Create Binary Image Data
% 
% This functoin reads in an image and creates a 
% raw binary file of that image.  We then read
% the raw image back in and display it.
%
% The purpose of this file was to create a
% portable image representation that could be
% used in the lane markings demo that did not
% require any additional libraries.
%
% This code is provided for example purposes only.
%
% Copyright 2011 MathWorks, Inc.
%

%% Start Clean
clear all; clc

%% Load Image
street1 = imread('street1.jpg');

%% Create Binary File of image
filename = 'street1.bin';
imgToRawBinaryFile(street1, filename);

%% Load Binary Image
img = rawBinaryFileToImg(filename);

%% Display img
imshow(img);
