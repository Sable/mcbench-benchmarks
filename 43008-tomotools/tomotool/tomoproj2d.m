function [proj_mat,D] = tomoproj2d(im,angles)
%TOMOPROJ2D   [proj_mat,D] = tomoproj2d(im,angles)
%   unit of angles: Degree;
%   projection direction: When angle == 0, X-ray passes through vertical 
%   (up-down) direction.
%
%   Phymhan
%   02-Aug-2013 14:07:06

%Pad image
[im_pad,D] = impad(im);
%Calculate projection
num_proj = length(angles);
proj_mat = zeros(num_proj,D);
for k = 1:num_proj
    im_rot = imrotate(im_pad,-angles(k),'bilinear','crop');
    proj_mat(k,:) = sum(im_rot,1);
end
end
