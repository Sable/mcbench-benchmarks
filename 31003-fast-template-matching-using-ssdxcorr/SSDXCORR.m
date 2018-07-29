function [S,c,r] = SSDXCORR(f,t)

% function SSDXCORR: accelerated SSD using XCORR
%
% Detail method information, check the paper below
% -------------------------------------------------------------------------
% F. Essannouni, R. Oulad Haj Thami, D. Aboutajdine and A. Salam, 
% "Simple noncircular correlation method for exhaustive sum square difference matching", 
% Opt. Eng. 46, 107004 (Oct 03, 2007); doi:10.1117/1.2786469 
% -------------------------------------------------------------------------
%
% Inputs: f = frame image, 2 dimensional image
%         t = template image, 2 diminsional image
% Output: S = SSD score space
%         figure with the global maximum marked as the ROI
%
% -------------------------------------------------------------------------
% By Yue Wu
% ECE Dept
% Tufts University
% 04/10/2011
% -------------------------------------------------------------------------
%
% Demo: 
% f = imread('cameraman.tif');figure,imshow(f),title('Frame Image')
% t = imcrop(f,[190,104,31,65]);figure,imshow(t),title('Template Image')
% S = SSDXCORR(f,t);
%
% -------------------------------------------------------------------------

% Initialization
t = double(t);
f = double(f);

% Complex template construction
tc = 2*t*1i-1;
fc = f.^2+f*1i;

% SSD using XCORR
tc = rot90(tc,2);
m = conv2(fc,conj(tc),'same');
S = real(m);

% Result display
figure,imshow(uint8(f),[]),colormap(gray)
[v,ind] = max(S(:));
[c,r] = ind2sub([size(S,1),size(S,2)],ind);
[w,h] = size(t);
rectangle('Position',[r-round(h/2), c-round(w/2), h, w],'EdgeColor','g','LineWidth',2);
