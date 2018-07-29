

function call_price=american_call_onediv(S, K, r, sigma, tau, D1, tau1)


%--------------------------------------------------------------------------
%
% DESCRIPTION:
%
% Roll (1977) - Geske (1979) - Whaley (1981) price of american call option 
% on a stock that pays one fixed-dividend
%
%
% Reference:
%
% John Hull, "Options, Futures and other Derivative Securities",
% Prentice-Hall, second edition, 1993.
% 
%--------------------------------------------------------------------------
%
% INPUTS:
%
%  S:           spot price
%  K:           exercice price
%  r:           domestic interest rate
%  sigma:       volatility
%  tau:         time to maturity
%  D1:          amount of dividend paid
%  tau1:        time to dividend payment
%
%--------------------------------------------------------------------------
%
% OUTPUT:
%
% call_price: price of a call option
%
%--------------------------------------------------------------------------
%
% Author:  Paolo Z., February 2012
%
%--------------------------------------------------------------------------



if (D1 <= K* (1.0-exp(-r*(tau-tau1)))) 
    
    call_price = bs_european_call(S-exp(-r*tau1)*D1,K,r,sigma,tau);

else 
    
    ACCURACY = 1e-6; 

    sigma_sqr = sigma*sigma;
    tau_sqrt = sqrt(tau);
    tau1_sqrt = sqrt(tau1);
    rho = sqrt(tau1/tau);
    S_bar = 0; 
    S_low=0;   
    S_high=S;  
    c = bs_european_call(S_high,K,r,sigma,tau-tau1);
    
    test = c-S_high-D1+K;

    while ( (test>0.0) && (S_high<=1e10) ) 
        S_high = S_high*2.0;
        c = bs_european_call(S_high,K,r,sigma,tau-tau1);
        test = c-S_high-D1+K;
    end

    if (S_high>1e10)
        call_price = bs_european_call(S-D1*exp(-r*tau1),K,r,sigma,tau);
        return
    end

    S_bar = 0.5 * S_high; 

    c = bs_european_call(S_bar,K,r,sigma,tau-tau1);

    test = c-S_bar-D1+K;


    while ( (abs(test)>ACCURACY) && ((S_high-S_low)>ACCURACY) ) 
        if (test<0.0) 
            S_high = S_bar; 
        else 
            S_low = S_bar; 
        end
    
        S_bar = 0.5 * (S_high + S_low);
        c = bs_european_call(S_bar,K,r,sigma,tau-tau1);
        test = c-S_bar-D1+K;
    end

    a1 = (log((S-D1*exp(-r*tau1))/K) +( r+0.5*sigma_sqr)*tau) / (sigma*tau_sqrt);
    a2 = a1 - sigma*tau_sqrt;
    b1 = (log((S-D1*exp(-r*tau1))/S_bar)+(r+0.5*sigma_sqr)*tau1)/(sigma*tau1_sqrt);
    b2 = b1 - sigma * tau1_sqrt;

    call_price = (S-D1*exp(-r*tau1)) * normcdf(b1) + (S-D1*exp(-r*tau1)) * normcdf(a1,-b1,rho) - (K*exp(-r*tau))*normcdf(a2,-b2,rho) - (K-D1)*exp(-r*tau1)*normcdf(b2);

end



