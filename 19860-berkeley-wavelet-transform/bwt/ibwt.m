function im = ibwt(decomp)
% function im = ibwt(decomp)
%
% BWT reconstruction
% Version 1.2
%
% Arguments:
%  decomp: A square BWT decomposition, as produced by bwt.m
%
% Result:
%  im: An image
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

sz = size(decomp);

if (length(sz) ~= 2) || (sz(1) ~= sz(2))
  disp('Input must be square');
  im = nan;
  return;
end

sz = sz(1);

numlevels = log(sz)/log(3);

if ( (numlevels-floor(numlevels)) > abs(numlevels)*eps )
  disp('Input side length must be a power of 3');
  im = nan;
  return;
end

im = zeros(sz);

for level = 1:numlevels
  ssz = size(decomp,1);
  decomp_thislevel = decomp;
  
  if (ssz>3)
    decomp_thislevel(end-ssz/3+1:end,1:ssz/3) = 0;
  end

  im_thislevel = ibwt_onelevel(decomp_thislevel)/sz*ssz*((3^level)^2);
  idx = ceil((1:sz)*ssz/sz);
  im = im + im_thislevel(idx,idx); % upsample by sz/ssz times
  
  if (ssz>1)
    decomp = decomp(end-ssz/3+1:end,1:ssz/3);
  end
end
