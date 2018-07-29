function D1 = debye1(x)
%DEBYE1 First order Debye function.
%   Y = DEBYE1(X) returns the first order Debye function, evaluated at X.
%   X is a scalar.  For positive X, this is defined as
%
%      (1/x) * integral from 0 to x of (t/(exp(t)-1)) dt

%   A proper FORTRAN implementation of this function is available in the
%   MISCFUN Package written by Alan MacLead, available as TOMS Algorithm 757
%   in ACM Transactions of Mathematical Software (1996), 22(3):288-301.

%   Written by Peter Perkins, The MathWorks, Inc.
%   Revision: 1.0  Date: 2003/09/05
%   This function is not supported by The MathWorks, Inc.
%
%   Requires MATLAB R13.

if abs(x) >= realmin
    D1 = quad(@debye1_integrand,0,abs(x))./abs(x) - (x < 0).*x./2;
else
    D1 = 1;
end


function y = debye1_integrand(t)
y = ones(size(t));
nz = (abs(t) >= realmin);
y(nz) = t(nz)./(exp(t(nz))-1);
