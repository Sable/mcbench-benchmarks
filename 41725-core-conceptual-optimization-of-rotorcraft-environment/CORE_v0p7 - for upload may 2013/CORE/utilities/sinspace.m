function y = sinspace(d1, d2, n, factor)
%SINSPACE cosine spaced vector.
%   SINSPACE(X1, X2) generates a row vector of 100 sine spaced points
%   between X1 and X2. 
%
%   SINSPACE(X1, X2, N) generates N points between X1 and X2. 
% 
%   A sine spaced vector clusters the elements toward X2:
%    X1 |      |      |      |     |    |   |  | || X2
%
%   Make n negative to cluster the elements toward X1:
%    X1 || |  |   |    |     |      |      |      | X2 
% 
%   For -2 < N < 2, SINSPACE returns X2.
% 
%   SINSPACE(X1, X2, N, W) clusters the elements to a lesser degree as
%   dictated by W. W = 0 returns a normal sine spaced vector. W = 1 is the
%   same as LINSPACE(X1, X2, N). Experiment with W < 0 and W > 1 for
%   different clustering patterns.
% 
%   Author:     Sky Sartorius
%
%   See also COSSPACE, LINSPACE, LOGSPACE.

if nargin == 2
    n = 100;
end
if nargin < 4
    factor = false;
end

if n<0
    n = floor(double(-n));
    y = d2 + (d1-d2)*sin(pi/2*(1-(0:(n-1))/(n-1)));
else
    n = floor(double(n));
    y = d1 + (d2-d1)*sin(pi/(2*(n-1))*(0:n-1));
end

if factor
    y = (1-factor)*y+factor*[d1+(0:n-2)*(d2-d1)/(n-1) d2];
end