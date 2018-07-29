function h = imagesc3(varargin)
% Display a 2-D image in Matlab xyz 3-D space and scale the colors.
% % h = image3(C, IJ2XYZ, handle)
%
% Uses the whole colormap, similar to imagesc. The syntax is otherwise the 
% same as for image3.
%
% This function is provided for convenience, manipulation of the handle h
% from the ordinary image3 function will provide the exact same
% functionality ... and more! 
%
% SEE ALSO: image3
%
% Author: Anders Brun, anders@cb.uu.se (2008)

h = image3(varargin{:});
set(h,'CDataMapping','scaled');
