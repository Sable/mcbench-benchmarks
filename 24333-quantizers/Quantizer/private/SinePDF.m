function FPDF = SinePDF
% Return function handles to routines to calculate the area, mean, and
% second moment of a unit-variance, zero-mean, probability density
% function for a sinusoid with random phase.
%                 b
%   Farea(a,b) = Int p(x) dx
%                 a
%                 b
%   Fmean(a,b) = Int x p(x) dx
%                 a
%                b
%   Fvar(a,b) = Int x^2 p(x) dx
%                a
%                      1
% where p(x) =  ----------------,    for -sqrt(2) <= x <= sqrt(2).
%               pi sqrt(2 - x^2) 
% and zero elsewhere.

% Map uniform phase w to sinusoid. The CDF for uniform phase is
%   Fw(w) = (w+pi)/(2 pi),   -pi <= w pi.
%   x = A sin(w).
% For a given 0<x<A, there two values of w which give the value x. The
% probability of being less than x is then
%   Fx(x) = 1 - (Fw(w2) - Fw(w1)),  0<x<A.
% where w2=asin(x/A), and w1=pi-asin(x/A). Substituting the value of Fw(w),
% gives
%   Fx(x) = 1 - (pi-asin(x/A)+pi)/(2 pi) + (asin(x/A)+pi)/(2 pi)
%         = 1/2 + asin(x/A)/pi
% The probability density function is found by differentiating the CDF
%   p(x) = 1 / (pi sqrt(A^2-x^2)
%
% The moments are found by integrating p(x),
%   Fx(x) = Int p(x) dx      = 1/pi asin(x/A)
%   F1(x) = Int x p(x) dx    = -1/pi sqrt(A^2-x^2)
%   F2(x) = Int x^2 p(x) dx  = A^2/(2pi) asin(x/A) - x/(2pi) sqrt(A^2-x^2)
% These relationships can be verified by differentiating the righthand
% side expressions.

FPDF = {@Sarea, @Smean, @Svar};

% ----- ------
function v = Sarea (a, b)

% Limits
Rt2 = sqrt(2);
an = min(max(a/Rt2, -1), 1);
bn = min(max(b/Rt2, -1), 1);

v = (asin(bn) - asin(an)) / pi;

return

% ----- ------
function v = Smean (a, b)

% Limits
a2 = max(2-a^2, 0);     % Cannot just clip a to be less than sqrt(2)
b2 = max(2-b^2, 0);     % Due to rounding, when a=sqrt(2), 2-a^2 < 0

v = (sqrt(a2) - sqrt(b2)) / pi;

return

% ----- ------
function v = Svar (a, b)

% Limits
Rt2 = sqrt(2);
a2 = max(2-a^2, 0);
b2 = max(2-b^2, 0);
a = min(max(a, -Rt2), Rt2);
b = min(max(b, -Rt2), Rt2);

v = ((asin(b/Rt2)-asin(a/Rt2)) - 0.5*(b*sqrt(b2)-a*sqrt(a2)))/pi;

return
