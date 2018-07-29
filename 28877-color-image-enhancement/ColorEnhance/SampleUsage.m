
%Author : Athi Narayanan S
%M.E, Embedded Systems,
%K.S.R College of Engineering
%Erode, Tamil Nadu, India.
%http://sites.google.com/site/athisnarayanan/

clc;
close all;
% clear all;

inImg = imread('lg-image16.jpg');
figure;imshow(inImg);title('Input Image');

s_inImg = size(inImg);
outImg = zeros(s_inImg);
ycbcrOutImg = zeros(s_inImg);

%DCT Parameters
blkSize = 8;


ycbcrInImg = rgb2ycbcr(inImg);
y_inImg = ycbcrInImg(:,:,1);
cb_inImg = ycbcrInImg(:,:,2);
cr_inImg = ycbcrInImg(:,:,3);

I_max = max(max(y_inImg));

%Block-wise Splitting
y_blocks = Mat_dec(y_inImg, blkSize);

s = size(y_blocks);
dctBlks = zeros(s);

for i = 1 : s(3)
    for j = 1 : s(4)
        localBlk = y_blocks(:,:,i,j);
        localdctBlk = dct2(localBlk);
        
        localdctBlk = localdctBlk ./ 8;
        
        orig_dc = localdctBlk(1,1);
        
        %Adjustment of Local Background Illumination
        x = localdctBlk(1,1) / double(I_max);
        mapped_dc = x * (2 - x) * double(I_max);
        
        %Preservation of Local Contrast
        k = mapped_dc / orig_dc;
        
        localdctBlk(1,1) = k * localdctBlk(1,1);
        
        dctBlks(:,:,i,j) = localdctBlk;
    end
end

dctImg = merge_blocks(dctBlks);

dctImg = dctImg .* 8;

y_outImg = blkproc(dctImg, [8 8], 'idct2(x)');

ycbcrOutImg(:,:,1) = y_outImg;
ycbcrOutImg(:,:,2) = cb_inImg;
ycbcrOutImg(:,:,3) = cr_inImg;

ycbcrOutImg = uint8(ycbcrOutImg);

rgbOutImg = ycbcr2rgb(ycbcrOutImg);

figure;imshow(rgbOutImg);title('DC Adjustment');
