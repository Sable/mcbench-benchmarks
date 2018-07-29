function decomp = bwt(im)
% function decomp = bwt(im)
%
% BWT decomposition
% Version 1.2
%
% Arguments:
%  im: A square image; side length must be a power of 3
%
% Result:
%  decomp: The decomposition is laid out as (per Figure 3 of Willmore 
%  et al 2008):
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

numlevels = log(sz)/log(3);

if ( (numlevels-floor(numlevels)) > abs(numlevels)*eps )
  disp('Input side length must be a power of 3');
  decomp = nan;
  return;
end
  
decomp = zeros(sz);

for level = 1:numlevels
  decomp_thislevel = bwt_onelevel(im);
  ssz = size(decomp_thislevel,1);
  decomp(end-ssz+1:end,1:ssz) = decomp_thislevel/((3^level)^2);
  if (ssz>1)
    ssz = ssz/3;
    im = decomp_thislevel(end-ssz+1:end,1:ssz);
  end
end
