function [im_alt] = altertxt(im_tx1,im_tx2)
% This function arrange the pixels alternatively from Text image 1 and 2, and 
% returns the interleaved Text image
% im_tx1 - Input Text image 1,3,5 to be encoded
% im_tx2 - Input Text image 2,4,6 to be encoded
% im_alt - Output Interleaved Text image

% Locate Text images 1 and 2 in Odd pixel columns
im_alt(1:2:size(im_tx1,1)-1,1:2:size(im_tx1,2)-1,:) = im_tx1(1:2:size(im_tx1,1)-1,1:2:size(im_tx1,2)-1,:);
im_alt(2:2:size(im_tx1,1)  ,1:2:size(im_tx1,2)-1,:) = im_tx2(2:2:size(im_tx2,1)  ,1:2:size(im_tx2,2)-1,:);
% Locate Text images 1 and 2 in Even pixel columns
im_alt(1:2:size(im_tx1,1)-1,2:2:size(im_tx1,2)  ,:) = im_tx2(1:2:size(im_tx2,1)-1,2:2:size(im_tx2,2)  ,:);
im_alt(2:2:size(im_tx1,1)  ,2:2:size(im_tx1,2)  ,:) = im_tx1(2:2:size(im_tx1,1)  ,2:2:size(im_tx1,2)  ,:);
