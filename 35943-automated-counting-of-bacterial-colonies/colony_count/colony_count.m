function [count,colonies,bw] = colony_count(I,radii)
% colony_count.m
% Counts the number of colonies on an agar Petri dish.
%
% Usage: [count,markers,mask] = colony_count(img);
% Arguments:
%       img    -    Color or grayscale plate image
%       radii  -    Vector of radii range for Petri dish (px)
% Outputs:
%       count    -    Number of colonies detected
%       markers  -    Binary image containing colony markers
%       mask     -    Binary image containing entire colony foreground
%
% colony_count.m attempts to count the number of colonies on a plate.
% The approach is to (1) use a circular Hough transform to find the plate,
% (2) segment the colonies using Otsu's method and (3) locate markers for
% individual colonies, including touching / overlapping colonies, by
% finding the regional maxima within the segmentation.
%
% This function may not work for your images at first. It may be necessary
% to alter Hough transform parameters, to erode the plate segmentation more
% aggressively or to convert to HSV space and use one of those channels,
% but this code should provide a good foundation for such an endeavor.
%
% David Young's Hough Transform for Circles toolbox is required by
% colony_count.m. It can be found here:
% http://www.mathworks.com/matlabcentral/fileexchange/26978-hough-transform-for-circles
%
% Example:
%
% I = imread('plate_example.jpg');
% [count,colonies,mask] = colony_count(I);
%
% Version 1, March 2012
%
% Copyright 2012 Daniel Asarnow
% San Francisco State University

if ndims(I) == 3
    I = rgb2gray(im2double(I)); % Color-to-gray conversion.
end

[m,n] = size(I);

% Uncomment this if you have might have some images with light background
% and dark colonies. It will invert any that seem that way.
%if graythresh(I) < 0.5
%    I = imcomplement(I);
%end

bw = I > graythresh(I); % Otsu's method.

if nargin == 1
    radii = 115:1:130; % Approx. size of plate, narrower range = faster.
end

h = circle_hough(bw,radii,'same','normalise'); % Circular HT.
peaks = circle_houghpeaks(h, radii, 'npeaks', 10); % Pick top 10 circles.

roi = true(m,n);
for peak = peaks
    [x, y] = circlepoints(peak(3)); % Points on the circle of this radius.
    x = x + peak(1); % Translate the circle appropriately.
    y = y + peak(2);
    roi = roi & poly2mask(x,y,m,n); % Cumulative union of all circles.
end

% Restrict segmentation to dish. The erosion is to make sure no dish pixels
% are included in the segmentation.
bw = bw & bwmorph(roi,'erode');

% Colonies are merged in the segmented image. Observing that colonies are 
% quite bright, we can find a single point per colony by as the regional
% maxima (the brightest points in the image) which occur in the segmentation.
colonies = imregionalmax(I) & bw;

% Component labeling.
bwcc = bwconncomp(colonies);
count = bwcc.NumObjects;

% Uncomment to show HT circles. For troubleshooting.
% imshow(I);
% hold on;
% for peak = peaks
%     [x, y] = circlepoints(peak(3));
%     plot(x+peak(1), y+peak(2), 'g-');
% end
% hold off;