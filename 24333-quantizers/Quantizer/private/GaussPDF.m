function FPDF = GaussPDF
% Return function handles to routines to calculate the area, mean, and
% second moment of a unit-variance, zero-mean, Gaussian probability
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
% where p(x) = 1/sqrt(2 pi) e^(-x^2/2)

FPDF = {@Garea, @Gmean, @Gvar};

% ----- ------
function v = Garea (a, b)

% Evaluate the function so as to avoid taking differences
% between nearly equal quantities (e.g. when a<0 and b<0)
if (b >= 0)
  if (a >= 0)
    v = F0(b) - F0(a);                    % Both a and b positive
  else
    v = (F0(b) + 0.5) + (F0(-a) + 0.5);   % a negative, b positive
  end
else
  if (a < 0)
    v = F0(-a) - F0(-b);                  % Both a and b negative
  else
    v = (-0.5 - F0(a)) + (-0.5 - F0(-b)); % a positive, b negative
  end
end

return

% -----
% Evaluate the indefinite integral
% The definite integral between a and b is F0(b) - F0(a)
%
% F0(x) = c Int e^(-x^2/2) dx  [c = 1/sqrt(2 pi)]
%       = -Q(x)
%       = -1/2 erfc(x/sqrt(2))

function v = F0(x)

v = -0.5*erfc(x/sqrt(2));

return


% ----- ------
function v = Gmean (a, b)

% Since the integrand x*p(x) is odd, Gmean(A,B)=Gmean(abs(A),abs(B))
v = F1(abs(b)) - F1(abs(a));

return

% -----
% Evaluate the indefinite integral
% The definite integral between a and b is F1(b) - F1(a)
%
% F1(x) = c Int x e^(-x^2/2) du,
%
% A change of variables v=x^2/2, dv=x dx, gives
%
% F1(x) = c Int e^(-v) dv
%       = -c e^(-v)
%       = -c e^(-x^2/2)

function v = F1 (x)

v = -exp(-0.5*x^2)/sqrt(2*pi);

return

% ----- ------
function v = Gvar (a, b)

% Evaluate the function so as to avoid taking differences
% between nearly equal quantities (e.g. when a<0 and b<0)
if (b >= 0)
  if (a >= 0)
    v = F2(b) - F2(a);                    % Both a and b positive
  else
    v = (F2(b) + 0.5) + (F2(-a) + 0.5);   % a negative, b positive
  end
else
  if (a < 0)
    v = F2(-a) - F2(-b);                  % Both a and b negative
  else
    v = (-0.5 - F2(a)) + (-0.5 - F2(-b)); % a positive, b negative
  end
end

return

% -----
% Evaluate the indefinite integral
% The definite integral between a and b is F2(b) - F2(a)
%
% F2(x) = c Int x^2 e^(-x^2/2) dx
%
% Using integration by parts, identify
%    f(x) = x,           f'(x) = 1,
%   g'(u) = x e^(-x2/2),  g(x) = -e^(-x^2/2)
%
%  Int f(x) g'(x) dx = f(x) g(x) - Int f'(x) g(x) dx
%
% Then
% F2(x) = -c x e^(-x^2/2) + c Int e^(-x^2/2) dx
%       = -c x e^(-x^2/2) - Q(x)

function v = F2 (x)

% The function evaluation fails for x = Inf because the term x e^(-x^2/2)
% in the expression returns NaN. For non-infinite x, the expression
% evaluates to 0 for large x.
xmax = 40;
if (x > xmax)
  v = 0;
else
  v = -x*exp(-0.5*x^2)/sqrt(2*pi) - 0.5*erfc(x/sqrt(2));
end

return
