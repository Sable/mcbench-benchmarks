function imf = bwtfilter(im,f)
% function imf = bwtfilter(im,f)
%
% BWT decimated filtering
% Version 1.2
%
% This is faster than doing the complete filtering operation with conv2 and
% then decimating the result
% 
% Arguments:
%  im: A square image, with side length a multiple of 3
%  f:  A 3x3 filter
%
% Result:
%  imf: im is filtered with f, and the result is decimated, taking every 
%       3rd value in x and y. This code is equivalent to:
%       imf = conv2(im, rot90(rot90(f)),'same');
%       imf = imf(2:3:end,2:3:end);
%
% Citation:
%  Willmore B, Prenger RJ, Wu MC and Gallant JL (2008). The Berkeley 
%  Wavelet Transform: A biologically-inspired orthogonal wavelet transform.
%  Neural Computation 20:6, 1537-1564 
%
% The article is available at:
%  <http://dx.doi.org/10.1162/neco.2007.05-07-513>
%
% Copyright (c) 2008 Ben Willmore
%
% Permission is hereby granted, free of charge, to any person
% obtaining a copy of this software and associated documentation
% files (the "Software"), to deal in the Software without
% restriction, including without limitation the rights to use,
% copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the
% Software is furnished to do so, subject to the following
% conditions:
% 
% The above copyright notice and this permission notice shall be
% included in all copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
% EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
% OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
% NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
% HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
% WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
% FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
% OTHER DEALINGS IN THE SOFTWARE.

sz = size(im);

if (length(sz) ~= 2) || (sz(1) ~= sz(2))
  disp('Input must be square');
  decomp = nan;
  return;
end

sz = sz(1);
ssz = sz/3;

if ( (ssz-floor(ssz)) > abs(ssz)*eps )
  fprintf('Side length must be a multiple of 3');
  decomp = nan;
  return;
end

f_rep = repmat(f,ssz,ssz);

imdot = im .* f_rep;

imf = zeros(ssz);

for yy = 1:3
  for xx = 1:3
    imf = imf + imdot(yy:3:end,xx:3:end);
  end
end
