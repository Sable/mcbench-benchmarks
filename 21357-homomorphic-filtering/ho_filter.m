
% 
% MATLAB code that performs Homomorphic filtering, Using Butterworth
% High Pass Filter for performing filtering.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
close all
clear all
d=10;
order=2;
im=double(imread('tun.jpg'));
subplot(121)
imshow(im./255);
[r c]=size(im);
homofil(im,d,r,c,order);
