function bw2 = hough_bin_pixels(bw, theta, rho, bin)
%HOUGH_BIN_PIXELS Find pixels corresponding to Hough accumulator bin.
%   BW2 = hough_bin_pixels(BW, THETA, RHO, BIN) finds the white pixels in a
%   binary image that correspond to a particular Hough transform
%   accumulator bin.  BW is the original binary image.  THETA and RHO are
%   the Hough parameter vectors returned by the hough function.  BIN is a
%   two-element vector containing the row-column coordinates of the Hough
%   transform bin.  BW2 is a binary image containing only the white pixels
%   in BW that contributed to the specified bin.
%
%   Example
%   =======
%   I  = imread('circuit.tif');
%   BW = edge(I,'canny');
%   imshow(BW)
%   [H,theta,rho] = hough(BW);
%   P = houghpeaks(H, 1);
%   BW2 = hough_bin_pixels(BW, theta, rho, P);
%   figure, imshow(BW2)
%   title('Pixels corresponding to maximum Hough transform bin')
%
%   See also hough, houghlines, houghpeaks.

%   Steven L. Eddins
%   The MathWorks, Inc.

[y, x] = find(bw);
x = x - 1;
y = y - 1;

theta_c = theta(bin(2)) * pi / 180;
rho_xy = x*cos(theta_c) + y*sin(theta_c);
nrho = length(rho);
slope = (nrho - 1)/(rho(end) - rho(1));
rho_bin_index = round(slope*(rho_xy - rho(1)) + 1);

idx = find(rho_bin_index == bin(1));

r = y(idx) + 1; 
c = x(idx) + 1;

bw2 = false(size(bw));

bw2(sub2ind(size(bw), r, c)) = true;
