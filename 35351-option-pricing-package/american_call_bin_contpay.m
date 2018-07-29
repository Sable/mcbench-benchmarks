

function call_price=american_call_bin_contpay(S, K, r, y, sigma, t, steps)


%--------------------------------------------------------------------------
%
% DESCRIPTION:
%
% Binomial option price with continous payout from the underlying commodity
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
%  S:       spot price
%  K:       exercice price
%  r:       interest rate
%  y:       continous payout
%  sigma:   volatility
%  t:       time to maturity
%  steps:   number of steps in binomial tree
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


 
R = exp(r*(t/steps)); %// interest rate for each step
Rinv = 1.0/R; %// inverse of interest rate
u = exp(sigma*sqrt(t/steps)); %// up_movement
uu = u*u;
d = 1.0/u;
p_up = (exp((r-y)*(t/steps))-d)/(u-d);
p_down = 1.0-p_up;

prices = zeros(steps+1,1); %// price of underlying

prices(1) = S*(d^steps);

for ( i=2:(steps+1) )
    prices(i) = uu*prices(i-1); %// fill in the endnodes.
end

call_values = zeros(steps+1,1); %// value of corresponding call

for ( i=1:(steps+1) ) 
    call_values(i) = max(0.0, (prices(i)-K)); %// call payoffs at maturity
end 
    
for ( step=(steps-1):-1:1 ) 
    for ( i=1:1:(step+1) ) 
        call_values(i) = ( p_up*call_values(i+1)+p_down*call_values(i) )*Rinv;
        prices(i) = d*prices(i+1);
        call_values(i) = max(call_values(i),prices(i)-K); %// check for exercise
    end
end

call_price = call_values(1);





