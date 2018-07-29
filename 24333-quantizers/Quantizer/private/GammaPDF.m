function FPDF = GammaPDF
% Return function handles to routines to calculate the area, mean,
% and second moment of a unit-variance, zero-mean, Gamma probability
% density function with parameter 1/2.
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
% with a=1/2, and b=sqrt(a(a+1)) and where G(a) is the complete
% gamma function.

FPDF = {@GGarea, @GGmean, @GGvar};

% ----- ------
function v = GGarea (a, b)

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

function v = F0(x)

xn = 0.5*sqrt(3)*x;
v = -0.5 * erfc(sqrt(xn));

return


% ----- ------
function v = GGmean (a, b)

% Since the integrand x*p(x) is odd, Gmean(A,B)=Gmean(abs(A),abs(B))
v = F1(abs(b)) - F1(abs(a));

return

% -----
% Evaluate the indefinite integral
% The definite integral between a and b is F1(b) - F1(a)

function v = F1 (x)

if (x > 900)
  v = 0;
else
  xn = 0.5*sqrt(3)*x;
  v = -( 0.5*erfc(sqrt(xn)) + sqrt(xn)*exp(-xn)/sqrt(pi) ) / sqrt(3);
end
  
return

% ----- ------
function v = GGvar (a, b)

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

function v = F2 (x)

% The function evaluation fails for x = Inf because the term x e^(-x^2/2)
% in the expression returns NaN. For non-infinite x, the expression
% evaluates to 0 for large x.

if (x > 900)
  v = 0;
else
  xn = 0.5*sqrt(3)*x;
  v = -( 0.5*erfc(sqrt(xn)) + sqrt(xn)*exp(-xn)*(1+2*xn/3)/sqrt(pi) );
end

return
