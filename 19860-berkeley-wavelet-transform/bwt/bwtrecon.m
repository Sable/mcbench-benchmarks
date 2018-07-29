function im = bwtrecon(coeff,f)
% function im = bwtrecon(coeff,f)
%
% Reconstruct image from coefficients
% Version 1.2
%
% Arguments:
%  coeff: A square matrix of coefficients
%  f:     A 3x3 filter
%
% Result:
%  imf: A matrix containing multiple copies of the filter, multiplied by
%       the coefficients
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

sz = size(coeff);

if (length(sz) ~= 2) || (sz(1) ~= sz(2))
  disp('Input must be square');
  im = nan;
  return;
end

sz = sz(1);

idx = ceil((1:3*sz)/3);
coeff = coeff(idx,idx); % upsample by 3x

f_rep = repmat(f,sz,sz);
im = coeff .* f_rep;
