function h=displaycolorpatches(RGB)
% displaycolorpatches: displays a set of color patches in a rectangular array
% usage: displaycolorpatches(RGB)
%
% arguments: (input)
%  RGB - RGB intensity array, scaled in the interval [0,1]
%        The array will be displayed in as near a square array
%        of patches as possible. If the number of patches is
%        not a perfect square, then it will be augmented with
%        gray patches.
% 
%
% Example:
%  Display a random set of patches
%
%  displaycolorpatches(rand(100,3))
%
%
% Author: John D'Errico
% e-mail: woodchips@rochester.rr.com
% Release: 1.0
% Release date: 9/18/06

nrgb = size(RGB);
if (length(nrgb)==3)
  if nrgb(3)~=3
    error 'RGB must be nx3 or nxmx3, i.e.,, an image array.'
  end
  % dsplay it in the provided shape
  nr = nrgb(1);
  nc = nrgb(2);
  
elseif (length(nrgb)==2)
  if nrgb(2)~=3
    error 'RGB must be nx3 or nxmx3, i.e.,, an image array.'
  end
  
  % grid of patches to display
  np = nrgb(1);
  nr = floor(sqrt(np));
  nc = ceil(np/nr);
  
  RGB = [RGB;repmat([.5 .5 .5],nr*nc-np,1)];
  RGB = reshape(RGB,[nr,nc,3]);
  
end

% RGB is now an nrxncx3 array. Generate the set of patches.
[i,j] = meshgrid(0:(nr-1),0:(nc-1));
i=i(:)';
j=j(:)';

h = patch([i;i+1;i+1;i],[j;j;j+1;j+1],reshape(RGB,[1,nr*nc,3]));
title 'Color patches'

% if there are too many patches, then the edgecolor
% should be set to none, otherwise the whole figure
% will just be black
if (nr*nc)>100
  set(h,'edgecolor','none')
end

% do I return the patch handle?
if nargout==0
  clear h
end
