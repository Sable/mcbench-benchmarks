clear all
close all
clc

A = imread('XA_404_Chimaera_by_Davide_sd.jpg');
B = imread('The_Fight_by_Davide_sd.jpg');

% type: help blendMode      to see a list of blend modes aviable
mode = 'hardlight';

% move B in respect to the top-left corner of A
offsetW = 1;
offsetH = 1;

tic
imshow(blendMode(A, B, mode, offsetW, offsetH));
toc
