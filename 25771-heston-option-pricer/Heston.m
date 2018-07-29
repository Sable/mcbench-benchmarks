function [call_prices, std_errs] = Heston(S0, r, V0, eta, theta, kappa, strike, T, M, N)
%   Compute European call option price using the Heston model and a
%   conditional Monte-Carlo method
%
%       [call_prices, std_errs] = Heston(S0, r, V0, eta, theta, kappa,
%       strike, T, M, N)
%
%*************************************************************************
% ACKNOWLEDGMENTS:
% Thanks to Roger Lee for his MSFM course at the University of Chicago
%
%*************************************************************************
%   INPUTS:
%
%   S0   	 - Current price of the underlying asset.
%
%   r        - Annualized continuously compounded risk-free rate of return
%              over the life of the option, expressed as a positive decimal
%              number.
%
%        Heston Parameters:
%
%   V0     - Current variance of the underlying asset
%
%   eta    - volatility of volatility
%
%   theta  - long-term mean
%
%   kappa  - rate of mean-reversion
%
%
%   strike     - Vector of strike prices of the option
%
%   T          - Time to expiration of the option, expressed in years.
%    
%   N          - Number of time steps per path
%
%   M          - Number of paths (Monte-Carlo simulations)
%
%
%   OUTPUTS:
%
%   call_prices     - Prices (i.e., value) of a vector of European call options.
%
%   std_err         - Standard deviation of the error due to the Monte-Carlo 
%                     simulation:
%                     (std_err = std(sample)/sqrt(length(sample)))
%                  
%
%**************************************************************************
%
%   Example:
% 
%     S0 = 100;
%     r = 0.02;
%     V0 = 0.04;
%     eta = 0.7;
%     theta = 0.06;
%     kappa = 1.5;
%     strike = 85:5:115;
%     T = 0.25;
% 
%     M = 2000;  % Number of paths.
%     N = 250;   % Number of time steps per path
% 
%       [call_prices, std_errs] = Heston(S0, r, V0, eta, theta, kappa,
%       strike, T, M, N)
% 
% call_prices =
% 
%   15.9804   11.4069    7.2125    3.9295    2.1213    1.2922    0.8625
%    
%
% std_errs =
% 
%    0.0198    0.0263    0.0329    0.0367    0.0357    0.0315    0.0268
% 
%
%**************************************************************************
% Rodolphe Sitter - MSFM Student - The University of Chicago
% November 2009
%**************************************************************************


% Memory allocation for the variance paths
V = [V0*ones(M,1), zeros(M,N)];
Vneg = [V0*ones(M,1), zeros(M,N)]; % Antithetic variate for Monte-Carlo

% Normal random variables sample needed: M trajectories of N time steps
W = randn(M,N);

% Time step
dt = T/N;
 
% Simulation of N-step trajectories for the Variance of the underlying asset
for i = 1:N
    
    V(:,i+1) = V(:,i) + kappa*(theta-V(:,i))*dt+eta*sqrt(V(:,i)).*W(:,i)*sqrt(dt);
    % We don't want to variance to be negative
    V(:,i+1) = V(:,i+1).*(V(:,i+1)>0);
    
        % Antithetic variates
        Vneg(:,i+1) = Vneg(:,i)+kappa*(theta-Vneg(:,i))*dt - eta*sqrt(Vneg(:,i)).*W(:,i)*sqrt(dt);
        % We don't want to variance to be negative
        Vneg(:,i+1) = Vneg(:,i+1).*(Vneg(:,i+1)>0);
end

% The implied variance is equal to the time averaged realized variance
% We use numerical integration (trapezoidal rule) to compute it:
ImpVol = sqrt((1/2*V(:,1) + 1/2*V(:,end) + sum(V(:,2:end-1),2))*dt/T); 

% Antithetic variates
ImpVolneg = sqrt((1/2*Vneg(:,1) + 1/2*Vneg(:,end) + sum(Vneg(:,2:end-1),2))*dt/T);



% Computation of Heston call prices using Antithetic Variates and the 
% Black-Scholes formula with the time averaged realized variance

std_errs = nan(length(strike),1);  % Memory allocation
call_prices = nan(length(strike),1);

for j=1:length(strike)
    
    % Antithetic variates
    Sample = (BS(S0,0,strike(j),T,r,r,ImpVol) + BS(S0,0,strike(j),T,r,r,ImpVolneg))/2;
    
    % Standard deviation of the error
    std_errs(j) = std(Sample)/sqrt(M);
    
    call_prices(j) = mean(Sample);
    
end

% Plot the Heston volatility smile (use of blsimpv from the financial toolbox)
%**************************************************************************
% Comment this section of code if you don't want to output the plot *******

% Computation of the Black-Scholes implied volatilities (financial toolbox)
IV = blsimpv(S0, strike, r, T, call_prices', 3);

% Computation of forward log-moneyness from strikes for plot
F = S0*exp(r*T);
moneyness = log(F./strike);

figure;
set(gca,'Fontsize',12,'FontWeight','Bold','LineWidth',2);
plot(moneyness,IV,'-r+','linewidth',2)
grid on; axis tight;
xlabel('Log-Moneyness','interpreter','latex','FontSize',16);
ylabel('Implied Volatility$~\sigma_{imp}$','interpreter','latex',...
    'FontSize',16);
title('HESTON Model - Volatility Skew','interpreter','latex','FontSize',18)
fprintf('\n')
%**************************************************************************


% Black-Scholes Price function

function Call = BS(S0, t, strike, T, Rgrow, Rdisc, sigma)  

F = S0.*exp(Rgrow.*T);

d1 = log(F./strike)./(sigma.*sqrt(T-t))+sigma.*sqrt(T)/2;
d2 = log(F./strike)./(sigma.*sqrt(T-t))-sigma.*sqrt(T)/2;

Call = exp(-Rdisc.*T).*(F.*normcdf(d1) - strike.*normcdf(d2));