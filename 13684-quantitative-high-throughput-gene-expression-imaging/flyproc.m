function [rsmooth,gsmooth,bsmooth,stdim] = flyproc(im)

% This function contains the same algorithm as the demo script flyexdemo.m.
% All graphical output steps have been removed, and the script has been
% converted into a function which takes as input the filename of a
% Drosophila image, and outputs the rotated and cropped image, along with
% curves fit to the red, green and blue channels. It is used as a utility
% function by localflyexdemo.m and dctflyexdemo.m.
%
% This function uses the Image Processing ans Curve Fitting Toolboxes.
%
% Sam Roberts

%   Copyright 2006 The MathWorks, Inc.

im = imread(im);

RGBmax = max(im,[],3);

mask = im2bw(RGBmax,20/255);

mask = medfilt2(mask,[3,3]);

mask = imclose(mask,strel('disk',5,0));

L = bwlabel(mask);

stats = regionprops(L,...
    {'Orientation','MajorAxisLength','MinorAxisLength'});

stdim = imrotate(im,-stats.Orientation);
warning off MATLAB:colon:nonIntegerIndex
stdim = stdim(size(stdim,1)/2-stats.MinorAxisLength/2:size(stdim,1)/2+stats.MinorAxisLength/2,...
    size(stdim,2)/2-stats.MajorAxisLength/2:size(stdim,2)/2+stats.MajorAxisLength/2,:);
warning on MATLAB:colon:nonIntegerIndex

RGBmax = max(stdim,[],3);

RGBequal = adapthisteq(RGBmax,'NumTiles',...
    [ceil(size(RGBmax,1)/13),ceil(size(RGBmax,2)/13)]);

RGBequal = medfilt2(RGBequal);

bw=im2bw(RGBequal,105/255);
[L,num] = bwlabel(bw,4);

stats = regionprops(L,'Centroid','PixelIdxList');

r = squeeze(stdim(:,:,1));
g = squeeze(stdim(:,:,2));
b = squeeze(stdim(:,:,3));
[rows,columns,tmp]=size(stdim);
for i=1:num
    data(i,1:2) = stats(i).Centroid./[columns,rows]*100;
    data(i,3)=mean(r(stats(i).PixelIdxList));
    data(i,4)=mean(g(stats(i).PixelIdxList));
    data(i,5)=mean(b(stats(i).PixelIdxList));
end

middlestrip = (data(:,2)>40 & data(:,2)<60);
middledata = data(middlestrip,:);

opts = fitoptions('smoothingspline','SmoothingParam',0.01);
fitresultr = fit(middledata(:,1),middledata(:,3),'smoothingspline',opts);
fitresultg = fit(middledata(:,1),middledata(:,4),'smoothingspline',opts);
fitresultb = fit(middledata(:,1),middledata(:,5),'smoothingspline',opts);

rsmooth = feval(fitresultr,0:100);
gsmooth = feval(fitresultg,0:100);
bsmooth = feval(fitresultb,0:100);