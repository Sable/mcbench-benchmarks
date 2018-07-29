function invnormim = iminvnorm(normim, height, width, normtform, udata, vdata)
%
% Perform inverse normalization on a normalized image
%
% Input:
%   normim: normalized grayscale image
%   height, width: size of the original (unnormalized) image
%   normtform: tform of normalization
%   udata, vdata: coordinates of the normalized image
%
% Output:
%   invnormim: inversely normalized version of the normalized image
%
% Copyright (c), Yuan-Liang Tang
% Associate Professor
% Department of Information Management
% Chaoyang University of Technology
% Taichung, Taiwan
% Email: yltang@cyut.edu.tw
% http://www.cyut.edu.tw/~yltang
% 
% Permission is hereby granted, free of charge, to any person obtaining
% a copy of this software without restriction, subject to the following
% conditions:
% The above copyright notice and this permission notice should be included
% in all copies or substantial portions of the Software.
%
% The Software is provided "as is", without warranty of any kind.
%
% Created: Mar. 3, 2008
% Last updated: Jul. 30, 2009
%
if ~isa(normim, 'double')
  normim = double(normim);
end
% Inverse normalization
[invnormim xdata ydata] = imtransform(normim, fliptform(normtform), ...
  'UData', udata, 'VData', vdata, 'XData', [1 width], 'YData', [1 height], ...
  'XYScale', 1);
figure('Name', 'Inversely normalized'), imshow(invnormim,[]), impixelinfo;

