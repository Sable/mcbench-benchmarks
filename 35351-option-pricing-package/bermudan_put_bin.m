

function put_price=bermudan_put_bin(S, X, r, q, sigma, time, potential_exercise_times, steps)


%--------------------------------------------------------------------------
%
% DESCRIPTION:
%
% Binomial approximation to a Bermudan put option
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
%  S:                           spot price
%  X:                           exercise price
%  r:                           interest rate
%  q:                           dividend yield 
%  sigma:                       volatility
%  time:                        time to maturity
%  potential_exercise_times:    periods of potential option exercise
%  steps:                       number of steps in binomial tree
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



% S
% X
% r
% q
% sigma
% time
% potential_exercise_times
% steps


delta_t = time/steps;
R       = exp(r*delta_t);
Rinv    = 1.0/R;
u       = exp(sigma*sqrt(delta_t));
uu      = u*u;
d       = 1.0/u;
p_up    = (exp((r-q)*delta_t)-d)/(u-d);
p_down  = 1.0-p_up;

prices     = zeros(steps+1,1);
put_values = zeros(steps+1,1);


for ( i=1:max(size(potential_exercise_times)) )
    t = potential_exercise_times(i);
    if ( (t>0)&&(t<time) ) 
        potential_exercise_steps(i+1)=int8(t/delta_t);
    end
end

prices(1) = S*(d^steps); 

for ( i=2:(steps+1) ) 
    prices(i) = uu*prices(i-1);
end
    
for ( i=1:(steps+1) ) 
    put_values(i) = max(0.0, (X-prices(i))); 
end
    
for ( step=steps:-1:1 ) 
    check_exercise_this_step='false';
    for ( j=1:max(size(potential_exercise_steps)) )
        if (step==potential_exercise_steps(j)) 
            check_exercise_this_step='true '; 
        end
    end
    for ( i=1:(step) ) 
        put_values(i) = (p_up*put_values(i+1)+p_down*put_values(i))*Rinv;
        prices(i) = d*prices(i+1);
        check_exercise_this_step;
        if (check_exercise_this_step=='true ') 
            put_values(i) = max(put_values(i),X-prices(i));
        end
    end
end

put_price = put_values(1);

