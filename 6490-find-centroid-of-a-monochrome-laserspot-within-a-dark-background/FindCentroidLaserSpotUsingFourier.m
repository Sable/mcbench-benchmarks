function [y, x] = FindCentroidLaserSpotUsingFourier(shot)
% function finds centroid of a white laserspot within a dark background
% using fourier algorithm in a two dimensional grayscale image like the one
% in the file 'shot.mat', that you can import and then try the function
% with script test.m. the script loads an image, calculates centroid, shows
% image and position of the centroid with a green haircross.
%
% Function was tested with Matlab 6.5 R13 on Windows XP Prof. 
% Author: Rainer F., knallkopf66@uboot.com, Dec. 2004


vec = double(shot);
[rbnd, cbnd] = size(shot);

i = [1:rbnd];
SIN_A = sin((i - 1) * 2 * pi / (rbnd - 1));
COS_A = cos((i - 1) * 2 * pi / (rbnd - 1));

j = [1:cbnd]';
SIN_B = sin((j - 1) * 2 * pi / (cbnd - 1));
COS_B = cos((j - 1) * 2 * pi / (cbnd - 1));
    
a = sum(COS_A * vec);
b = sum(SIN_A * vec);
c = sum(vec * COS_B);
d = sum(vec * SIN_B);

if (a > 0)
    if (b > 0)
        rphi = 0;
    else
        rphi = 2 * pi;
    end
else
    rphi = pi;
end    


if (c > 0)
    if (d > 0)
        cphi = 0;
    else
        cphi = 2 * pi;
    end
else
    cphi = pi;
end

y = (atan(b / a) + rphi) * (rbnd - 1) / 2 / pi + 1;
x = (atan(d / c) + cphi) * (cbnd - 1) / 2 / pi + 1;



