function [normim, normtform, xdata, ydata] = imnorm(im)
%
% Implementation of the image normalization part of:
%   1. P. Dong, J.G. Brankov, N.P. Galatsanos, Y. Yang, and F. Davoine,
%      "Digital Watermarking Robust to Geometric Distortions," IEEE Trans.
%      Image Processing, Vol. 14, No. 12, pp. 2140-2150, 2005.
%
% Input:
%   im: input grayscale image
%
% Output:
%   normim: normalized image of class double
%   normtform: tform of the normalization
%   xdata, ydata: spatial coordinates of the normalized image
%
% Copyright (c), Yuan-Liang Tang
% Associate Professor
% Department of Information Management
% Chaoyang University of Technology
% Taiwan, R.O.C.
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
% Created: May 2, 2007
% Last updated: Jul. 30, 2009
%

if ~isa(im, 'double')
  im = double(im);
end

% Normalization steps: 
% 1. Translation invariance: translate coordinate to the image centroid
[cx cy] = imcentroid(im);
tmat = [1 0 0; 0 1 0; -cx -cy 1];    % Translation matrix
mat = tmat;
tform = maketform('affine', mat);
[imt xdata ydata] = imtransform(im, tform, 'XYScale', 1);
%showim(imt, 'Translation', xdata, ydata);

% 2. X-direction shearing invariance
[cx cy] = imcentroid(imt);
u03 = immoment(imt, 0, 3, cx, cy);
u12 = immoment(imt, 1, 2, cx, cy);
u21 = immoment(imt, 2, 1, cx, cy);
u30 = immoment(imt, 3, 0, cx, cy);
rts = sort(roots([u03, 3*u12, 3*u21, u30]));
if isreal(rts)   % All roots are real: choose the median one
  beta = rts(2);
else  % Choose the real one
  for i = 1:3
    if isreal(rts(i))
      beta = rts(i);
      break
    end
  end
end
xmat = [1 0 0; beta 1 0; 0 0 1];    % X-shearing matrix
mat = mat*xmat;
tform = maketform('affine', mat);
[imtx xdata ydata] = imtransform(im, tform, 'XYScale', 1);
%showim(imtx, 'Xshearing', xdata, ydata);

% 3. Y-direction shearing invariance
[cx cy] = imcentroid(imtx);
u11 = immoment(imtx, 1, 1, cx, cy);
u20 = immoment(imtx, 2, 0, cx, cy);
gamma = -u11/(u20+eps);
ymat = [1 gamma 0; 0 1 0; 0 0 1];    % Y-shearing matrix
mat = mat*ymat;
tform = maketform('affine', mat);
[imtxy xdata ydata] = imtransform(im, tform, 'XYScale', 1);
%showim(imtxy, 'Yshearing', xdata, ydata);

% 4. Anisotropic scaling invariance
% Scale the supported area of the image to the fixed size of [512 512]
[r c] = find(imtxy);
alpha = 512/(max(c)-min(c)+1);
delta = 512/(max(r)-min(r)+1);
smat = [alpha 0 0; 0 delta 0; 0 0 1];    % Scaling matrix
% Ensure u50>0 and u05>0
tmpmat = mat*smat;
tform = maketform('affine', tmpmat);
[imtxys xdata ydata] = imtransform(im, tform, 'XYScale', 1);
[cx cy] = imcentroid(imtxys);
if immoment(imtxys, 5, 0, cx, cy) < 0
  alpha = -alpha;
end
if immoment(imtxys, 0, 5, cx, cy) < 0
  delta = -delta;
end
smat = [alpha 0 0; 0 delta 0; 0 0 1];    % Scaling matrix
mat = mat*smat;
tform = maketform('affine', mat);
[imtxys xdata ydata] = imtransform(im, tform, 'XYScale', 1);
%showim(imtxys, 'Scaling', xdata, ydata);

% Perform overall transformation
normtform = maketform('affine', mat);
[normim xdata ydata] = imtransform(im, normtform, 'XYScale', 1);
% Remove black borders
[row col] = find(round(normim));
minr = min(row);
maxr = max(row);
minc = min(col);
maxc = max(col);
normim = normim(minr:maxr, minc:maxc);
xdata(1) = xdata(1)+minc-1;
xdata(2) = maxc-minc+xdata(1);
ydata(1) = ydata(1)+minr-1;
ydata(2) = maxr-minr+ydata(1);
showim(normim, 'Normalized', xdata, ydata);


function [cx, cy] = imcentroid(im)
% Compute image centroid
m00 = immoment(im, 0, 0);
cx = immoment(im, 1, 0)/(m00+eps);
cy = immoment(im, 0, 1)/(m00+eps);


function m = immoment(im, p, q, cx, cy)
% Compute image moment
[y x v] = find(im);
if nargin == 5
  x = x - cx;
  y = y - cy;
end
if p==0 && q==0
  m = sum(v);
elseif p==0 && q==1
  m = sum(y .* v);
elseif p==1 && q==0
  m = sum(x .* v);
elseif p==1 && q==1
  m = sum(x .* y .* v);
else
  m = sum(x.^p .* y.^q .* v);
end


function showim(im, name, xdata, ydata)
figure('Name', name), imshow(uint8(im), 'XData', xdata, 'YData', ydata);
impixelinfo, axis on, axis([xdata ydata]);


