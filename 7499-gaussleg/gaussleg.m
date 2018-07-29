function [anss,abs1,wgt1] = gaussleg(f,a,b,gp,varargin)
% GAUSSLEG(f,a,b,gp) Definite integration using Gauss-Legendre quadrature.
% Finds the definite integral of function f from a to b using gp Gauss 
% points.  The default number of Gauss points is 106.  Will also return the 
% weights and abscissas if called.  If f is an inline function, it need not
% accept vector args.  Function f can also be ananymous or a func. handle.
%
% Example:    >>f=inline('sin(x)/x');
%             >>gaussleg(f,-1,1,8)    
%             ans =
%                  1.89216614073437
% Compare to quad(f,-1,1), after changing f to accept vector args.  Also
% available on the file exchange is an adaptive form of this function 
% called 'gaussquad'.
% Author:  Matt Fig
% Date:  revised 1/31/2006
% Contact:  popkenai@yahoo.com
f = fcnchk(f,'vectorized');               % This allows user easy func use.

if nargin < 4, gp = 106; end              % Default number of Gauss points.
    
[abs1, wgt1] = Gauss(gp);  
Alphas = ((b-a)./2).*(abs1+1)+a;                     % Mapping f to [-1,1].
anss = sum(wgt1.*f(Alphas))*(b-a)/2;

if isnan(anss) | isinf(anss) 
   fprintf(['\n\t Incrementing the number of Gauss '...
            'points by 1 because of NaN.\n'])
   [anss,abs1,wgt1] = gaussleg(f,a,b,gp+1);
end


function [x, w] = Gauss(n)
% Generates the abscissa and weights for a Gauss-Legendre quadrature.
% Reference:  Numerical Recipes in Fortran 77, Cornell press.
x = zeros(n,1);                                           % Preallocations.
w = x;
m = (n+1)/2;
for ii=1:m
    z = cos(pi*(ii-.25)/(n+.5));                        % Initial estimate.
    z1 = z+1;
while abs(z-z1)>eps
    p1 = 1;
    p2 = 0;
    for jj = 1:n
        p3 = p2;
        p2 = p1;
        p1 = ((2*jj-1)*z*p2-(jj-1)*p3)/jj;       % The Legendre polynomial.
    end
    pp = n*(z*p1-p2)/(z^2-1);                        % The L.P. derivative.
    z1 = z;
    z = z1-p1/pp;
end
    x(ii) = -z;                                   % Build up the abscissas.
    x(n+1-ii) = z;
    w(ii) = 2/((1-z^2)*(pp^2));                     % Build up the weights.
    w(n+1-ii) = w(ii);
end