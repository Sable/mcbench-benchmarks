function p = polyfitweighted2(x,y,z,n,w)
% polyfitweighted2.m 
% -------------------
%
% Find a least-squares fit of 2D data z(x,y) with an nth order 
% polynomial, weighted by w(x,y) .
%
% By S.S. Rogers (2006)
%
% Usage
% ------
%
% P = polyfitweighted2(X,Y,Z,N,W) finds the coefficients of a polynomial 
% P(X,Y) of degree N that fits the data Z best in a least-squares 
% sense. P is a row vector of length (N+1)*(N+2)/2 containing the 
% polynomial coefficients in ascending powers, 0th order first.
%
%   P = [p00 p10 p01 p20 p11 p02 p30 p21 p12 p03...]
%
% e.g. For a 3rd order fit, 
% the regression problem is formulated in matrix format as:
%
%   wZ = V*P    or
%
%                      2       2   3   2     2      3
%   wZ = [w  wx  wy  wx  xy  wy  wx  wx y  wx y   wy ]  [p00
%                                                        p10
%                                                        p01
%                                                        p20
%                                                        p11
%                                                        p02
%                                                        p30
%                                                        p21
%                                                        p12
%                                                        p03]
%
% *Note:* P is not in the format of standard Matlab 1D polynomials. Use
% polval2.m to evaluate the polynomial in this format, at given values of
% x,y.
%
% X,Y must be vectors
% Z,W must be 2D arrays of size [length(X) length(Y)]
%
% based on polyfit.m by The Mathworks Inc. - see doc polyfit for more details
%
% Class support for inputs X,Y,Z,W:
%      float: double, single

x = x(:);
y = y(:);

lx=length(x);
ly=length(y);

if ~isequal(size(z),size(w),[ly lx])
    error('polyfitweighted2:XYSizeMismatch',...
         [' X,Y *must* be vectors' ...
          '  Z,W *must* be 2D arrays of size [length(X) length(Y)]'])
end

y=y*ones(1,lx);
x=ones(ly,1)*x';
x = x(:);
y = y(:);
z = z(:);
w = w(:);

pts=length(z);

% Construct weighted Vandermonde matrix.
V=zeros(pts,(n+1)*(n+2)/2);
V(:,1) = w;
%V(:,1) = ones(pts,1);
ordercolumn=1;
for order = 1:n
    for ordercolumn=ordercolumn+(1:order)
        V(:,ordercolumn) = x.*V(:,ordercolumn-order);
    end
    ordercolumn=ordercolumn+1;
    V(:,ordercolumn) = y.*V(:,ordercolumn-order-1);
end

% Solve least squares problem.
[Q,R] = qr(V,0);
ws = warning('off','all'); 
p = R\(Q'*(w.*z));    % Same as p = V\(w.*z);
warning(ws);
if size(R,2) > size(R,1)
   warning('polyfitweighted2:PolyNotUnique', ...
       'Polynomial is not unique; degree >= number of data points.')
elseif condest(R) > 1.0e10
        warning('polyfitweighted2:RepeatedPointsOrRescale', ...
            ['Polynomial is badly conditioned. Remove repeated data points\n' ...
            '         or try centering and scaling as described in HELP POLYFIT.'])
end
%r = z - (V*p)./w;
p = p.';          % Polynomial coefficients are row vectors by convention.
