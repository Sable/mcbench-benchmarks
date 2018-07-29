function z = polyval2(p,x,y)
% POLYVAL2 
% ---------
%
% Evaluate a 2D polynomial
% By SS Rogers (2006)
%
% Usage
% ------
% Z = POLYVAL2(P,X,Y) returns the value of a 2D polynomial P evaluated at (X,Y). P
% is a vector of length (N+1)*(N+2)/2 containing the polynomial coefficients in
% ascending powers:
%
%   P = [p00 p10 p01 p20 p11 p02 p30 p21 p12 p03...]
%
% e.g. For a 3rd order fit, polyval2.m evaluates the matrix equation:
%
%    Z = V*P    or
%
%                   2      2  3  2      2   3
%    Z = [1  x  y  x  xy  y  x  x y  x y   y ]  [p00
%                                                p10
%                                                p01
%                                                p20
%                                                p11
%                                                p02
%                                                p30
%                                                p21
%                                                p12
%                                                p03]
%
% *Note:* P is not in the format of standard Matlab 1D polynomials.
%
% X and Y should be vectors; the polynomial is evaluated at all
% points (X,Y).
%
% Class support for inputs P,X,Y:
%    float: double, single

x=x(:);
y=y(:);
lx=length(x);
ly=length(y);
lp=length(p);
pts=lx*ly;

y=y*ones(1,lx);
x=ones(ly,1)*x';
x = x(:);
y = y(:);

n=(sqrt(1+8*length(p))-3)/2;
% Check input is a vector
if ~(isvector(p) || mod(n,1)==0 || lx==ly)
    error('MATLAB:polyval2:InvalidP',...
            'P must be a vector of length (N+1)*(N+2)/2, where N is order. X and Y must be same size.');
end

% Construct weighted Vandermonde matrix.
V=zeros(pts,lp);
V(:,1) = ones(pts,1);
ordercolumn=1;
for order = 1:n
    for ordercolumn=ordercolumn+(1:order)
        V(:,ordercolumn) = x.*V(:,ordercolumn-order);
    end
    ordercolumn=ordercolumn+1;
    V(:,ordercolumn) = y.*V(:,ordercolumn-order-1);
end

z=V*p';
z=reshape(z,ly,lx);