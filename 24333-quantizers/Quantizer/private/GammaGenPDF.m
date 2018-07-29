function FPDF = GammaGenPDF (a)
% Return function handles to routines to calculate the area, mean,
% and second moment of a unit-variance, zero-mean, generalized
% Gamma probability density function with parameter a.
%                 b
%   Farea(a,b) = Int p(x) dx
%                 a
%                 b
%   Fmean(a,b) = Int x p(x) dx
%                 a
%                b
%   Fvar(a,b) = Int x^2 p(x) dx
%                a
% where p(x) = b/(2G(a) exp(-b|x|) (b|x|)^(a-1)
% with b=sqrt(a(a+1)) and where G(a) is the complete gamma function.

% global GGenPar
GGenPar = a;   % GGenPar available to nested functions

FPDF = {@GGenarea, @GGenmean, @GGenvar};

return

%----- ----- begin nested functions
function v = GGenarea (a, b)

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
end

% -----
% Evaluate the indefinite integral
% The definite integral between a and b is F0(b) - F0(a)

function v = F0(x)

% global GGenPar

v = -Gamma2aCCDF(x, GGenPar);

return
end

% ----- ------
function v = GGenmean (a, b)

% Since the integrand x*p(x) is odd, Gmean(A,B)=Gmean(abs(A),abs(B))
v = F1(abs(b)) - F1(abs(a));

return
end

% -----
% Evaluate the indefinite integral
% The definite integral between a and b is F1(b) - F1(a)

function v = F1 (x)

% global GGenPar

n = 1;
a1 = GGenPar;
a2 = a1 + n;
b1 = sqrt(a1*(a1+1));
b2 = sqrt(a2*(a2+1));
v = -gamma(a2)/(gamma(a1)*b1^n) * Gamma2aCCDF(b1*abs(x)/b2, a2);
% Simplifications for n=1,
%   G(a2)=(a1+1) G(a1)
% Then
%   G(a2)/(G(a1) b1) = sqrt((a1+1)/a1)
%              b1/b2 = sqrt(a1/(a1+1))

return
end

% ----- ------
function v = GGenvar (a, b)

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
end

% -----
% Evaluate the indefinite integral
% The definite integral between a and b is F2(b) - F2(a)

function v = F2 (x)

% global GGenPar

n = 2;
a1 = GGenPar;
a2 = a1 + n;
b1 = sqrt(a1*(a1+1));
b2 = sqrt(a2*(a2+1));
v = -gamma(a2)/(gamma(a1)*b1^n) * Gamma2aCCDF(b1*x/b2, a2);
% Simplifications for n=2,
%   G(a2)=(a1+2)(a1+1) G(a1)
% Then
%   G(a2)/(G(a1) b1^2) = (a1+2)/a1
%                b1/b2 = sqrt(a1(a1+1)/((a1+2)(a1+3))
return
end

% ---- end of the nested functions
end
