function FPDF = UniformPDF
% Return function handles to routines to calculate the area, mean, and
% second moment of a unit-variance, zero-mean, uniform probability
% density function.
%                 b
%   Farea(a,b) = Int p(x) dx
%                 a
%                 b
%   Fmean(a,b) = Int x p(x) dx
%                 a
%                b
%   Fvar(a,b) = Int x^2 p(x) dx
%                a
% where p(x) = 1/sqrt(12), for -sqrt(3) <= x <= sqrt(3)
% and zero elsewhere.

FPDF = {@Uarea, @Umean, @Uvar};

% ----- ------
function v = Uarea (a, b)

Rt3 = sqrt(3);

% Limits
an = min(max(a/Rt3, -1), 1);
bn = min(max(b/Rt3, -1), 1);

v = 0.5 * (bn - an);           % (b-a)/(2 sqrt(3))

return

% ----- ------
function v = Umean (a, b)

% Limits
a2n = min(max(a^2/3, -1), 1);
b2n = min(max(b^2/3, -1), 1);

v = (sqrt(3)/4) * (b2n - a2n); % (b^2-a^2)/(4 sqrt(3))

return

% ----- ------
function v = Uvar (a, b)

Rt3 = sqrt(3);

% Limits
a3n = min(max(a^3/(3*Rt3), -1), 1);
b3n = min(max(b^3/(3*Rt3), -1), 1);

v = 0.5 * (b3n - a3n);          % (b^3-a^3)/(6*sqrt(3))

return
