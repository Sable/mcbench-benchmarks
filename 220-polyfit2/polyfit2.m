function [p,S] = polyfit2(x,y,n,x0,y0)
%POLYFIT2 Fit polynomial to data, with a new feature.
%
% The new usage:
%   POLYFIT2(X,Y,N,X0,Y0) finds the coefficients of a polynomial P(X) of
%   degree N that fits the data, P(X(I))~=Y(I), in a least-squares sense,
%   but also passes through Y0 for X=X0.
%
% The original usage (still available via a direct pass-through to POLYFIT):
%   POLYFIT2(X,Y,N) finds the coefficients of a polynomial P(X) of
%   degree N that fits the data, P(X(I))~=Y(I), in a least-squares sense.
%
%   [P,S] = POLYFIT2(X,Y,N) returns the polynomial coefficients P and a
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
%

%   x0,y0 feature added by David Moline, 3-15-99.

% (The first part of the following discussion is "as is" from POLYFIT)
% The regression problem is formulated in matrix format as:
%
%    y = V*p    or
%
%          3  2
%    y = [x  x  x  1] [p3
%                      p2
%                      p1
%                      p0]
%
% where the vector p contains the coefficients to be found.  For a
% 7th order polynomial, matrix V would be:
%
% V = [x.^7 x.^6 x.^5 x.^4 x.^3 x.^2 x ones(size(x))];
%
% The regression problem for a fit also passing through a single 
% required point (x0,y0) is formulated in matrix format as:
%
%    y = V*pt+y0    or
%
%                    3       2
%    (y-y0) = [(x-x0)  (x-x0)  (x-x0)] [pt3
%                                       pt2
%                                       pt1]
%
% Then the actual coefficient vector, p, is found as
%      pt=V\(y-y0);
%      pt=[pt.' y0]; % get it as a row vector :)
%      for i=n+1:-1:1
%         p(i+1)=polyval(pt,-x0);
%         pt=polyder(pt)/(n+2-i);
%      end
%
% This can be shown by working the above y=V*pt+y0 algebraically, then 
% collecting powers of x and noting the form of the coefficients 
% (starting with the constant, p0).
%
% Basically, the algorithm is still solving a least squares problem,
% but we've specified the constant, pt0=y0 (and thus removed it from
% the regression), then performed a regression on y'=y-y0 and x'=x-x0.
% The final step is to convert the coefficients in the primed 
% system regression to that for the original x and y system.
%

if ~(length(x)==length(y))
    error('X and Y vectors must be the same size.')
end

if nargin==3, % normal usage of polyfit
   [p,S] = polyfit(x,y,n);
elseif nargin==5, % a polyfit with x0,y0
   if n==0, error('   Order of fit must be 1 or higher'), end
   x1 = x(:)-x0;       % a simple transformation of variables
   y1 = y(:)-y0;
   % Compare the following section with that in POLYFIT, with noted changes
   V(:,n) = x1;        % This was V(:,n+1)= ones(length(x1),1). (DM, March 1999)
   for j = n-1:-1:1,   % This was n:-1:1. (DM, March 1999)
      V(:,j) = x1.*V(:,j+1);
   end
   % Solve least squares problem. We'll drop the Cholesky stuff, as I can't
   % guarantee it still applies. (DM, March 1999)
   pt = V\y1;
   % Now the new tricks...get back to original x,y system.
   pt = [pt.' y0];
   for i=n+1:-1:1
      p(i)=polyval(pt,-x0);
      pt=polyder(pt)/(n+2-i); % we need this for the next steps
   end
else
   error('  There should be 3 or 5 inputs for this function')
end
