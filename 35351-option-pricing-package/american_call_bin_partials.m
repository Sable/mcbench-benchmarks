

function hedge=american_call_bin_partials(S, K, r, sigma, time, no_steps)


%--------------------------------------------------------------------------
%
% DESCRIPTION:
%
% Hedge parameters for an American call option using a binomial tree
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
% S:        spot price
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
% hedge.delta: partial with respect to S
% hedge.gamma: second artial with respect to S
% hedge.theta: partial with respect to time
% hedge.vega:  partial with respect to sigma
% hedge.rho:   partial with respect to r
%
%--------------------------------------------------------------------------
%
% Author:  Paolo Z., February 2012
%
%--------------------------------------------------------------------------


prices=zeros(no_steps+1);
call_values=zeros(no_steps+1);

delta_t =(time/no_steps);
R = exp(r*delta_t);
Rinv = 1.0/R;
u = exp(sigma*sqrt(delta_t));
d = 1.0/u;

uu= u*u;

pUp = (R-d)/(u-d);
pDown = 1.0 - pUp;

prices(1) = S*(d^no_steps);

for ( i=2:(no_steps+1) ) 
    prices(i) = uu*prices(i-1);
end


for ( i=1:(no_steps+1) ) 
    call_values(i) = max(0.0, (prices(i)-K));
end
    
 
for ( CurrStep=no_steps:-1:3 ) 
    for ( i=1:(CurrStep+1) )
        prices(i) = d*prices(i+1);
        call_values(i) = (pDown*call_values(i)+pUp*call_values(i+1))*Rinv;
        call_values(i) = max(call_values(i), prices(i)-K); 
    end
end


f22 = call_values(2);
f21 = call_values(1);
f20 = call_values(1);


for ( i=1:2 ) 
    prices(i) = d*prices(i+1);
    call_values(i) = (pDown*call_values(i)+pUp*call_values(i+1))*Rinv;
    call_values(i) = max(call_values(i), prices(i)-K); 
end


f11 = call_values(1);
f10 = call_values(1);

prices(1) = d*prices(1);

call_values(1) = (pDown*call_values(1)+pUp*call_values(1))*Rinv;
call_values(1) = max(call_values(1), S-K); 

f00 = call_values(1);

hedge.delta = (f11-f10)/(S*u-S*d);

h = 0.5 * S * ( uu - d*d);

hedge.gamma = ( (f22-f21)/(S*(uu-1)) - (f21-f20)/(S*(1-d*d)) ) / h;
hedge.theta = (f21--f00) / (2*delta_t);

diff = 0.02;

tmp_sigma = sigma+diff;
tmp_prices = american_call_bin(S, K ,r, tmp_sigma, time, no_steps);

hedge.vega = (tmp_prices-f00)/diff;

diff = 0.05;

tmp_r = r+diff;
tmp_prices = american_call_bin(S, K, tmp_r, sigma, time, no_steps);

hedge.rho = (tmp_prices-f00)/diff;

