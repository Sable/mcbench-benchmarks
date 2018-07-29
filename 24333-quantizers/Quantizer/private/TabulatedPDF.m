function FPDF = TabulatedPDF (x, p)
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
% where p(x) is a tabulated function. The PDF is assumed to be zero outside
% of the limits, and defined by linear interpolation between points. The
% tabulated function need not be initially normalized to unit area.
%
% x - Abscissa values (in increasing order)
% p - Vector of probability values at the corresponding abscissa values.
%     The PDF is assumed to be zero outside of [x(1), x(end)] and to be
%     linearly interpolated between abscissa points.

% global xpdf pdf

% Test for increasing x
if (any(diff(x) < 0))
  error('TabulatedPDF - Non-increasing abscissa values');
end
if (any(p < 0))
  error('TabulatedPDF - Negative probability value');
end
if (length(x) ~= length(p) || length(x) <= 1)
  error('TabulatedPDF - Invalid table length');
end

% Normalize the tabulated data
xpdf = x;
pdf = p;
A = Tarea(-Inf, Inf);
pdf = pdf / A;

FPDF = {@Tarea, @Tmean, @Tvar};

return

%----- ----- begin nested functions
function v = Tarea (a, b)

% global xpdf pdf

v = TabulatedPDFInt(@TLarea, a, b, xpdf, pdf);

return
end

% ----- ------
function v = Tmean (a, b)

% global xpdf pdf

v = TabulatedPDFInt(@TLmean, a, b, xpdf, pdf);

return
end

% ----- ------
function v = Tvar (a, b)

% global xpdf pdf

v = TabulatedPDFInt(@TLvar, a, b, xpdf, pdf);

return
end

% ----- -----
function v = TabulatedPDFInt (Fn, a, b, x, p)
% The abscissa values are assumed to be in increasing order

% Limit the evaluation interval and flip the limits if a > b
br = min(x(end), max(a, b));
ar = max(x(1), min(a, b));

if (br <= ar)
  v = 0;
  return
end

% Search for the intervals included in the integral
iL = max(find(x <= ar));
iU = min(find(x >= br));
if (iL == iU)
  error('TabulatedPDFInt - iL == iU');
end
x = x(iL:iU);       % Keep only intervals of interest
p = p(iL:iU);

% Lop off the end intervals
p(1) = Alin(ar, x(1:2), p(1:2));
x(1) = ar;
p(end) = Alin(br, x(end-1:end), p(end-1:end));
x(end) = br;

% Integrate
v = feval(Fn, x, p);

% Negate the integral if a > b
if (a > b)
  v = -v;
end

return
end

% ----- -----
function v = TLarea (x, p)

xl = x(1:end-1);
xu = x(2:end);
pl = p(1:end-1);
pu = p(2:end);
% syms p pl pu xl xu x
% p = pl+(x-xl)*(pu-pl)/(xu-xl)
% factor(int(p,xl,xu)
% ans = -1/2*(pl+pu)*(-xu+xl)
A = (xu-xl) .* (pl+pu);

v = 0.5 * sum(A);

return
end

% ----- ------
function v = TLmean (x, p)

xl = x(1:end-1);
xu = x(2:end);
pl = p(1:end-1);
pu = p(2:end);
% syms p pl pu xl xu x
% p = pl+(x-xl)*(pu-pl)/(xu-xl)
% factor(int(x*p,xl,xu)
% ans = -1/6*(-xu+xl)*(2*pl*xl+pu*xl+pl*xu+2*pu*xu)
A = (xu-xl) .* ((xl+xu) .* (pl+pu) + pl.*xl + pu.*xu);

v = sum(A) / 6;

return
end

% ----- -----
function v = TLvar (x, p)

xl = x(1:end-1);
xu = x(2:end);
pl = p(1:end-1);
pu = p(2:end);
% syms p pl pu xl xu x
% p = pl+(x-xl)*(pu-pl)/(xu-xl)
% factor(int(x^2*p,xl,xu)
% ans = -1/12*(-xu+xl)
%          *(3*pl*xl^2+pu*xl^2+2*xl*pu*xu+2*pl*xu*xl+pl*xu^2+3*pu*xu^2)
A =  (xu-xl) .* ((pu+pl) .* (xu+xl).^2 + 2*(pu.*xu.^2 + pl.*xl.^2));

v = sum(A) / 12;

return
end

% ----- -----
function pa = Alin(a, x, p)

slope = (p(2) - p(1)) / (x(2) - x(1));
pa = (a - x(1)) * slope + p(1);

return
end

% ---- end of the nested functions
end
