
% STEP 1: Use getHSVColorFromDirectory(dirName) in order to estimate the
% average HSV values of your objects of interest.

HSV = getHSVColorFromDirectory('train');

%
% The above function call will let the user choose manually (through simple
% mouse clicks) several "seeds" from each image.
% At the end the HSV matrix contains M rows (M is the total number of jpeg files
% in dirName): each row corresponds to the average HSV value of the
% selected seeds in the respective image.
% The average (or median) value of this matrix (column-wise) can be used,
% in the sequence for detecting the speficic color values.
%

% STEP 2: Use the estimated (average) hsv value for detecting the specified
% color in a specific image.

colorDetectHSV('test/face01.jpg', median(HSV), [0.05 0.05 0.2]);

