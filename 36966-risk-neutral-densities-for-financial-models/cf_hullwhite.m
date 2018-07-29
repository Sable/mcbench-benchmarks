% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Joerg Kienitz
%           Daniel Wetterau
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 


function y = cf_hullwhite(u,T,t_star,lambda,eta,ircurve)
% characteristic function for the Hull White model
    %CURRENTLY ASSUMES t_star = 0
    
    %maturity dates
    date_t = add2date(ircurve.Settle,t_star);
    date_T = add2date(ircurve.Settle,T);
 
    %time to maturity
    tau_0_T = diag(yearfrac(ircurve.Settle,date_T));
    %CURRENTLY equals zero
    tau_0_t = diag(yearfrac(ircurve.Settle,date_t));
    %CURRENTLY equal tau_0_T
    tau_t_T = diag(yearfrac(date_t,date_T));
    
    %used for short rate and  instantaneous forward rate calculations
    Delta = 1e-6;
    P0_T = ircurve.getDiscountFactors(date_T);
    %CURRENTLY P(0,t) equals one since t = 0
    P0_t = 1.0;%ircurve.getDiscountFactors(date_t);%doesn't work well / P(t,t) should equal 1
    P0_t_plus_Delta = interp1([ircurve.Settle;ircurve.Dates],[1.0;ircurve.Data],datenum(date_t+Delta),'linear');

    %CURRENTLY short rate = instantaneous forward rate
    %--------------------------------------------------
    %short rate
    instR = (1.0/P0_t_plus_Delta-1)/yearfrac(ircurve.Settle,datenum(date_t+Delta));
    %instantaneous forward rate
    instF = -(P0_t_plus_Delta - P0_t)/yearfrac(ircurve.Settle,datenum(date_t+Delta))./P0_t;
    
    %CURRENTLY not used
    %----------------------------------------------
    %dt = yearfrac(ircurve.Settle, ircurve.Dates);
    %fwd_dates = add2date(date_t,dt);
    %fwd_rates = ircurve.getForwardRates(fwd_dates);
    %P0_t_T = ircurve.getDiscountFactors(date_T)./ircurve.getDiscountFactors(date_t);
    %P0_t_T_plus_Delta = ircurve.getDiscountFactors(datenum(date_T+Delta))./ircurve.getDiscountFactors(datenum(date_t));
    %------------------------------------------------

    
    %auxiliary variables
    aux = eta*eta/lambda/lambda;
    sigma2_func = @(t)aux*(t + (exp(-lambda*t).*(2.0 - 0.5*exp(-lambda*t))-1.5)/lambda);
    B_t_T = (1.0-exp(-lambda*tau_t_T))/lambda;
    %CURRENTLY psi_t = instantaneous forward rate since tau_0_t = 0
    psi_t = instF + .5*aux*(1-exp(-lambda*tau_0_t)).^2;

    %variance of integrated short rate
    sigma2_R = feval(sigma2_func,tau_t_T);
    
    %mean of integrated short rate
    mu_R = B_t_T.*(instR - psi_t) + diag(log(P0_t./P0_T)) + 0.5*(feval(sigma2_func,tau_0_T) - feval(sigma2_func,tau_0_t));
    
    y = exp(1i*u*mu_R -0.5*u.*u*sigma2_R);
end