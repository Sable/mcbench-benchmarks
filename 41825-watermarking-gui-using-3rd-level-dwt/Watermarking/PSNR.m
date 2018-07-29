function [ out ] = PSNR( pic1,pic2 )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
e=MSE(pic1,pic2);
m=max(max(pic1));
out=10*log((double(m)^2)/e);
end

