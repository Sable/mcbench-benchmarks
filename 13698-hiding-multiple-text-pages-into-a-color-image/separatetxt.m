function [im_tx1 im_tx2] = separatetxt(im_iltx)
% This function extracts the Text content from the interleaved text image 'im_iltx'
% As two Text images are arranged in interleaved manner, Only 50% of actual Text
% content can be retrived. Remaining pixels are populated by interpolating
% adjacent pixels
% im_iltx - Input Interleaved Text image
% im_tx1  - Output extracted Text image 1,3,5 from im_iltx
% im_tx2  - Output extracted Text image 2,4,6 from im_iltx

% Extract Odd pixel columns of Text image 1,3,5
im_tx1(1:2:size(im_iltx,1)  ,1:2:size(im_iltx,2),:) = im_iltx(1:2:size(im_iltx,1)  ,1:2:size(im_iltx,2),:);
im_tx1(2:2:size(im_iltx,1)-1,1:2:size(im_iltx,2),:) = im_tx1 (3:2:size(im_iltx,1)  ,1:2:size(im_iltx,2),:);
% Extract Even pixel columns of Text image 1,3,5
im_tx1(2:2:size(im_iltx,1)  ,2:2:size(im_iltx,2),:) = im_iltx(2:2:size(im_iltx,1)  ,2:2:size(im_iltx,2),:);
im_tx1(1:2:size(im_iltx,1)  ,2:2:size(im_iltx,2),:) = im_tx1 (2:2:size(im_iltx,1)  ,2:2:size(im_iltx,2),:);
% Interpolation of Last pixel column
im_tx1(    size(im_iltx,1)  ,1:2:size(im_iltx,2),:) = im_tx1 (    size(im_iltx,1)-1,2:2:size(im_iltx,2),:);

% Extract Odd pixel columns of Text image 2,4,6
im_tx2(2:2:size(im_iltx,1)  ,1:2:size(im_iltx,2),:) = im_iltx(2:2:size(im_iltx,1)  ,1:2:size(im_iltx,2),:);
im_tx2(1:2:size(im_iltx,1)  ,1:2:size(im_iltx,2),:) = im_tx2 (2:2:size(im_iltx,1)  ,1:2:size(im_iltx,2),:);
% Extract Even pixel columns of Text image 2,4,6
im_tx2(1:2:size(im_iltx,1)  ,2:2:size(im_iltx,2),:) = im_iltx(1:2:size(im_iltx,1)  ,2:2:size(im_iltx,2),:);
im_tx2(2:2:size(im_iltx,1)-1,2:2:size(im_iltx,2),:) = im_tx2 (3:2:size(im_iltx,1)  ,2:2:size(im_iltx,2),:);
% Interpolation of Last pixel column
im_tx2(    size(im_iltx,1)  ,2:2:size(im_iltx,2),:) = im_tx2 (    size(im_iltx,1)-1,1:2:size(im_iltx,2),:);