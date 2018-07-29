function res = ssc_W(Y,x,ta,sc,type,opC,rl)
% PURPOSE: Temporal disaggregation using the dynamic Chow-Lin method
%          proposed by Santos Silva-Cardoso (2001).
%          Without pretesting for intercept
% ------------------------------------------------------------
% SYNTAX: res = ssc_W(Y,x,ta,sc,type,opC,rl);
% ------------------------------------------------------------
% OUTPUT: res: a structure
%           res.meth    ='Santos Silva-Cardoso';
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
%           res.gamma    = estimated model parameters (including y(0))
%           res.gamma_sd = estimated model parameters: standard deviation
%           res.gamma_t  = estimated model parameters: t ratios
%           res.phi      = dynamic parameter phi
%           res.beta     = estimated model parameters (excluding y(0))
%           res.beta_sd = estimated model parameters: standard deviation
%           res.beta_t  = estimated model parameters: t ratios
%           res.phi     = innovational parameter
%           res.aic     = Information criterion: AIC
%           res.bic     = Information criterion: BIC
%           res.val     = Objective function used by the estimation method
%           res.wls     = Weighted least squares as a function of phi
%           res.loglik  = Log likelihood as a function of phi
%           res.r       = grid of innovational parameters used by the estimation method
%           res.et       = elapsed time
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
%            rl: 1x1 ---> fixed value of phi parameter
%            rl: 1x2 ---> [r_min r_max] search is performed
%                on this range, using a 200 points grid
% ------------------------------------------------------------
% LIBRARY: aggreg, criterion_SSC
% ------------------------------------------------------------
% SEE ALSO: chowlin, litterman, fernandez, td_plot, td_print
% ------------------------------------------------------------
% REFERENCE: Santos, J.M.C. and Cardoso, F.(2001) "The Chow-Lin method
% using dynamic models",Economic Modelling, vol. 18, p. 269-280.
% Di Fonzo, T. (2002) "Temporal disaggregation of economic time series: 
% towards a dynamic extension", Dipartimento di Scienze Statistiche, 
% Universita di Padova, Working Paper n. 2002-17.

% written by:
%  Enrique M. Quilis
%  Macroeconomic Research Department
%  Ministry of Economy and Competitiveness
%  <enrique.quilis@mineco.es>

% Version 2.1 [April 2012]

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
        rex = criterion_SSC(Y,x,ta,type,opC,rl,X,C,N,n,p);
        phi = rex.phi;
        r   = rex.r;
    case 1 %Fixed innovational parameter
        phi = rl;
        type = 4;
    case 2
        rex = criterion_SSC(Y,x,ta,type,opC,rl,X,C,N,n,p);
        phi = rex.phi;
        r   = rex.r;
    otherwise
        error('*** Grid search on phi is improperly defined. Check rl ***');
end

% -----------------------------------------------------------
% Final estimation with optimal phi
% -----------------------------------------------------------

% Auxiliary matrix useful to simplify computations

I=eye(n); w=I;
LL = diag(-ones(n-1,1),-1);

% -----------------------------------------------------------
% Final estimation with optimal phi

% -----------------------------------------------------------
% Generation of difference matrix D_phi

D_phi = I + phi*LL;
D_phi(1,1)=sqrt(1-phi^2);
iD_phi = inv(D_phi);

% -----------------------------------------------------------
% Truncation remainder: q parameter

q=zeros(n,1);
q(1)=phi;

% -----------------------------------------------------------
% Expanded set of regressors: high and low frequency

z = [x q];
z_phi = iD_phi * z;
Z_phi = C * z_phi;

% -----------------------------------------------------------
% GLS estimator of gamma

w = inv(D_phi' * D_phi);
W = C * w * C';
iW = inv(W);

gamma = (Z_phi' * iW * Z_phi) \ (Z_phi' * iW * Y); % gamma GLS

U = Y - Z_phi * gamma;           % Low frequency residuals
scp = U' * iW * U;               % Weighted least squares
sigma_a = scp/(N-p-1);           % sigma_a estimator (p+1 due to lagged endogenous)
L = w * C' * iW;                 % Filtering matrix
u = L * U;                       % High frequency residuals

% -----------------------------------------------------------
% Temporally disaggregated time series

y = z_phi * gamma + u;

% -----------------------------------------------------------
% Information criteria
% p is expanded to include lagged endogenous

aic=log(sigma_a)+2*(p+1)/N;
bic=log(sigma_a)+log(N)*(p+1)/N;

% -----------------------------------------------------------
% VCV matrix of high frequency estimates

sigma_gamma = sigma_a * inv(Z_phi' * iW * Z_phi);

VCV_y = sigma_a * (eye(n)-L*C) * w + (z_phi-L*Z_phi) * sigma_gamma * (z_phi-L*Z_phi)';

d_y=sqrt((diag(VCV_y)));   % Std. dev. of high frequency estimates
y_li=y-d_y;                % Lower lim. of high frequency estimates
y_ls=y+d_y;                % Upper lim. of high frequency estimates

% -----------------------------------------------------------
% -----------------------------------------------------------
% Loading the structure

res.meth='Santos Silva-Cardoso';

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

res.gamma     = gamma;
res.gamma_sd  = sqrt(diag(sigma_gamma));
res.gamma_t   = gamma./sqrt(diag(sigma_gamma));
res.phi       = phi;

res.beta      = gamma(1:end-1);
res.beta_sd   = res.gamma_sd(1:end-1);
res.beta_t    = res.gamma_t(1:end-1);
res.sigma_a   = sigma_a;

% -----------------------------------------------------------
% Information criteria

res.aic       = aic;
res.bic       = bic;

% -----------------------------------------------------------
% Objective function

if (nrl == 1)
   res.val      = [];
   res.wls      = [];
   res.loglik   = [];
   res.r        = [];
else 
   res.val       = rex.val;
   res.wls  	 = rex.wls;
   res.loglik    = rex.loglik;
   res.r         = r;
end

% -----------------------------------------------------------
% Elapsed time

res.et  = etime(clock,t0);

