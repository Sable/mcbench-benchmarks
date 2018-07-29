function res = fernandez(Y,x,ta,sc,opC)
% PURPOSE: Temporal disaggregation using the Fernandez method
% ------------------------------------------------------------
% SYNTAX: res = fernandez(Y,x,ta,sc,opC);
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
%            opc = -1 : pretest intercept significance
%            opc =  0 : no intercept in hf model
%            opc =  1 : intercept in hf model
% ------------------------------------------------------------
% LIBRARY: fernandez_W
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


% ------------------------------------------------------------
% Initial checks

if ((opC ~= -1) & (opC ~= 0) & (opC ~= 1))
      error ('*** opC has an invalid value ***');
end

% ------------------------------------------------------------
% Pretesting intercept

if (opC == -1)
    rex = fernandez_W(Y,x,ta,sc,1);
    ti = rex.beta_t(1);
    if (abs(ti) < 2)
        opC = 0;
    else
        opC = 1;
    end
end

% Final estimation

res = fernandez_W(Y,x,ta,sc,opC);
    
