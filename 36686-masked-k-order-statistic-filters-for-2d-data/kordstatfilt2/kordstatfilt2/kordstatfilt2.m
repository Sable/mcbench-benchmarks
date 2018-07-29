function r=kordstatfilt2(im,ker,idx)

% Masked k-order statistic filter for double data
% -------------------------------------------------
% by Fabio Bellavia (fbellavia@unipa.it),
% refer to: F. Bellavia, D. Tegolo, C. Valenti,
% "Improving Harris corner selection strategy",
% IET Computer Vision 5(2), 2011.
% Only for academic or other non-commercial purposes.
%
% with respect to standard matlab routines, any kernel
% mask can be used and it is faster for large kernel
% size (i.e. more than 30x30 kernel mask)
%
% to compile the mex file:
% mex ordstatfilt2.c
%
% input:
% im - input 2D matrix
% ker - kernel binary mask
% idx - k-order index, in range [1,sum(ker(:)))
% use idx=1 for min filter (graylevel erosion), 
%  idx=sum(ker(:))/2+0.5 for median filter,
%  idx=sum(ker(:)) for max filter (graylevel dilation),
%  any other value for k-selection filter, non integer values
%  interpolate between values, i.e. 5.6 give 0.4*I(5)+0.6*I(6)
%  where I(n) is the n-th values in the sorted order inside the
%  kernel mask
%
% output:
% r - result 2D matrix, of the same size of im, zero padding is
%  used for the border
%
% see test.m for an usage example
%
% TODO: multithreaded version
%
% The median filter implementation is based on:
% W. Hardle, W. Steiger,
% "Algorithm AS 296: Optimal Median Smoothing"
% Journal of the Royal Statistical Society,
% Series C (Applied Statistics), pp. 258-264, 
% before it was implemented through the Quickselect algorithm.
%
% Though faster algorithms exist, they require much more memory.
%

if any(~isfinite(im(:))) || any(~isfinite(ker(:)))
    error('Input should contain only finite numeric data!');
end;

r=ordstatfilt2(double(im),double(ker>0),double(idx));
