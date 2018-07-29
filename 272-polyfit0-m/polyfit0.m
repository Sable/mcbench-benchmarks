function [p,S] = polyfit0(x,y,n)
%POLYFIT Fit polynomial to data.
%   POLYFIT0(X,Y,N) finds the coefficients of a polynomial P(X) of
%   degree N that fits the data, P(X(I))~=Y(I), in a least-squares sense.
%	  HOWEVER THIS VERSION OF POLYFIT HAS A CURVE THAT PASSES THRU 0
%     POLYFITO HAS NO CONSTANT TERM
%
%   [P,S] = POLYFIT0(X,Y,N) returns the polynomial coefficients P and a
%   structure S for use with POLYVAL to obtain error estimates on
%   predictions.  If the errors in the data, Y, are independent normal
%   with constant variance, POLYVAL will produce error bounds which
%   contain at least 50% of the predictions.
%
%   The structure S contains the Cholesky factor of the Vandermonde
%   matrix (R), the degrees of freedom (df), and the norm of the
%   residuals (normr) as fields.   
%
%   See also POLY, POLYVAL, ROOTS.

%   J.N. Little 4-21-85, 8-23-86; CBM, 12-27-91 BAJ, 5-7-93.
%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 5.9 $  $Date: 1997/11/21 23:40:57 $
%   POLYFIT0 CREATED BY AJUTAN MARCH 6-2000

% The regression problem is formulated in matrix format as:
%
%    y = V*p    or
%
%          3  2
%    y = [x  x  x  ] [p3
%                      p2
%                      p1]
%                      
%
% where the vector p contains the coefficients to be found.  For a
% 7th order polynomial, matrix V would be:
%
% V = [x.^7 x.^6 x.^5 x.^4 x.^3 x.^2 x ];

if ~isequal(size(x),size(y))
    error('X and Y vectors must be the same size.')
end

x = x(:);
y = y(:);

% Construct Vandermonde matrix.
V(:,n+1) = ones(length(x),1);
for j = n:-1:1
    V(:,j) = x.*V(:,j+1);
end
% STRIP OFF LAST COL OF ONES TO REMOVE CONSTANT TERM
V(:,n+1)=[];

% Solve least squares problem, and save the Cholesky factor.
[Q,R] = qr(V,0);
p = R\(Q'*y);    % Same as p = V\y;
r = y - V*p;
p = p.';          % Polynomial coefficients are row vectors by convention.

% S is a structure containing three elements: the Cholesky factor of the
% Vandermonde matrix, the degrees of freedom and the norm of the residuals.

S.R = R;
S.df = length(y) - (n+1);
S.normr = norm(r);
