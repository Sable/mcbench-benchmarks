function pZero = polyfitZero(x,y,degree)
% POLYFITZERO Fit polynomial to data, forcing y-intercept to zero.
%   PZERO = POLYFITZERO(X,Y,N) is similar POLYFIT(X,Y,N) except that the
%   y-intercept is forced to zero, i.e. P(N) = 0. In the same way as
%   POLYFIT, the coefficients, P(1:N-1), fit the data Y best in the least-
%   squares sense. You can also use Y = POLYVAL(PZERO,X) to evaluate the
%   polynomial because the output is the same as POLYFIT.
%
%   See also POLYVAL, POLYFIT
%

%   Mark Mikofski
%   Version 1-0, 2011-06-29

if ~isnumeric(x) || ~isnumeric(y)
    error('X and Y must be numeric.')
end
dim = length(x);
if ~isnumeric(degree) || ~isscalar(degree) || degree<=0 || degree>10 || degree>dim || degree~=round(degree)
    error('DEGREE must be an integer between 1 and 10 and less than length(X)')
end
if ~isvector(x) || ~isvector(y) || dim~=length(y)
    error('X and Y must be vectors of the same length')
end
x = x(:);
y = y(:);
z = zeros(dim,degree);
for n = 1:degree
    z(:,n) = x.^(degree-n+1);
end
pZero = z\y;
pZero = [pZero;0]';
end