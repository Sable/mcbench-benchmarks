

function call_price=american_call_futures_currcy_bin(S, K, r, r_f, sigma, time, no_steps)


%--------------------------------------------------------------------------
%
% DESCRIPTION:
%
% Pricing a futures currency option using a binomial approximation
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
%  r_f:         foreign interest rate
%  sigma:       volatility
%  time:        time to maturity
%  no_steps:    number of steps in binomial tree
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


exchange_rates=zeros(no_steps+1,1);

call_values=zeros(no_steps+1,1);

t_delta= time/no_steps;
Rinv = exp(-r*(t_delta));
u = exp(sigma*sqrt(t_delta));
d = 1.0/u;
uu= u*u;
pUp = (exp((r-r_f)*t_delta)-d)/(u-d); 
pDown = 1.0 - pUp;
exchange_rates(1) = S*(d^no_steps);


for ( i=2:(no_steps+1) ) 
    exchange_rates(i) = uu*exchange_rates(i-1); 
end


for ( i=1:(no_steps+1) ) 
    call_values(i) = max(0.0, (exchange_rates(i)-K));
end
    

for ( step=no_steps:-1:1 ) 
    for ( i=1:1:(step) ) 
        exchange_rates(i) = d*exchange_rates(i+1);
        call_values(i) = (pDown*call_values(i)+pUp*call_values(i+1))*Rinv;
        call_values(i) = max(call_values(i), exchange_rates(i)-K); 
    end
end


call_price = call_values(1);

