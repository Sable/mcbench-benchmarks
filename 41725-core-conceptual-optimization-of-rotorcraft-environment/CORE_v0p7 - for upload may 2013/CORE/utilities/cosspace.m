function y = cosspace(d1, d2, n, factor)
%COSSPACE cosine spaced vector.
%   COSSPACE(X1, X2) generates a row vector of 100 cosine spaced points
%   between X1 and X2. 
%
%   COSSPACE(X1, X2, N) generates N points between X1 and X2.
% 
%   A cosine spaced vector clusters the elements toward the endpoints:
%    X1    || |  |   |    |     |     |    |   |  | ||   X2
% 
%   For negative n, COSSPACE returns an inverse cosine spaced vector with
%   elements sparse toward the endpoints:
%     X1 |     |    |   |  | | | | | |  |   |    |     | X2
% 
%   For -2 < N < 2, COSSPACE returns X2.
% 
%   COSSPACE(X1, X2, N, W) clusters the elements to a lesser degree as
%   dictated by W. W = 0 returns a normal cosine or arccosine spaced
%   vector. W = 1 is the same as LINSPACE(X1, X2, N). Experiment with W < 0
%   and W > 1 for different clustering patterns.
% 
%   Author:     Sky Sartorius
% 
%   http://www.mathworks.com/matlabcentral/fileexchange/28337-cosspace
%
%   See also SINSPACE, LINSPACE, LOGSPACE.

if nargin == 2
    n = 100;
end
if nargin < 4
    factor = false;
end

if n<0
    n = floor(double(-n));
    y = d1 + (d2-d1)/pi*acos(1-2*(0:(n-1))/(n-1));
else
    n = floor(double(n));
    y = d1 + (d2-d1)/2*(1-cos(pi/(n-1)*(0:n-1)));
end

if factor
    y = (1-factor)*y+factor*[d1+(0:n-2)*(d2-d1)/(n-1) d2];
end