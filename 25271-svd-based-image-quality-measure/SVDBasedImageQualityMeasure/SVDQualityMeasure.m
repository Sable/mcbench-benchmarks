%Program for SVD-based Image Quality Measure

%Program Description
% This program outputs a graphical & numerical image quality measure
% based on Singular Value Decomposition.
% For details on the implementation, please refer
% Aleksandr Shnayderman, Alexander Gusev, and Ahmet M. Eskicioglu,
% "An SVD-Based Grayscale Image Quality Measure for Local and Global Assessment",
% IEEE TRANSACTIONS ON IMAGE PROCESSING, VOL. 15, NO. 2, FEBRUARY 2006.
%
%Parameters
% refImg        -   Input Reference Gray Image
% distImg       -   Input Distorted Gray Image
% blkSize       -   Window size for block processing
% graMeasure    -   Graphical Image quality measure
% scaMeasure    -   Numerical Image quality measure
%
%Author : Athi Narayanan S
%Student, M.E, EST,
%K.S.R College of Engineering
%Erode, Tamil Nadu, India.
%s_athi1983@yahoo.co.in
%http://sites.google.com/site/athisnarayanan/

function [graMeasure, scaMeasure] = SVDQualityMeasure(refImg, distImg, blkSize)

k = size(refImg, 1);

blkx = blkSize;
blky = blkSize;

blockwise1 = MatDec(refImg,blkx);
blockwise2 = MatDec(distImg,blkx);
[blkx blky imgx imgy] = size(blockwise1);
graMeasure = zeros(imgx,imgy);
blockwise1 = double(blockwise1);
blockwise2 = double(blockwise2);

for i=1:imgx
    for j=1:imgy
        temp_in_image = blockwise1(:,:,i,j);temp_in_image=temp_in_image(:);
        original_img = reshape(temp_in_image,blkx,blky);
        temp_dist_image = blockwise2(:,:,i,j);temp_dist_image=temp_dist_image(:);
        distorted_img = reshape(temp_dist_image,blkx,blky);
        graMeasure(i,j) = sqrt(sum((svd(original_img)-svd(distorted_img)).^2));
    end
end

graMeasure = round((graMeasure/max(max(graMeasure)))*255);
graMeasure = uint8(graMeasure);

scaMeasure = sum(sum(abs(graMeasure-median(median(graMeasure)))))/((k/blkx).^2);
