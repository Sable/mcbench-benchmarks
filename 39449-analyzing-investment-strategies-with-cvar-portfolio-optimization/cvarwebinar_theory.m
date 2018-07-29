%% Analyzing Investment Strategies with CVaR Portfolio Optimization in MATLAB - Theory
%
% Robert Taylor
% The MathWorks, Inc.

% Copyright (C) 2012 The MathWorks, Inc.

%% Covered-Call Strategy

% Generate the standard payoff diagram for covered-calls. To anchor the results, the diagram
% includes initial and expected stock prices to illustrate profitability of the covered-call
% position versus an uncovered position. Vary the parameter mu, which is the stock price drift
% parameter, to locate different payoffs. Try, for example, mu = 0.1 and mu = 0.35.

X0 = 40;					% initial price of stock
r0 = 0.02;					% risk free rate (annualized)
mu = 0.10;					% stock price drift (annualized)
sigma = 0.24;				% stock price volatility (annualized)

K = 42;						% strike price of call option
TC = 64/252;				% call option expiration (years)

EX = X0*exp(mu*TC);
C0 = blsprice(X0, K, r0, TC, sigma);

X = linspace(35, 45, 11)';

W0 = 100;
WU = zeros(11,1);
WC = zeros(11,1);

for i = 1:11
	WU(i) = X(i);
	if X(i) >= K
		WC(i) = C0 + K;
	else
		WC(i) = C0 + X(i);
	end
end

Wmax = (W0/X0)*max([WU; WC; X0]);
Wmin = (W0/X0)*min([WU; WC; X0]);

clf;
plot(X, (W0/X0)*[WU, WC]);
hold on
plot(X, (W0/X0)*X0*ones(11,1), ':r');
plot(X0*ones(2,1), [Wmax; Wmin], ':r');
plot(EX*ones(2,1), [Wmax; Wmin], ':r');
title(['\bf' sprintf('Payoff Diagram for Covered-Call Strategy (Drift %g)', mu)]);
xlabel('Stock Price at Option Expiration');
ylabel('Wealth');
text(X0, Wmin - 1, 'x_0', 'Fontsize', 8);
text(EX, Wmin - 1, 'E[X]', 'Fontsize', 8);
text(X(2), W0 - 1, 'W_0', 'FontSize', 8);
legend('Uncovered','Covered','Location','NorthWest');
hold off

%% Distribution of Covered-Call Payoffs without Re-Investment

% Generate the distribution of payoffs for covered-calls and compare with the distribution for an
% uncovered position.

X0 = 40;					% initial price of stock
r0 = 0.01;					% risk free rate (annualized)
mu = 0.1;					% stock price drift (annualized)
sigma = 0.24;				% stock price volatility (annualized)

startdate = datenum('28-Sep-2012');		% start date for investment period
enddate = datenum('21-Dec-2012');		% enddate for investment period
numdays = daysdif(startdate, enddate, 13);		% number of trading days for investment period
t0 = 0;						% set initial time to be 0 years
T = numdays/252;			% time horizon is 1 month with T in years

K = 42;						% strike price of call option

expdate = datenum('21-Dec-2012');		% expiration date of call option
TC = daysdif(startdate, expdate, 13)/252;

C0 = blsprice(X0, K, r0, TC, sigma);

numtrials = 10000;			% number of trials
numsamples = 252*T*13;		% number of days to time T with 13 half-hour periods per day
dt = T/numsamples;			% time increment in years

% generate geometric Brownian motion process for underlying stock price

Xsde = gbm(mu, sigma, 'starttime', t0, 'startstate', X0);
[X, t] = Xsde.simulate(numsamples, 'ntrials', numtrials, 'deltatime', dt);

% set up uncovered position

WU = X(end, :)';

% set up covered position without re-investment

WC = zeros(numtrials, 1);

for i = 1:numtrials
	H = 1;
	assigned = false;
	for j = 1:numel(t)
		if j == 1
			WC(i) = H*(X0 + C0);
		else
			WC(i) = WC(i) + H*(X(j,i) - X(j-1,i));
		end
		if ~assigned && X(j,i) >= K
			WC(i) = WC(i) + H*(K - X(j,i));
			H = 0;
			assigned = true;
		end
	end
end

WU = (100/X0)*WU;
WC = (100/X0)*WC;

Wmin = min([min(WU), min(WC)]);
Wmax = max([max(WU), max(WC)]);
Nmax = max([max(hist(WU,20)), max(hist(WC,20))]);

clf;
subplot(2,1,1);
hist(WU, 20);
axis([Wmin,Wmax,0,1.1*Nmax]);
title('\bfDistributions of Uncovered and Covered Wealth');
xlabel('Uncovered Strategy');

subplot(2,1,2);
hist(WC, 20);
axis([Wmin,Wmax,0,1.1*Nmax]);
xlabel('Covered Strategy');

%% Maximum allowable slippage for initiating position

% Illustrate maximum allowable slippage for an initiating covered-call position such that any
% slippage above this value renders the uncovered position preferable to the covered position. An
% initiating position assumes that the position is uncovered at the start of the investment period
% and that a covered-call position is established at this time so that the call premium contributes
% to total return during the period.

% The result is a plot that displays maximum allowable slippage as a function of strike price and
% exercise probability. The red line on the plot is the maximum allowable slippage if the option
% is exercised immediately when the stock price crosses above the strike price at any time during
% the investment period.

X0 = 40;						% initial stock price
T = 23/252;						% duration of investment period (years)
r0 = 0.02;						% risk free rate (annualized)
m = 0.1;						% stock price drift (annualized)
s = 0.24;						% stock price volatility (annualized)
TC = 64/252;					% expiration date of call option

Knum = 21;
pnum = 20;

K = linspace(40, 45, Knum);		% strike prices
p = linspace(0.05, 1, pnum);	% exercise probabilities

d = NaN(Knum, pnum);			% maximum slippage as function of strike and probabilities

for i = 1:Knum
	XT = X0*exp(m*T);
	for j = 1:pnum
		C = blsprice(X0, K(i), r0, TC, s);
		xi = C*(1 + r0*T)/XT;
		if p(j) > xi
			d(i,j) = (xi/p(j))/(1 - xi/p(j));
		end
	end
end

P = zeros(Knum, 1);				% hitting time exercise probabilities
dP = NaN(Knum, 1);				% maximum slippage for hitting time exercise probabilities

for i = 1:Knum
	XT = X0*exp(m*T);
	P(i) = gbm_upcrossing_prob(X0, K(i), T, m, s);
	C = blsprice(X0, K(i), r0, TC, s);
	xi = C*(1 + r0*T)/XT;
	if P(i) > xi
		dP(i) = (xi/P(i))/(1 - xi/P(i));
	end
end

d = 10000*d;
dP = 10000*dP;

dmin = min(min(min(d)),min(dP));
dmin = min(0, dmin);
dmax = max(max(max(d)),max(dP));
dmax = min(2000, dmax);

clf;
surf(p, K, d, 'FaceColor', 'b', 'EdgeColor', 'b', 'FaceAlpha', 0.3);
hold on
plot3(P, K, dP, 'r', 'LineWidth', 3);
axis([min(p), max(p), min(K), max(K), dmin, dmax]);
view(60, 30);
title('\bfMaximum Allowable Slippage for Initiating Position');
xlabel('Exercise Probability');
ylabel('Strike Price');
zlabel('Maximum Slippage (Basis Points)');
hold off

%% Maximum allowable slippage for ongoing position

% Illustrate maximum allowable slippage for an ongoing covered-call position such that any
% slippage above this value renders the uncovered position preferable to the covered position. An
% ongoing position assumes that the position is covered at the start of the investment period so
% that the call premium for the position does not contribute to total return during the period.

% The result is a plot that displays maximum allowable slippage as a function of strike price and
% exercise probability. The red line on the plot is the maximum allowable slippage if the option
% is exercised immediately when the stock price crosses above the strike price at any time during
% the investment period.

X0 = 40;						% initial stock price
T = 23/252;						% duration of investment period (years)
r0 = 0.02;						% risk free rate (annualized)
m = 0.1;						% stock price drift (annualize)
s = 0.24;						% stock price diffusion (annualized)
TC = 64/252;					% expiration date of call option

K = linspace(40, 45, 21);		% strike prices
p = linspace(0.05, 1, 20);		% exercise probabilities

d = NaN(Knum, pnum);			% slippage as function of strike and probabilities

for i = 1:Knum
	XT = X0*exp(m*T);
	for j = 1:pnum
		C = blsprice(X0, K(i), r0, TC, s);
		xi = C*r0*T/XT;
		if p(j) > xi
			d(i,j) = (xi/p(j))/(1 - xi/p(j));
		end
	end
end

P = zeros(Knum, 1);				% hitting time exercise probabilities
dP = NaN(Knum, 1);				% maximum slippage for hitting time exercise probabilities

for i = 1:Knum
	XT = X0*exp(m*T);
	P(i) = gbm_upcrossing_prob(X0, K(i), T, m, s);
	C = blsprice(X0, K(i), r0, TC, s);
	xi = C*r0*T/XT;
	if P(i) > xi
		dP(i) = (xi/P(i))/(1 - xi/P(i));
	end
end

d = 10000*d;
dP = 10000*dP;

dmin = min(min(min(d)),min(dP));
dmin = min(0, dmin);
dmax = max(max(max(d)),max(dP));
dmax = min(20, dmax);

clf;
surf(p, K, d, 'FaceColor', 'b', 'EdgeColor', 'b', 'FaceAlpha', 0.3);
hold on
plot3(P, K, dP, 'r', 'LineWidth', 3);
axis([min(p), max(p), min(K), max(K), dmin, dmax]);
view(60, 30);
title('\bfMaximum Allowable Slippage for Ongoing Position');
xlabel('Exercise Probability');
ylabel('Strike Price');
zlabel('Maximum Slippage (Basis Points)');
hold off
