%Sample to perform image registration using ExtPhaseCorrelation.m
%
%                                               eL-ardiansyah
%                                               January, 2010
%                                                       CMIIW
%============================================================
clc
img1 = imread('1.bmp');
img1 = rgb2gray(img1);
img2 = imread('2.bmp');
img2 = rgb2gray(img2);
[deltaX, deltaY] = ExtPhaseCorrelation(img1,img2)
% img1 = imread('1.bmp');
% img1 = rgb2gray(img1);
% img2 = imread('3.bmp');
% img2 = rgb2gray(img2);
% [deltaX, deltaY] = ExtPhaseCorrelation(img1,img2)
% img1 = imread('1.bmp');
% img1 = rgb2gray(img1);
% img2 = imread('4.bmp');
% img2 = rgb2gray(img2);
% [deltaX, deltaY] = ExtPhaseCorrelation(img1,img2)