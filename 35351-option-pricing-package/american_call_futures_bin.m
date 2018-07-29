

function call_price=american_call_futures_bin(F, K, r, sigma, time, no_steps)


%--------------------------------------------------------------------------
%
% DESCRIPTION:
%
% Pricing an american call option on futures using a binomial approximation
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
% F:        price futures contract
% K:        exercise price
% r:        interest rate
% sigma:    volatility
% time:     time to maturity
% no_steps: number of steps in binomial tree
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


futures_prices = zeros(no_steps+1,1);
call_values    = zeros(no_steps+1,1);

t_delta= time/no_steps;
Rinv = exp(-r*(t_delta));
u = exp(sigma*sqrt(t_delta));
d = 1.0/u;
uu= u*u;
pUp = (1-d)/(u-d); 
pDown = 1.0 - pUp;
futures_prices(1) = F*(d^no_steps);


for ( i=2:(no_steps+1) ) 
    futures_prices(i) = uu*futures_prices(i-1); 
end    
    

for ( i=1:(no_steps+1) ) 
    call_values(i) = max(0.0, (futures_prices(i)-K));
end
    

for ( step=no_steps:-1:1 ) 
    for ( i=1:1:(step) ) 
        futures_prices(i) = d*futures_prices(i+1);
        call_values(i)    = (pDown*call_values(i)+pUp*call_values(i+1))*Rinv;
        call_values(i)    = max(call_values(i), futures_prices(i)-K); 
    end
end

call_price = call_values(1);

