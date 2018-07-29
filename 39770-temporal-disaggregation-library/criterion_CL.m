function res = criterion_CL(Y,x,ta,type,opC,rl,X,C,N,n)
% PURPOSE: Evaluate the objective function for Chow-Lin method
% ------------------------------------------------------------
% SYNTAX: res = criterion_CL(Y,x,ta,type,opC,rl,X,C,N,n);
% ------------------------------------------------------------
% OUTPUT: res: a structure with ...
%   res.rho     --> optimal rho parameter
%   res.val     --> objective function to be optimized
%   res.wls     --> weighted least squares o.f.
%   res.loglik  --> log likelihood o.f.
%   res.r       --> range of rho to perform grid search
% ------------------------------------------------------------
% INPUT: elements used by chowlin_W(). See its source code.
% ------------------------------------------------------------
% LIBRARY: 
% ------------------------------------------------------------
% SEE ALSO: criterion_L

% written by:
%  Enrique M. Quilis
%  Macroeconomic Research Department
%  Ministry of Economy and Competitiveness
%  <enrique.quilis@mineco.es>

% Version 3.2 [April 2012]

% -----------------------------------------------------------
% Initial checks

if ((rl(1) <= -1.00) | (rl(1) >= rl(2) | (rl(2) >= 1.00)))
   error ('*** rl has invalid values ***');
end

% -----------------------------------------------------------
% -----------------------------------------------------------
% Estimation of optimal innovational parameter by means of a 
% grid search on the objective function: likelihood (type=1) 
% or weighted least squares (type=0)

% Parameters of grid search

r = linspace(rl(1),rl(2),200);
nr = length(r);

% Auxiliary matrix useful to simplify computations

I=eye(n); w=I;
LL = diag(-ones(n-1,1),-1);

wls    = zeros(1,nr); 
loglik = zeros(1,nr); 
val    = zeros(1,nr); 

% -----------------------------------------------------------
% Evaluation of the objective function in the grid

for h=1:nr;
   Aux 		= I +r(h)*LL;
   Aux(1,1) = sqrt(1-r(h)^2);
   w 			= inv(Aux'*Aux);  % High frequency VCV matrix (without sigma_a)
   W 			= C*w*C';         % Low frequency VCV matrix (without sigma_a)
   iW 	     	= inv(W);
   beta 		= (X'*iW*X)\(X'*iW*Y);   % beta estimator
   U 			= Y - X*beta;            % Low frequency residuals
   wls(h) = U' * iW * U;                 % Weighted least squares
   sigma_a = wls(h)/N;                   % sigma_a estimator (p+1 due to lagged endogenous)
   % Likelihood function
   loglik(h) 	=(-N/2)*log(2*pi*sigma_a) - (1/2)*log(det(W)) - (N/2);
   % Objective function 
   val(h) = (1-type)*(-wls(h)) + type * loglik(h);
end; 

% -----------------------------------------------------------
% Determination of optimal rho

[valmax,hmax] = max(val);
rho = r(hmax);

% -----------------------------------------------------------
% Loading the structure
% -----------------------------------------------------------

res.rho = rho;
res.val = val;
res.wls = wls;
res.loglik = loglik;
res.r      = r;
