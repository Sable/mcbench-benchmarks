function img_out=imageresize(img_in, rowScale, colScale);
%IMAGERESIZE Resize image 
%   IMAGERESIZE resize an image to any scale. 
%   This is a simple implementation of IMRESIZE.
%   Example:
%            imin   = imread('cameraman.tif');
%            imoutL = imageresize(imin, 2, 2); % enlarge image
%            imoutS = imageresize(imin, 0.2, 0.2) % shrink image
%
%Created by Archezus at Yahoo dot Com - 20110317
%Department of Computer Engineering
%University of Indonesia

[row col]=size(img_in);

for i=1:floor(row*rowScale)
    for j=1:floor(col*colScale)
        img_out(i,j)=img_in(ceil(1/rowScale * i), ceil(1/colScale * j));
    end
end

imshow(img_in); 
title('original image');
figure;imshow(img_out); 
title('resized image');
truesize(size(img_in)); % omit this to display as it is

    