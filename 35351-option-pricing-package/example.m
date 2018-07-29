clear all
close all
clc


%--------------------------------------------------------------------------
% Barone-Adesi and Whaley (1987) quadratic approximation to the price 
% of a call option.
S=100; 
X=100; 
r=0.08; 
b=-0.04; 
sigma=0.20;
time=0.25;
accuracy=1.0e-6;

call_price=american_call_baw(S, X, r, b, sigma, time, accuracy)
%--------------------------------------------------------------------------

clear all

%--------------------------------------------------------------------------
% Price of American call option using a binomial approximation
S=100;
K=100;
r=0.1;
sigma=0.25;
t=1;
steps=100;

call_price=american_call_bin(S, K, r, sigma, t, steps)
%--------------------------------------------------------------------------

clear all

%--------------------------------------------------------------------------
% Binomial American option price with continous payout from the 
% underlying commodity
S=100; 
K=100;
r=0.10; 
y=0.02;
sigma=0.25;
t=1;
steps=100;

call_price=american_call_bin_contpay(S, K, r, y, sigma, t, steps)
%--------------------------------------------------------------------------

clear all

%--------------------------------------------------------------------------
% Hedge parameters for an American call option using a binomial tree
S=100; 
K=100;
r=0.1; 
sigma=0.25;
time=1.0; 
no_steps=100;

hedge=american_call_bin_partials(S, K, r, sigma, time, no_steps)
%--------------------------------------------------------------------------

clear all

%--------------------------------------------------------------------------
% Binomial price of an American option with an underlying stock that 
% pays proportional dividends in discrete time
S=100; 
K=100;
r=0.10; 
sigma=0.25;
t=1;
steps=100;
dividend_times=[0.25; 0.75];
dividend_yields=[0.025; 0.025];

call_price=american_call_bin_propdiv(S, K, r, sigma, t, steps, dividend_times, dividend_yields)
%--------------------------------------------------------------------------

clear all

%--------------------------------------------------------------------------
% Approximation of American call due to Bjerksund and Stensland (1993)
S=50; 
K=40;
r=0.05; 
q=0.02;
sigma=0.05;
time=1;

call_price=american_call_bjerkesun_stensland(S, K, r, q, sigma, time)
%--------------------------------------------------------------------------

clear all

%--------------------------------------------------------------------------
% Pricing an american call option on futures using a binomial approximation
F=50; 
K=45;
r=0.08; 
sigma=0.2;
time=0.5;
no_steps=100;

call_price=american_call_futures_bin(F, K, r, sigma, time, no_steps)
%--------------------------------------------------------------------------

clear all

%--------------------------------------------------------------------------
% Pricing a futures currency option using a binomial approximation
S=50; 
K=52;
r=0.08; 
r_f=0.05;
sigma=0.2; 
t=0.5;
no_steps=100;

call_price=american_call_futures_currcy_bin(S, K, r, r_f, sigma, t, no_steps)
%--------------------------------------------------------------------------

clear all

%--------------------------------------------------------------------------
% Price for an American perpetual call option
S=50.0; 
K=40.0;
r=0.05; 
q=0.02;
sigma=0.05;

call_price=american_call_perpetual(S, K, r, q, sigma)
%--------------------------------------------------------------------------

clear all

%--------------------------------------------------------------------------
% Price of American put using a binomial approximation
S=100;
K=100;
r=0.1;
sigma=0.25;
t=1;
steps=100;

put_price=american_put_bin(S, K, r, sigma, t, steps)
%--------------------------------------------------------------------------

clear all

%--------------------------------------------------------------------------
% Johnson (1983) approximation to an american put price
S=1.1; 
X=1;
r=0.125;
sigma=0.5; 
time=1;

put_price=american_put_johnson(S, X, r, sigma, time)
%--------------------------------------------------------------------------

clear all

%--------------------------------------------------------------------------
% Analytical price of an Asian geometric average price call by Kemma and
% Vorst (1990)
S=100; 
K=100; 
r=0.06; 
q=0;
sigma=0.25; 
time=1.0;

call_price=asian_geom_avg_call(S, K, r, q, sigma, time)
%--------------------------------------------------------------------------

clear all

%--------------------------------------------------------------------------
% European put option using Black-Scholes' formula
S=50; 
K=50; 
r=0.10;
sigma=0.30; 
time=0.50;

call_price=bs_european_call(S, K, r, sigma, time)
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% European put option using Black-Scholes' formula
% ...same parameters as before

put_price=bs_european_put(S, K, r, sigma, time)
%--------------------------------------------------------------------------

clear all

%--------------------------------------------------------------------------
% Partials of a European call option priced using Black-Scholes formula
S=50; 
K=50; 
r=0.10;
sigma=0.30; 
time=0.50;

hedge=bs_call_partials(S, K, r, sigma, time)
%--------------------------------------------------------------------------

clear all

%--------------------------------------------------------------------------
% Call option price for binomial european
S=100; 
K=100;
r=0.1; 
sigma=0.25;
t=1.0; 
steps=100;

call_price=european_call_bin(S, K, r, sigma, t, steps)
%--------------------------------------------------------------------------

clear all

%--------------------------------------------------------------------------
% Option price with continous payout from underlying asset
S = 100.0; 
K = 100.0;
r = 0.1; 
sigma = 0.25;
time=1.0;
dividend_yield=0.05;

call_price=european_call_contpay(S, K, r, dividend_yield, sigma, time)
%--------------------------------------------------------------------------

clear all

%--------------------------------------------------------------------------
% European option price with an underlying stock paying a discrete-time 
% dividend  
S=100.0; 
K=100.0;
r=0.1; 
sigma=0.25;
time=1.0;
dividend_times=[0.25; 0.75];
dividend_amounts=[2.5; 2.5];

call_price=european_call_div(S, K, r, sigma, time, dividend_times, dividend_amounts)
%--------------------------------------------------------------------------

clear all

%--------------------------------------------------------------------------
% Price of European call option on futures contract
F=50.0; 
K=45.0;
r=0.08; 
sigma=0.2;
time=0.5;

call_price=european_call_futures(F, K, r, sigma, time)
%--------------------------------------------------------------------------

clear all

%--------------------------------------------------------------------------
% European futures call option on currency
S = 50.0; 
X = 52.0;
r = 0.08; 
rf=0.05;
sigma = 0.2; 
time=0.5;

call_price=european_call_futures_currcy(S, X, r, rf, sigma, time)
%--------------------------------------------------------------------------

clear all

%--------------------------------------------------------------------------
% Price of a European lookback call option by Goldman, Sosin and Gatto
% (1979)
S=100; 
Smin=S; 
q=0;
r=0.06;
sigma=0.346; 
time=1.0;

call_price=european_call_loopback(S, Smin, r, q, sigma, time)
%--------------------------------------------------------------------------

clear all

%--------------------------------------------------------------------------
% Merton's jump diffusion formula for a European call option
S=100; 
K=100; 
r=0.05;
sigma=0.3; 
time_to_maturity=1;
lambda=0.5; 
kappa=0.5; 
delta=0.5;
maxn=50;

call_price=european_call_merton(S, K, r, sigma, time_to_maturity, lambda, kappa, delta, maxn)
%--------------------------------------------------------------------------

clear all

%--------------------------------------------------------------------------
% Binomial approximation to a Bermudan put option
S=80; 
X=100; 
r=0.20;
time=1; 
sigma=0.25;
steps=500;
q=0;
potential_exercise_times=[0.25; 0.5; 0.75];

put_price=bermudan_put_bin(S, X, r, q, sigma, time, potential_exercise_times, steps)
%--------------------------------------------------------------------------

clear all

%--------------------------------------------------------------------------
% Roll (1977) - Geske (1979) - Whaley (1981) price of american call option 
% on a stock that pays one fixed-dividend
S = 100; 
K = 100;
r = 0.1; 
sigma = 0.25;
tau = 1; 
D1 = 10;
tau1 = 0.5;

call_price=american_call_onediv(S, K, r, sigma, tau, D1, tau1)
%--------------------------------------------------------------------------
