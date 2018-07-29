%Program for Construction of a two-out-of-two Visual Cryptography Scheme

%Author : Athi Narayanan S
%M.E, Embedded Systems,
%K.S.R College of Engineering
%Erode, Tamil Nadu, India.
%http://sites.google.com/site/athisnarayanan/
%s_athi1983@yahoo.co.in

%Program Description
%This program is the main entry of the application.
%This program generates a two-out-of-two Visual Cryptography Scheme shares.
%The input image for this program should be a binary image.
%The shares and the overlapping result of the shares are written as output.
%The Shares (1 & 2) can be printed in separate transparent sheets and overlapping them 
%reveals the secret image.

%Clear Memory & Command Window
clc;
clear all;
close all;

%Read Input Binary Secret Image
inImg = imread('athi.bmp');
figure;imshow(inImg);title('Secret Image');

%Visual Cryptography
[share1, share2, share12] = VisCrypt(inImg);

%Outputs
figure;imshow(share1);title('Share 1');
figure;imshow(share2);title('Share 2');

figure;imshow(share12);title('Overlapping Share 1 & 2');

imwrite(share1,'Share1.bmp');
imwrite(share2,'Share2.bmp');
imwrite(share12,'Overlapped.bmp');