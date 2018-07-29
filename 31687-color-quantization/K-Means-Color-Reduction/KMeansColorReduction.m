%Program for creating color reduced image using K-Means clustering

%Author : Athi Narayanan S
%M.E, Embedded Systems,
%K.S.R College of Engineering
%Erode, Tamil Nadu, India.
%http://sites.google.com/site/athisnarayanan/

%Program Description
%This program generates a color reduced version of the input image.
%The input image for this program can be true color 24-bit image or indexed
%color image.
%The colors present in the output image are written as a CSV file.

%Clear Memory & Command Window
clc;
clear all;
close all;

%Input Parameters
inImgname = 'Parrot';%Input Image name
ext = '.png';%File Extension of Input Image
noOfColors = 16;%Number of colors to be present in the output
%Warning
%The program execution time will be high, if noOfColors is greater than 64.

%Input Image name
inImgPath = [inImgname, ext];

%Read Input Image
[ImgMat, inMap] = imread(inImgPath);
s_img = size(ImgMat);
s_map = size(inMap);

if(s_map(1) == 0)
    %sRGB Color Image
    inImg = ImgMat;
else
    %Indexed Color Image
    inImg = ind2rgb(ImgMat, inMap);
    inImg = round(inImg .* 255);
end

%K-Means
r = inImg(:,:,1);
g = inImg(:,:,2);
b = inImg(:,:,3);
inputImg = zeros((s_img(1) * s_img(2)), 3);
inputImg(:,1) = r(:);
inputImg(:,2) = g(:);
inputImg(:,3) = b(:);
inputImg = double(inputImg);
disp('K-Means Processing Started');
[idx, C] = kmeans(inputImg, noOfColors, 'EmptyAction', 'singleton');
disp('K-Means Processing Completed');
palette = round(C);

%Color Mapping
idx = uint8(idx);
outImg = zeros(s_img(1),s_img(2),3);
temp = reshape(idx, [s_img(1) s_img(2)]);
for i = 1 : 1 : s_img(1)
    for j = 1 : 1 : s_img(2)
        outImg(i,j,:) = palette(temp(i,j),:);
    end
end

%Writting Output Image file
outFilename = [inImgname, '_', int2str(noOfColors), ext];
imwrite(uint8(outImg), outFilename);

%Writting Color Palette as a CSV file
OutCSVName = [inImgname, '_', int2str(noOfColors), '_Palette' '.csv'];
writeCSV(palette, OutCSVName);