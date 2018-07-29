function [dirmap,exy,jxy] = anaskel(wsk);

% Performs some analysis on the skeleton provided,
% which should be thinned to a single pixel width.
%
% dirmap returns a cell array with masks of the skeleton
% pixels that are north, northeast, east, and southeast
% or opposite.
%
% exy and jxy return the pixel coordinates of points that
% are endpoints and junctions of the skeleton, respectively.
%
% Example:
% skg = skeleton(bw);
% wsk = bwmorph((skg > 50),'skel',inf);
% [dmap,exy,jxy] = anaskel(wsk);
%
% See also SKELETON

disp('Compiling...  (You may need to execute ''mex -setup'' first.)');
mex 'G:\Projects\Matlab\anaskel.cpp'
