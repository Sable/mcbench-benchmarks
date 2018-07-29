

clear all; close all; clc;

[filename1,pathname]=uigetfile('*.*','select the image'); 
image1=imread(num2str(filename1));
figure(1);
imshow(image1);	title('original image');     % orginal image for watermarking
image1=double(image1);

[row,col]=size(image1);

imagew=imread('dmg2.tif');


[marked]=blockdwt2(image1,imagew);  % generates the watermarked image

markedmax = max(marked(:));
markscale = marked/markedmax*255;

figure(2);
colormap(gray(256));
image(marked);							% shows the watermarked image
title('Watermarked image');
imwrite(marked,gray(256),'marked_image.bmp');	% saves the watermarked image as a bmp file
figure(3);
watermark=image1-marked;			% image adaptive watermark
watermark=watermark*255/max(watermark(:));

for i = 1:row                       % thresholding
     for j = 1:col
        if watermark(i,j) > 70 
            watermark(i,j) = 255;
        end
        if watermark(i,j) < 70
            watermark (i,j) = 0;
        end
    end
end

colormap(gray(256));
image(watermark);						% shows the image adaptive watermark
title('watermark');
imwrite(marked,gray(256),'watermark.bmp');		% saves the image adaptive watermark as a bmp file



