

function call_price=american_call_baw(S, X, r, b, sigma, time, accuracy)


%--------------------------------------------------------------------------
%
% DESCRIPTION:
%
% Barone-Adesi and Whaley (1987) quadratic approximation to the price 
% of a call option.
%
%
% Reference:
%
% Giovanni Barone-Adesi and Robert E. Whaley, 
% "Efficient analytic approximation of American option values", 
% Journal of Finance, 42(2):301-320, June 1987.
%
% 
%--------------------------------------------------------------------------
%
% INPUTS:
%
%   S:          spot price
%   X:          exercise price
%   r:          interest rate
%   b:          dividend yield
%   sigma:      volatility 
%   time:       time to maturity
%   accuracy:   approximation accuracy
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



sigma_sqr = sigma*sigma;
time_sqrt = sqrt(time);

nn = 2.0*b/sigma_sqr;

m = 2.0*r/sigma_sqr;
K = 1.0-exp(-r*time);

q2 = ( -(nn-1) + sqrt( (nn-1)^2 + (4*m/K) ) )*0.5;
q2_inf = 0.5 * ( -(nn-1) + sqrt( (nn-1)^2 + 4.0*m ) ); 

S_star_inf = X / (1.0 - 1.0/q2_inf);
h2 = -(b*time+2.0*sigma*time_sqrt)*(X/(S_star_inf-X));

S_seed = X + (S_star_inf-X)*(1.0-exp(h2));

no_iterations=0; 

Si     = S_seed;
g      = 1;
gprime = 1;


while ((abs(g) > accuracy) && (abs(gprime)>accuracy) && ( no_iterations<500) && (Si>0.0)) 
    c = european_call_contpay(Si,X,r,b,sigma,time);
    
    d1     = (log(Si/X)+(b+0.5*sigma_sqr)*time)/(sigma*time_sqrt);
    g      =(1.0-1.0/q2)*Si-X-c+(1.0/q2)*Si*exp((b-r)*time)*normcdf(d1);
    
    gprime =( 1.0-1.0/q2)*(1.0-exp((b-r)*time)*normcdf(d1))+(1.0/q2)*exp((b-r)*time)*normcdf(d1)*(1.0/(sigma*time_sqrt));
    Si     = Si-(g/gprime);
end


S_star = 0;


if (abs(g)>accuracy) 
    S_star = S_seed; %// did not converge
else 
    S_star = Si; 
end


C=0;
c = european_call_contpay(S,X,r,b,sigma,time);


if (S>=S_star) 
    C  = S-X;
else 
    d1 = (log(S_star/X)+(b+0.5*sigma_sqr)*time)/(sigma*time_sqrt);
    A2 = (1.0-exp((b-r)*time)*normcdf(d1))* (S_star/q2);
    C  = c+A2*((S/S_star)^q2);
end


call_price = max(C,c); 


