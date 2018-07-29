function [img1,img2,r,c,z] = getstacks;
% GETSTACKS User interface for interactively loading 3D image stacks into
% the MATALAB workspace
%
% [img1,img2,r,c,z] = getstacks;
%
% Calling GETSTACKS with all the output arguments will generate 5 variables
% in the MATLAB workspace: the two images (img1 and img2), and their dimensions 
% (r,c,z).  
% 
% By default, the function only opens TIFF images, but any image type 
% supported by MATLAB will work.  You can simply delete the '*.tif' option
% call from lines 23 and 40, and MATLAB should be able to determine all
% supported image types.
%
% NOTE that the function converts the images into DOUBLE format, even if
% the original data are only 8-bit.
%
% See Also UIGETFILE, IMREAD, IM2DOUBLE, IMFINFO

% Load First Image Stack

[stack1,direct1] = uigetfile('*.tif', 'Select First Stack');
cd (direct1)
info1 = imfinfo (stack1);
r = max([info1.Height]);
c = max([info1.Width]);
z = length([info1.FileSize]);

for i = 1:z;
    img1(:,:,i) = imread(stack1,i);
end


% Load Second Image Stack
[stack2,direct2] = uigetfile('*.tif', 'Select Second Stack');
cd (direct2)
info2 = imfinfo (stack2);

for i = 1:z;
    [img2(:,:,i)] = imread(stack2,i);
end