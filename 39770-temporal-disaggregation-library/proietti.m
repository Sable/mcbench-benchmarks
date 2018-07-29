function res = proietti(Y,x,ta,sc,type,opC,rl)
% PURPOSE: Temporal disaggregation using the ADL(1,1) model
%          analyzed by Proietti (2006).
% ------------------------------------------------------------
% SYNTAX: res = proietti(Y,x,ta,sc,type,opC,rl);
% ------------------------------------------------------------
% OUTPUT: res: a structure
%           res.meth    ='Proietti';
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
%           res.gamma    = estimated model parameters (including y(0) and x(0))
%           res.gamma_sd = estimated model parameters: standard deviation
%           res.gamma_t  = estimated model parameters: t ratios
%           res.rho      = dynamic parameter phi
%           res.beta     = estimated model parameters (excluding y(0) and x(0))
%           res.beta_sd = estimated model parameters: standard deviation
%           res.beta_t  = estimated model parameters: t ratios
%           res.phi     = innovational parameter
%           res.aic     = Information criterion: AIC
%           res.bic     = Information criterion: BIC
%           res.val     = Objective function used by the estimation method
%           res.wls     = Weighted least squares as a function of phi
%           res.loglik  = Log likelihood as a function of phi
%           res.r       = grid of innovational parameters used by the estimation method
%           res.et      = elapsed time
% ------------------------------------------------------------
% INPUT: Y: Nx1 ---> vector of low frequency data
%        x: nx1 ---> matrix of high frequency indicator (without intercept)
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
%            opc = -1 : pretest intercept significance
%            opc = 0 : no intercept in hf model
%            opc = 1 : intercept in hf model
%        rl: innovational parameter
%            rl = []: 0x0 ---> rl=[0.05 0.99], 100 points grid
%            rl: 1x1 ---> fixed value of rho parameter
%            rl: 1x2 ---> [r_min r_max] search is performed
%                on this range, using a 200 points grid
% ------------------------------------------------------------
% LIBRARY: ar_order, arx, upredict, ssc
% ------------------------------------------------------------
% SEE ALSO: ssc, chowlin, litterman, fernandez, td_plot, td_print
% ------------------------------------------------------------
% REFERENCE: Proietti, T. (2006) "Temporal disaggregation by state space
% methods: dynamic regression methods revisited", Econometrics Journal,
% vol. 9, p. 357-372.
% ------------------------------------------------------------
% NOTE: This version only considers the case p=1 (without intercept).
% Initial condition for x is provided via backasting using an univariate
% AR(p) model. The order of the AR is determined via AIC. It can be changed
% to BIC.

% written by:
%  Enrique M. Quilis
%  Macroeconomic Research Department
%  Ministry of Economy and Competitiveness
%  <enrique.quilis@mineco.es>

% Version 1.1 [April 2012]

% ------------------------------------------------------------
% Initial checks

if ((opC ~= -1) & (opC ~= 0) & (opC ~= 1))
      error ('*** opC has an invalid value ***');
end

% Only one indicator
[n,p] = size(x);

if (p > 1)
      error ('*** This version only processes one indicator ***');
end
    
% ------------------------------------------------------------
% Estimating initial condition for x by means of backcasting.
% Backcasts are generated according to an AR(p) model. Order p
% is determined according to minimum AIC.

% Maximum AR order for AIC search.
pmax = 2*sc;

% Flipping x
xa = flipud(x);

% Computing AIC and BIC
[aic_ bic_] = ar_order(xa,pmax,0);

% Determining min AIC
[v p_] = min(aic_);

% AR model: setting
rex.X = [];
rex.z = xa;
rex.opC = 1;
rex.p = p_;

% AR model: estimation
rexx = arx(rex);

% AR model: forecasting (backcasting)
rex.npred = 1;
rex.Xf = [];
resf = upredict(rex,rexx);

% Forming x as x(t) and x(t-1), with x(o)=backcast.
x = [x  [resf.zf ; x(1:end-1)]];

% ------------------------------------------------------------
% Pretesting intercept
if (opC == -1)
    tex = ssc(Y,x,ta,sc,type,1,rl);
    ti = tex.beta_t(1);
    if (abs(ti) < 2)
        opC = 0;
    else
        opC = 1;
    end
end

% Final estimation
res = ssc(Y,x,ta,sc,type,opC,rl);
res.meth = 'Proietti';

