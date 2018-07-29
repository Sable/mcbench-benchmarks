function I = argmin(X, DIM)
%ARGMIN    Argument of the minimum
%   For vectors, ARGMIN(X) is the indix of the smallest element in X. For matrices,
%   MAX(X) is a row vector containing the indices of the smallest elements from each
%   column. This function is not supported for N-D arrays with N > 2.
%
%   I = ARGMIN(X,DIM) operates along the dimension DIM (DIM can be
%   either 1 or 2).
%
%   It is an efficient replacement to the use of [Y,I] = MIN(X,[],DIM);
%   See ARGMAX_DEMO for a speed comparison using ARGMAX instead of MAX
%   (but similar considerations apply for the minimum).
%
%
%   When complex, the magnitude ABS(X) is used, and the angle
%   ANGLE(X) is ignored. This function cannot handle NaN's.
%
%   Example:
%       clc
%       disp('If X = [2 8 4; 7 3 9]');
%       disp('then argmin(X,1) should be [1 2 1]')
%       disp('while argmin(X,2) should be [1 2]''. Now we check it:')
%       disp(' ');
%       X = [2 8 4; 
%            7 3 9]
%       argmin(X,1)
%       argmin(X,2)
%
%   See also ARGMAX, ARGMAXMIN_MEX, ARGMAX_DEMO, MIN, MAX, MEDIAN, MEAN, SORT.

%   Copyright Marco Cococcioni, 2009.
%   $Revision: 1.0 $  $Date: 2009/02/16 19:24:01 $

if nargin < 2,
    DIM = 1;
end

if length(size(X)) > 2,
    error('Function not provided for N-D arrays when N > 2.');
end

if (DIM ~=1 && DIM ~= 2),
    error('DIM has to be either 1 or 2');
end

if any(isnan(X(:))),
    error('Cannot handle NaN''s.');    
end

if not(isreal(X)),
    X = abs(X);
end

max_NOT_MIN = 0; % computes argmin
I = argmaxmin_mex(X, DIM, max_NOT_MIN);