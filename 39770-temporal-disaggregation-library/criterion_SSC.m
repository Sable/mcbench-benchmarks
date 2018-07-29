function res = criterion_SSC(Y,x,ta,type,opC,rl,X,C,N,n,p)
% PURPOSE: Evaluate the objective fun: Santos Silva-Cardoso method
% ------------------------------------------------------------
% SYNTAX: res = criterion_SSc(Y,x,ta,type,opC,rl,X,C,N,n);
% ------------------------------------------------------------
% OUTPUT: res: a structure with ...
%   res.phi     --> optimal phi parameter
%   res.val     --> objective function to be optimized
%   res.wls     --> weighted least squares o.f.
%   res.loglik  --> log likelihood o.f.
%   res.r       --> range of phi to perform grid search
% ------------------------------------------------------------
% INPUT: elements used by ssc_W(). See its source code.
% ------------------------------------------------------------
% LIBRARY: 
% ------------------------------------------------------------
% SEE ALSO: criterion_CL, criterion_L

% written by:
%  Enrique M. Quilis
%  Macroeconomic Research Department
%  Ministry of Economy and Competitiveness
%  <enrique.quilis@mineco.es>

% Version 1.1 [August 2006]

% -----------------------------------------------------------
% Initial checks

if ((rl(1) <= -1.00) | (rl(1) >= rl(2) | (rl(2) >= 1.00)))
   error ('*** rl has invalid values ***');
end


% -----------------------------------------------------------
% Estimation of optimal innovational parameter by means of a 
% grid search on the objective function: likelihood (type=1) 
% or weighted least squares (type=0)

% Parameters of grid search
r = linspace(rl(1),rl(2),200);
nr = length(r);

% Auxiliary matrix useful to simplify computations
I=eye(n); w=I; D_phi=I; iD_phi=I;
LL = diag(-ones(n-1,1),-1);

wls    = zeros(1,nr); 
loglik = zeros(1,nr); 
val    = zeros(1,nr); 

% -----------------------------------------------------------
% Evaluation of the objective function in the grid

q=zeros(n,1); 
z = [x q];

for h=1:nr;
   D_phi = I + r(h)*LL;
   D_phi(1,1)=sqrt(1-r(h)^2);
   iD_phi = inv(D_phi);
   % -----------------------------------------------------------
   % Expanded set of regressors: high and low frequency
   z(1,end) = r(h); % Truncation remainder q is included
   z_phi = iD_phi * z;
   Z_phi = C * z_phi;
   % -----------------------------------------------------------
   % GLS estimator of gamma
   w = inv(D_phi' * D_phi);
   W = C * w * C';
   iW = inv(W);   
   gamma = (Z_phi' * iW * Z_phi) \ (Z_phi' * iW * Y); % gamma GLS
   U = Y - Z_phi * gamma;           % Low frequency residuals
   wls(h) = U' * iW * U;               % Weighted least squares
   sigma_a = wls(h)/(N-p-1);           % sigma_a estimator (p+1 due to lagged endogenous)
   % Likelihood function
   loglik(h) 	=(-N/2)*log(2*pi*sigma_a) - (1/2)*log(det(W)) - (N/2);
   % Objective function 
   val(h) = (1-type)*(-wls(h)) + type * loglik(h);
end; % of loop h

% -----------------------------------------------------------
% Determination of optimal phi

[valmax,hmax]=max(val);
phi=r(hmax);

% -----------------------------------------------------------
% Loading the structure
% -----------------------------------------------------------

res.phi = phi;
res.val = val;
res.wls = wls;
res.loglik = loglik;
res.r      = r;
