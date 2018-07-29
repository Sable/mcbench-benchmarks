function [Lrgb bgm] = watershed_seg(ip_wshed,ip_img)
% Watershed segmentation algorithm

se = strel('disk', 5); % disk = 20
%Opening
Io = imopen(ip_img, se);

%Opening-by-reconstruction (Iobr)
Ie = imerode(ip_img, se);
Iobr = imreconstruct(Ie, ip_img);

%Opening-closing (Ioc)
Ioc = imclose(Io, se);

%Opening-closing by reconstruction (Iobrcbr)
Iobrd = imdilate(Iobr, se);
Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
Iobrcbr = imcomplement(Iobrcbr);

%Regional maxima of opening-closing by reconstruction (fgm)
fgm = imregionalmax(Iobrcbr);

%Regional maxima superimposed on original image (I2)
I2 = ip_img;
I2(fgm) = 255;

se2 = strel(ones(3, 3)); % ones(5,5)
fgm2 = imclose(fgm, se2);
fgm3 = imerode(fgm2, se2);

fgm4 = bwareaopen(fgm3, 20); %(fgm3, 20)
 
%Modified regional maxima superimposed on original image (fgm4)
I3 = ip_img;
I3(fgm4) = 255;

%Thresholded opening-closing by reconstruction (bw)
bw = im2bw(Iobrcbr, graythresh(Iobrcbr));

%Watershed ridge lines (bgm)
D = bwdist(bw);
DL = watershed(D);
bgm = DL == 0;

gradmag2 = imimposemin(ip_wshed, bgm | fgm4);

L = watershed(gradmag2);

%Markers and object boundaries superimposed on original image (I4)
I4 = ip_img;
I4(imdilate(L == 0, ones(3, 3)) | bgm | fgm4) = 255;

Lrgb = label2rgb(L, 'jet', 'w', 'shuffle');