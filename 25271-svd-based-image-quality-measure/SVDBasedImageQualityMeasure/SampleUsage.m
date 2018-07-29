%Program for SVD-based Image Quality Measure

%Program Description
% This program outputs a graphical & numerical image quality measure
% based on Singular Value Decomposition.
% For details on the implementation, please refer
% Aleksandr Shnayderman, Alexander Gusev, and Ahmet M. Eskicioglu,
% "An SVD-Based Grayscale Image Quality Measure for Local and Global Assessment",
% IEEE TRANSACTIONS ON IMAGE PROCESSING, VOL. 15, NO. 2, FEBRUARY 2006.
%
%Author : Athi Narayanan S
%Student, M.E, EST,
%K.S.R College of Engineering
%Erode, Tamil Nadu, India.
%s_athi1983@yahoo.co.in
%http://sites.google.com/site/athisnarayanan/

%Sample Usage

clc;
close all;
clear all;

%Read Input Reference Gray Image
refImg=imread('lena256.bmp');
figure;subplot(121);
imshow(refImg);title('Orginal Image');

%Read Input Distorted Gray Image
distImg = imread('gaussian_noise_10.bmp');
subplot(122);
imshow(distImg);title('Distorted Image');

blkSize = 8;

[graMeasure, scaMeasure] = SVDQualityMeasure(refImg, distImg, blkSize);

figure;imshow(graMeasure);title('Graphical Measure');
disp('Numerical Measure');
disp(scaMeasure);
