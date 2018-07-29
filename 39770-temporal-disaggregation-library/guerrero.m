function res = guerrero(Y,x,ta,sc,rexw,rexd,opC)
% PURPOSE: ARIMA-based temporal disaggregation: Guerrero method
% ------------------------------------------------------------
% SYNTAX: res = guerrero(Y,x,ta,sc,rexw,rexd,opC);
% ------------------------------------------------------------
% OUTPUT: res: a structure
%         res.meth     ='Guerrero';
%         res.ta       = type of disaggregation
%         res.opC     = option related to intercept
%         res.N        = nobs. of low frequency data
%         res.n        = nobs. of high-frequency data
%         res.pred     = number of extrapolations
%         res.sc        = frequency conversion between low and high freq.
%         res.p        = number of regressors (+ intercept)
%         res.Y        = low frequency data
%         res.x        = high frequency indicators
%         res.w        = scaled indicator (preliminary hf estimate)
%         res.y1       = first stage high frequency estimate
%         res.y        = final high frequency estimate
%         res.y_dt     = high frequency estimate: standard deviation
%         res.y_lo     = high frequency estimate: sd - sigma
%         res.y_up     = high frequency estimate: sd + sigma
%         res.delta    = high frequency discrepancy (y1-w)
%         res.u        = high frequency residuals (y-w)
%         res.U        = low frequency residuals (Cu)
%         res.beta     = estimated parameters for scaling x
%         res.k        = statistic to test compatibility
%         res.et       = elapsed time
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
%        rexw, rexd ---> a structure containing the parameters of ARIMA model
%            for indicator and discrepancy, respectively (see calT function)
%        opC: 1x1 option related to intercept
%            opc = -1 : pretest intercept significance
%            opc =  0 : no intercept in hf model
%            opc =  1 : intercept in hf model
% ------------------------------------------------------------
% LIBRARY: guerrero_W
% ------------------------------------------------------------
% SEE ALSO: chowlin, litterman, fernandez, td_print, td_plot
% ------------------------------------------------------------
% REFERENCE: Guerrero, V. (1990) "Temporal disaggregation of time
% series: an ARIMA-based approach", International Statistical
% Review, vol. 58, p. 29-46.

% written by:
%  Enrique M. Quilis
%  Macroeconomic Research Department
%  Ministry of Economy and Competitiveness
%  <enrique.quilis@mineco.es>

% Version 1.0 [August 2006]

% ------------------------------------------------------------
% Initial checks

if ((opC ~= -1) & (opC ~= 0) & (opC ~= 1))
      error ('*** opC has an invalid value ***');
end

% ------------------------------------------------------------
% Pretesting intercept

if (opC == -1)
    rex = guerrero_W(Y,x,ta,sc,rexw,rexd,1);
    ti = rex.beta_t(1);
    if (abs(ti) < 2)
        opC = 0;
    else
        opC = 1;
    end
end

% Final estimation

res = guerrero_W(Y,x,ta,sc,rexw,rexd,opC);
    
