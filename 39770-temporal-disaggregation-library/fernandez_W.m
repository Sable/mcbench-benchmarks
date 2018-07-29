function res = fernandez_W(Y,x,ta,sc,opC)
% PURPOSE: Temporal disaggregation using the Fernandez method
%          without pretesting for intercept
% ------------------------------------------------------------
% SYNTAX: res = fernandez_W(Y,x,ta,sc,opC);
% ------------------------------------------------------------
% OUTPUT: res: a structure
%           res.meth    ='Fernandez';
%           res.ta      = type of disaggregation
%           res.type    = method of estimation
%           res.N       = nobs. of low frequency data
%           res.n       = nobs. of high-frequency data
%           res.pred    = number of extrapolations
%           res.sc      = frequency conversion between low and high freq.
%           res.p       = number of regressors (including intercept)
%           res.Y       = low frequency data
%           res.x       = high frequency indicators
%           res.y       = high frequency estimate
%           res.y_dt    = high frequency estimate: standard deviation
%           res.y_lo    = high frequency estimate: sd - sigma
%           res.y_up    = high frequency estimate: sd + sigma
%           res.u       = high frequency residuals
%           res.U       = low frequency residuals
%           res.beta    = estimated model parameters
%           res.beta_sd = estimated model parameters: standard deviation
%           res.beta_t  = estimated model parameters: t ratios
%           res.aic     = Information criterion: AIC
%           res.bic     = Information criterion: BIC
% ------------------------------------------------------------
% INPUT: Y: Nx1 ---> vector of low frequency data
%        x: nxp ---> matrix of high frequency indicators (without intercept)
%        ta: type of disaggregation
%            ta=1 ---> sum (flow)
%            ta=2 ---> average (index)
%            ta=3 ---> last element (stock) ---> interpolation
%            ta=4 ---> first element (stock) ---> interpolation
%        sc: number of high frequency data points for each low frequency data points 
%            sc= 4 ---> annual to quarterly
%            sc=12 ---> annual to monthly
%            sc= 3 ---> quarterly to monthly
%        opC: 1x1 option related to intercept
%            opc = 0 : no intercept in hf model
%            opc = 1 : intercept in hf model
% ------------------------------------------------------------
% LIBRARY: aggreg
% ------------------------------------------------------------
% SEE ALSO: chowlin, litterman, td_plot, td_print
% ------------------------------------------------------------
% REFERENCE: Fernandez, R.B.(1981)"Methodological note on the 
% estimation of time series", Review of Economic and Statistics, 
% vol. 63, n. 3, p. 471-478.

% written by:
%  Enrique M. Quilis
%  Macroeconomic Research Department
%  Ministry of Economy and Competitiveness
%  <enrique.quilis@mineco.es>

% Version 1.1 [August 2006]

t0=clock;

% ------------------------------------------------------------
% Size of the problem

[N,M] = size(Y);    % Size of low-frequency input
[n,p] = size(x);    % Size of p high-frequency inputs (without intercept)

% ------------------------------------------------------------
% Preparing the X matrix: including an intercept if opC==1

if (opC == 1)
   e=ones(n,1);   
   x=[e x];       % Expanding the regressor matrix
   p=p+1;         % Number of p high-frequency inputs (plus intercept)
end

% ------------------------------------------------------------
% Generating the aggregation matrix

C = aggreg(ta,N,sc);

% -----------------------------------------------------------
% Expanding the aggregation matrix to perform
% extrapolation if needed.

if (n > sc * N)
   pred=n-sc*N;           % Number of required extrapolations 
   C=[C zeros(N,pred)];
else
   pred=0;
end

% -----------------------------------------------------------
% Temporal aggregation of the indicators

X=C*x;

I=eye(n); w=I;
LL = diag(-ones(n-1,1),-1);

Aux 		= I + LL;
w 			= inv(Aux'*Aux);        % High frequency VCV matrix (without sigma_a)
W 			= C*w*C';               % Low frequency VCV matrix (without sigma_a)
Wi 		= inv(W);
beta 		= (X'*Wi*X)\(X'*Wi*Y);  % beta estimator
U 			= Y - X*beta;           % Low frequency residuals
wls 		= U'*Wi*U;              % Weighted least squares
sigma_a 	= wls/(N-p);         	% sigma_a estimator
L 			= w*C'*Wi;              % Filtering matrix
u 			= L*U;            

% -----------------------------------------------------------
% Temporally disaggregated time series

y = x*beta + u;

% -----------------------------------------------------------
% Information criteria
% Note: p is NOT expanded to include the innovational parameter

aic = log(sigma_a)+2*p/N;
bic = log(sigma_a)+log(N)*p/N;

% -----------------------------------------------------------
% VCV matrix of high frequency estimates

sigma_beta=sigma_a*inv(X'*Wi*X);

VCV_y1 =  sigma_a*(eye(n)-L*C)*w;
VCV_y2 = (x-L*X)*sigma_beta*(x-L*X)';  %If beta is fixed, this should be zero
VCV_y = VCV_y1 + VCV_y2;

d_y=sqrt((diag(VCV_y)));   % Std. dev. of high frequency estimates
y_li = y - d_y;           % Lower lim. of high frequency estimates
y_ls = y + d_y;           % Upper lim. of high frequency estimates

% -----------------------------------------------------------
% -----------------------------------------------------------
% Loading the structure

res.meth='Fernandez';

% -----------------------------------------------------------
% Basic parameters 

res.ta        = ta;
res.type      = 2;       % For output convenience
res.N         = N;
res.n         = n;
res.pred      = pred;
res.opC       = opC;
res.sc        = sc;
res.p         = p;

% -----------------------------------------------------------
% Series

res.Y         = Y;
res.x         = x;
res.y         = y;
res.y_dt      = d_y;
res.y_lo      = y_li;
res.y_up      = y_ls;

% -----------------------------------------------------------
% Residuals

res.u         = u;
res.U         = U;

% -----------------------------------------------------------
% Parameters

res.beta      = beta;
res.beta_sd   = sqrt(diag(sigma_beta));
res.beta_t    = beta./sqrt(diag(sigma_beta));
res.rho       = 1.00;

% -----------------------------------------------------------
% Information criteria

res.aic       = aic;
res.bic       = bic;

% -----------------------------------------------------------
% Elapsed time

res.et        = etime(clock,t0);
