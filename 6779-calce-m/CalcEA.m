% Solves for eccentric anomaly, E from a given mean anomaly, M
% and eccentricty, e.  Performs a simple Newton-Raphson iteration
%
% M must be in radians and E is returned in radians.
%
% Default tolerances is 10^-8 rad.
%
% E = CalcEA(M,e) uses default tolerances
%
% E = CalcEA(M,e,tol) will use a user specified tolerance, tol
% 
% Richard Rieber
% 1/23/2005
% E-mail problems/suggestions rrieber@gmail.com

function E = CalcEA(M,e,tol)

%Checking for user inputed tolerance
if nargin == 2
    %using default value
    tol = 10^-8;
elseif nargin > 3
    error('Too many inputs.  See help CalcE')
elseif nargin < 2
    error('Too few inputs.  See help CalcE')
end

Etemp = M;
ratio = 1;
while abs(ratio) > tol
    f_E = Etemp - e*sin(Etemp) - M;
    f_Eprime = 1 - e*cos(Etemp);
    ratio = f_E/f_Eprime;
    if abs(ratio) > tol
        Etemp = Etemp - ratio;
    else
        E = Etemp;
    end
end