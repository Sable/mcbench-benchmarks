function out = ij2xy(in, maxy)
% out = xy2ij(in, maxy)
%
% Converts shapes from "image" coordinates to cartesian coordinates.
% In cartesian coordinates, the origin is on the lower-left corner of
% the image and y moves vertically while x moves horizontally.
% Image coordinates follow a matrix notation where the origin is in
% the upper left corner and the first coordinate 'i' moves vertically
% (in the opposite direction of y), while the second 'j' coordinate
% moves horizontally in the same direction as x.
% 
%                         PARAMETERS
%
% in A Nx2xS matrix containing S shapes and N landmarks,
%    in images coordinates: [i j]
% maxy Number of rows of the image matrix, or height of the displayed image,
%      in pixels.
%
%                          RETURNS
% 
% out A Nx2xS matrix containing S shapes and N landmarks,
%     in cartesian coordinates: [x y]
%
% Author: Luca Vezzaro (elvezzaro@gmail.com)

	out(:,1,:) = in(:,2,:);
	out(:,2,:) = repmat(maxy, [size(in, 1) 1 size(in,3)]) - in(:,1,:);