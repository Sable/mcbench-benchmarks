function res = litterman_W(Y,x,ta,sc,type,opC,rl)
% PURPOSE: Temporal disaggregation using the Litterman method
%          without pretesting for intercept
% ------------------------------------------------------------
% SYNTAX: res = litterman_W(Y,x,ta,sc,type,opC,rl)
% ------------------------------------------------------------
% OUTPUT: res: a structure
%           res.meth    ='Litterman';
%           res.ta      = type of disaggregation
%           res.type    = method of estimation
%           res.opC     = option related to intercept
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
%           res.rho     = innovational parameter
%           res.aic     = Information criterion: AIC
%           res.bic     = Information criterion: BIC
%           res.val     = Objective function used by the estimation method
%           res.wls     = Weighted least squares as a function of rho
%           res.loglik  = Log likelihood as a function of rho
%           res.r       = grid of innovational parameters used by the estimation method
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
%        type: estimation method: 
%            type=0 ---> weighted least squares 	
%            type=1 ---> maximum likelihood
%        opC: 1x1 option related to intercept
%            opc = 0 : no intercept in hf model
%            opc = 1 : intercept in hf model
%        rl: innovational parameter
%            rl = []: 0x0 ---> rl=[0.05 0.99], 100 points grid
%            rl: 1x1 ---> fixed value of rho parameter
%            rl: 1x2 ---> [r_min r_max] search is performed
%                on this range, using a 200 points grid
% ------------------------------------------------------------
% LIBRARY: aggreg, criterion_L
% ------------------------------------------------------------
% SEE ALSO: chowlin, fernandez, td_plot, td_print
% ------------------------------------------------------------
% REFERENCE:  Litterman, R.B. (1983a) "A random walk, Markov model 
% for the distribution of time series", Journal of Business and 
% Economic Statistics, vol. 1, n. 2, p. 169-173.

% written by:
%  Enrique M. Quilis
%  Macroeconomic Research Department
%  Ministry of Economy and Competitiveness
%  <enrique.quilis@mineco.es>

% Version 2.0 [April 2012]

t0=clock;

% ------------------------------------------------------------
% Size of the problem

[N,M] = size(Y);    % Size of low-frequency input
[n,p] = size(x);    % Size of p high-frequency inputs (without intercept)

% ------------------------------------------------------------
% Initial checks

if ((opC ~= 0) & (opC ~= 1))
      error ('*** c has an invalid value ***');
end

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
   pred = n - sc*N;           % Number of required extrapolations 
   C = [C zeros(N,pred)];
else
   pred = 0;
end

% -----------------------------------------------------------
% Temporal aggregation of the indicators

X = C*x;

% -----------------------------------------------------------
% Optimization of objective funcion (Lik. or WLS)

nrl = length(rl);

switch nrl
    case 0 %Default
        rl = [0.05 0.99];
        rex = criterion_L(Y,x,ta,type,opC,rl,X,C,N,n);
        rho = rex.rho;
        r   = rex.r;
    case 1 %Fixed innovational parameter
        rho = rl;
        type = 4;
    case 2
        rex = criterion_L(Y,x,ta,type,opC,rl,X,C,N,n);
        rho = rex.rho;
        r   = rex.r;
    otherwise
        error('*** Grid search on rho is improperly defined. Check rl ***');
end

% -----------------------------------------------------------
% Final estimation with optimal rho
% -----------------------------------------------------------

% Auxiliary matrix useful to simplify computations

I=eye(n); w=I;
LL = diag(-ones(n-1,1),-1);

Aux 		= (I + rho*LL)*(I + LL);
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
% Note: p is expanded to include the innovational parameter

aic = log(sigma_a) + 2*(p+1)/N;
bic = log(sigma_a) + log(N)*(p+1)/N;

% -----------------------------------------------------------
% VCV matrix of high frequency estimates

sigma_beta = sigma_a*inv(X'*Wi*X);

VCV_y1 =  sigma_a*(eye(n)-L*C)*w;
VCV_y2 = (x-L*X)*sigma_beta*(x-L*X)';  %If beta is fixed, this should be zero
VCV_y = VCV_y1 + VCV_y2;

d_y = sqrt((diag(VCV_y)));   % Std. dev. of high frequency estimates
y_li = y-d_y;           % Lower lim. of high frequency estimates
y_ls = y+d_y;           % Upper lim. of high frequency estimates

% -----------------------------------------------------------
% Loading the structure
% -----------------------------------------------------------

res.meth='Litterman';

% -----------------------------------------------------------
% Basic parameters 

res.ta        = ta;
res.type      = type;
res.N         = N;
res.n         = n;
res.pred      = pred;
res.sc        = sc;
res.p         = p;
res.opC       = opC;
res.rl        = rl;

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
res.rho       = rho;

% -----------------------------------------------------------
% Information criteria

res.aic       = aic;
res.bic       = bic;

% -----------------------------------------------------------
% Objective function

if (nrl == 1)
   res.val       = [];
   res.wls  	  = [];
   res.loglik 	  = [];
   res.r         = [];
else 
   res.val       = rex.val;
   res.wls  	  = rex.wls;
   res.loglik 	  = rex.loglik;
   res.r         = r;
end

% -----------------------------------------------------------
% Elapsed time

res.et  = etime(clock,t0);

