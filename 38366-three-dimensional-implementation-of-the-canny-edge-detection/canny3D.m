%-------------------------------------------------------------------------%
%   University of Illinois at Urbana Champaign
%   Department of Mechanical Science and Engineering
%   Laboratory of Photonics Research on Bio/Nano Environment
%   Written by : Tung Yuen Lau
%   Advisor: Prof. Kimani Toussaint
%   Start date: FEB 16 2012
%   Descriptiont: This is a simple function to detect edges in a 3D matrix
%   Format: image_pyramid(3D matrix of stacked images)
%-------------------------------------------------------------------------%
function final = canny3D(im, filsize, sigma, th_up, th_low)

im = double(im);

hfil = floor(filsize/2);
[w,h,d] = size(im);
[x y z] = meshgrid(-hfil:hfil,-hfil:hfil,-hfil:hfil);
fil_x = exp(-x.^2/(2*sigma^2))./(sigma*sqrt(2*pi)); clear x;
fil_y = exp(-y.^2/(2*sigma^2))./(sigma*sqrt(2*pi)); clear y;
fil_z = exp(-z.^2/(2*sigma^2))./(sigma*sqrt(2*pi)); clear z;
f = fil_x .* fil_y .* fil_z; clear fil_x; clear fil_y; clear fil_z;
f = f/sum(abs(f(:)));
imfil = imfilter(im,f,'replicate'); clear f;
[imfil_x , imfil_y, imfil_z] = gradient(imfil); clear imfil;

%%
%   Thinning (non-maximum suppression)
im_sub = nonmax_sup(imfil_x,imfil_y,imfil_z,th_up, th_low);
clear im_th; clear imfil_theta_z;

final = im_sub;