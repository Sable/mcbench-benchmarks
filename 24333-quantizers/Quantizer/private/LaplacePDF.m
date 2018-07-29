function FPDF = LaplacePDF
% Return function handles to routines to calculate the area, mean, and
% second moment of a unit-variance, zero-mean, Laplacian probability
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
% where p(x) = 1/c e^(-c|x|), with c = sqrt(2)

FPDF = {@Larea, @Lmean, @Lvar};

% ----- ------
function v = Larea (a, b)

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

% F0(x) = 1/c Int e^(-cx) dx
%       = -1/c^2 e^(-cx)
%       = -1/2 e^(-cx)

function v = F0(x)

v = -0.5*exp(-sqrt(2)*x);   % x >= 0

return


% ----- ------
function v = Lmean (a, b)

% Since the integrand x*p(x) is odd, Gmean(A,B)=Gmean(abs(A),abs(B))
v = F1(abs(b)) - F1(abs(a));

return

% -----
% Evaluate the indefinite integral
% The definite integral between a and b is F1(b) - F1(a)
%
% F1(x) = 1/c Int x e^(-cx) dx,
%
% Using integration by parts, identify
%    f(x) = x,        f'(x) = 1,
%   g'(x) = e^(-cx),   g(x) = -1/c e^(-cx)
%
% Int f(x) g'(x) dx = f(x) g(x) - Int f'(x) g(x) dx
%
% Then
% F1(x) = 1/c [-1/c x e^(-cx) + 1/c Int e^(-cx) dx]
%       = 1/c [-1/c x e^(-cx) - 1/c^2 e^(-cx)]
%       = -1/2 [x + 1/c] e^(-cx)

function v = F1 (x)

xmax = 600;
if (x > xmax)
  v = 0;
else
  v = -0.5 * (x + 1/sqrt(2)) * exp(-sqrt(2)*x);   % x >= 0
end

return

% ----- ------
function v = Lvar (a, b)

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
% F2(x) = 1/c Int x^2 e^(-cx) dx,
%
% Using integration by parts, identify
%    f(x) = x^2,      f'(x) = 2x,
%   g'(x) = e^(-cx),   g(x) = -1/c e^(-cx)
%
% Int f(x) g'(x) dx = f(x) g(x) - Int f'(x) g(x) dx
%
% Then
% F2(x) = 1/c [-1/c x^2 e^(-cx) + 2/c Int x e^(-cx) dx]  see F1(x)
%       = 1/c [-1/c x^2 e^(-cx) - 2/c 1/c (x + 1/c) e^(-cx)]
%       = -1/c^2 (x^2 + 2/c x + 2/c^2) e^(-cx)
%       = -1/2 ((x+1/c)^2 + 1/2) e^(-cx)

function v = F2 (x)

xmax = 600;
if (x > xmax)
  v = 0;
else
  v = -0.5 * exp(-sqrt(2)*x) * ((x + 1/sqrt(2))^2 + 0.5);   % x >= 0
end

return
