%% This script generates an input 3D image

%   Copyright by Quan Wang, 2012/12/16
%   Please cite: Quan Wang. GMM-Based Hidden Markov Random Field for 
%   Color Image and 3D Volume Segmentation. arXiv:1212.4527 [cs.CV], 2012.

clear;clc;close all;

I=zeros([50 50 50]);
center=[25 25 25];
R=20;

for i=1:50
    for j=1:50
        for k=1:50
            d=norm([i j k]-center);
            if d<R
                I(i,j,k)=100;
            end
        end
    end
end

I=I+rand([50 50 50])*120;
I=round(I);

delete Image.raw;
fid=fopen('Image.raw','w');
fwrite(fid,I,'uint8');
fclose(fid);