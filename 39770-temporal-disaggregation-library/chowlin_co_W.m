function res = chowlin_co_W(Y,x,ta,sc,opC)
% PURPOSE: Temporal disaggregation using the Chow-Lin method
%         (quarterly rho derived from Cochrane-Orcutt annual rho)
%          Without pretesting for intercept
% ------------------------------------------------------------
% SYNTAX: res = chowlin_co_W(Y,x,ta,sc,opC);
% ------------------------------------------------------------
% OUTPUT: res: a structure
%           res.meth    ='Chow-Lin';
%           res.ta      = type of disaggregation
%           res.type    = method of estimation
%           res.N       = nobs. of low frequency data
%           res.n       = nobs. of high-frequency data
%           res.pred    = number of extrapolations
%           res.sc       = frequency conversion between low and high freq.
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
%           res.co      = Cochrane-Orcutt regression (see LeSage
%           Econometric Toolbox)
% ------------------------------------------------------------
% INPUT: Y: Nx1 ---> vector of low frequency data
%        x: nxp ---> matrix of high frequency indicators (without intercept)
%        ta: type of disaggregation
%            ta=1 ---> sum (flow)
%            ta=2 ---> average (index)
%        sc: number of high frequency data points for each low frequency data points 
%            sc= 3 ---> quarterly to monthly
%            sc= 4 ---> annual to quarterly 
%        opC: 1x1 option related to intercept
%            opc = 0 : no intercept in hf model
%            opc = 1 : intercept in hf model
% ------------------------------------------------------------
% LIBRARY: aggreg, olsc
% ------------------------------------------------------------
% SEE ALSO: chowlin, litterman, fernandez, td_plot, td_print
% ------------------------------------------------------------
% REFERENCE: Chow, G. and Lin, A.L. (1971) "Best linear unbiased 
% distribution and extrapolation of economic time series by related 
% series", Review of Economic and Statistics, vol. 53, n. 4, p. 372-375.
% Bournay, J. y Laroque, G. (1979) "Reflexions sur la methode d'elaboration 
% des comptes trimestriels", Annales de l'INSEE, n. 36, p. 3-30.

% written by:
%  Enrique M. Quilis
%  Macroeconomic Research Department
%  Ministry of Economy and Competitiveness
%  <enrique.quilis@mineco.es>

% Version 1.1 [August 2006]

t0=clock;

% ------------------------------------------------------------
% Checks

if ((sc ~= 3) & (sc ~= 4))
    error ('*** THE FREQUENCY CONVERSION SHOULD BE 3 OR 4 ***');
 end
 
if ((ta == 3) | (ta == 4))
    error ('*** THIS RELEASE DOES NOT PERFORM INTERPOLATION ***');
end

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

% ------------------------------------------------------------
% Computing annual rho by means of Cochrane-Orcutt

rex = olsc(Y,X); %Econometric Toolbox (LeSage, 1999)

Ra=rex.rho; %Getting annual rho

if (Ra < 0)
    error ('*** ANNUAL RHO IS NEGATIVE. END OF PROGRAM ***');
end

if (Ra >= 1)
   Ra = 0.99;
end

r = 0:0.01:0.99; nr = length(r); R=ones(nr,1);
switch sc
case 3 %Quarterly to monthly
   for i=1:nr
      R(i) = (r(i)^5+2*r(i)^4+3*r(i)^3+2*r(i)^2+r(i)) / (2*r(i)^2+4*r(i)+3);
   end
case 4 %Annual to quarterly
   % ------------------------------------------------------------
   % Evaluating the function that relates annual and quarterly rho
   for i=1:nr
      R(i) = (r(i)*(r(i)+1)*(r(i)^2+1)^2) / (2*(r(i)^2+r(i)+2));
   end
end
   
% -----------------------------------------------------------
% Determination of optimal rho 

[aux,h] = min(abs(Ra-R));
rho = r(h);

% -----------------------------------------------------------
% Final estimation with optimal rho

I=eye(n); w=I;
LL = diag(-ones(n-1,1),-1);

Aux=I+rho*LL;
Aux(1,1)=sqrt(1-rho^2);
w=inv(Aux'*Aux);           % High frequency VCV matrix (without sigma_a)
W=C*w*C';                  % Low frequency VCV matrix (without sigma_a)
Wi=inv(W);
beta=(X'*Wi*X)\(X'*Wi*Y);  % beta estimator
U=Y-X*beta;                % Low frequency residuals
scp=U'*Wi*U;               % Weighted least squares
sigma_a=scp/(N-p);         % sigma_a estimator
L=w*C'*Wi;                 % Filtering matrix
u=L*U;                     % High frequency residuals

% -----------------------------------------------------------
% Temporally disaggregated time series

y = x*beta + u;

% -----------------------------------------------------------
% Information criteria
% Note: p is expanded to include the innovational parameter

aic=log(sigma_a)+2*(p+1)/N;
bic=log(sigma_a)+log(N)*(p+1)/N;

% -----------------------------------------------------------
% VCV matrix of high frequency estimates

sigma_beta=sigma_a*inv(X'*Wi*X);

VCV_y=sigma_a*(eye(n)-L*C)*w+(x-L*X)*sigma_beta*(x-L*X)';

d_y=sqrt((diag(VCV_y)));   % Std. dev. of high frequency estimates
y_li=y-d_y;           % Lower lim. of high frequency estimates
y_ls=y+d_y;           % Upper lim. of high frequency estimates

% -----------------------------------------------------------
% -----------------------------------------------------------
% Loading the structure

res.meth='Chow-Lin';

% -----------------------------------------------------------
% Basic parameters 

res.ta        = ta;
res.N         = N;
res.n         = n;
res.pred      = pred;
res.sc        = sc;
res.p         = p;
res.type      = 3;  % For output convenience
res.opC       = opC;

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
% Cochrane-Orcutt results

res.co       = rex;

% -----------------------------------------------------------
% Objective function

res.val       = R;
res.r         = r;
res.valA      = Ra * ones(nr,1);
res.ropt      = rho * ones(nr,1);

% -----------------------------------------------------------
% Elapsed time

res.et        = etime(clock,t0);

