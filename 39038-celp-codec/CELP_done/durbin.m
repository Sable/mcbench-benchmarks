function [a,xi,kappa] = durbin(r,M)
%  durbin --> Levinson-Durbin Recursion.
%
%    [a,xi,kappa] = durbin(r,M)
%
%    The function solves the Toeplitz system of equations
% 
%       [  r(1)   r(2)  ...  r(M)  ] [  a(1)  ] = [  r(2)  ]
%       [  r(2)   r(1)  ... r(M-1) ] [  a(2)  ] = [  r(3)  ]
%       [    .      .          .   ] [    .   ] = [    .   ]
%       [ r(M-1) r(M-2) ...  r(2)  ] [ a(M-1) ] = [  r(M)  ]
%       [  r(M)  r(M-1) ...  r(1)  ] [  a(M)  ] = [ r(M+1) ]
% 
%    (also known as the Yule-Walker AR equations) using the Levinson-
%    Durbin recursion. Input r is a vector of autocorrelation
%    coefficients with lag 0 as the first element. M is the order of
%    the recursion.
%
%    The output arguments are the M estimated LP parameters in the
%    column vector a, i.e., the AR coefficients are given by [1; -a].
%    The prediction error energies for the 0th-order to the Mth-order
%    solution are returned in the vector xi, and the M estimated
%    reflection coefficients in the vector kappa.
%
%    Since kappa is computed internally while computing the AR coefficients,
%    then returning kappa simultaneously is more efficient than converting
%    vector a to kappa afterwards.

% Initialization.
kappa = zeros(M,1);
a     = zeros(M,1);
xi    = [r(1); zeros(M,1)];

% Recursion.
for (j=1:M)
  kappa(j) = (r(j+1) - a(1:j-1)'*r(j:-1:2))/(xi(j)+eps);
  a(j)     = kappa(j);
  a(1:j-1) = a(1:j-1) - kappa(j)*a(j-1:-1:1);
  xi(j+1)  = xi(j)*(1 - kappa(j)^2);
end
