function [projmat_art,D] = tomoproj_art_2(im,angles)
%TOMOPROJ_ART   [projmat_art,D] = tomoproj_art(im,angles)
%   unit of angles: Degree;
%   projection direction: When angle == 0, X-ray passes through up-down
%    direction;
%
%   Phymhan
%   02-Aug-2013 14:07:06

%Pad image
[im_pad,D] = impad(im);
%Calculate projection
num_proj = length(angles);
projmat_art = zeros(num_proj,2*D);
for k = 1:num_proj
    im_rot = imrotate(im_pad,-angles(k),'bilinear','crop');
    projmat_art(k,  1:  D) = sum(im_rot,1) ;
    projmat_art(k,D+1:2*D) = sum(im_rot,2)';
end
end
