

function call_price=american_call_bin_propdiv(S, K, r, sigma, time, no_steps, dividend_times, dividend_yields)


%--------------------------------------------------------------------------
%
% DESCRIPTION:
%
% Binomial price of stock option with an underlying stock that 
% pays proportional dividends
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
%  S:                spot price
%  K:                exercice price
%  r:                interest rate
%  sigma:            volatility
%  time:             time_to_maturity
%  no_steps:         number of steps in binomial tree
%  dividend_times:   periods when dividend is paid out
%  dividend_yields:  dividend yields in each period
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


no_dividends=max(size(dividend_times));

if (no_dividends == 0) 
	call_price = american_call_bin(S,K,r,sigma,time,no_steps); 
    return
end

delta_t = time/no_steps;
R = exp(r*delta_t);
Rinv = 1.0/R;
u = exp(sigma*sqrt(delta_t));
uu= u*u;
d = 1.0/u;
pUp = (R-d)/(u-d);
pDown = 1.0 - pUp;

dividend_steps=zeros(no_dividends,1); 

for ( i=1:no_dividends ) 
    dividend_steps(i) = int8(dividend_times(i)/time*no_steps);
end

prices=zeros(no_steps+1,1);
call_prices=zeros(no_steps+1,1);

prices(1) = S*(d^no_steps); 

for ( i=1:no_dividends ) 
    prices(1) = prices(1)*(1.0-dividend_yields(i)); 
end
    
for ( i=2:(no_steps+1) ) 
    prices(i) = uu*prices(i-1); 
end
    
for ( i=1:(no_steps+1) ) 
    call_prices(i) = max(0.0, (prices(i)-K));
end    
    
for ( step=no_steps:-1:1 ) 
    for ( i=1:no_dividends )  
        if (step==dividend_steps(i)) 
            for ( j=1:(step+2) ) 
                prices(j)=prices(j)*(1.0/(1.0-dividend_yields(i)));
            end
        end
    end
    for ( i=1:(step) ) 
        call_prices(i) = (pDown*call_prices(i)+pUp*call_prices(i+1))*Rinv;
        prices(i) = d*prices(i+1);
        call_prices(i) = max(call_prices(i), prices(i)-K); 
    end
end


call_price = call_prices(1);
