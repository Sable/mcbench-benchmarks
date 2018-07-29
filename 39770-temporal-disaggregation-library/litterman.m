function res = litterman(Y,x,ta,sc,type,opC,rl)
% PURPOSE: Temporal disaggregation using the Litterman method
% ------------------------------------------------------------
% SYNTAX: res = litterman(Y,x,ta,sc,type,opC,rl)
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
%            opc = -1 : pretest intercept significance
%            opc = 0 : no intercept in hf model
%            opc = 1 : intercept in hf model
%        rl: innovational parameter
%            rl = []: 0x0 ---> rl=[0.05 0.99], 100 points grid
%            rl: 1x1 ---> fixed value of rho parameter
%            rl: 1x2 ---> [r_min r_max] search is performed
%                on this range, using a 200 points grid
% ------------------------------------------------------------
% LIBRARY: litterman
% ------------------------------------------------------------
% SEE ALSO: chowlin, fernandez, td_plot, td_print
% ------------------------------------------------------------
% REFERENCE:  Litterman, R.B. (1983a) "A random walk, Markov model 
% for the distribution of time series", Journal of Business and 
% Economic Statistics, vol. 1, n. 2, p. 169-173.
% written by:

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

% ------------------------------------------------------------
% Pretesting intercept

if (opC == -1)
    rex = litterman_W(Y,x,ta,sc,type,1,rl);
    ti = rex.beta_t(1);
    if (abs(ti) < 2)
        opC = 0;
    else
        opC = 1;
    end
end

% Final estimation
res = litterman_W(Y,x,ta,sc,type,opC,rl);
    
