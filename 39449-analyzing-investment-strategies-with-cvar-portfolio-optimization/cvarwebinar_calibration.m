%% Analyzing Investment Strategies with CVaR Portfolio Optimization in MATLAB - Calibration
%
% Robert Taylor
% The MathWorks, Inc.

% Copyright (C) 2012 The MathWorks, Inc.

%% Stock Total Return Price Data

% The script starts with data from the file |BuyWriteStockUniverse.mat| that contains a fints
% object, Universe, with asset symbols and 15 years of daily total return prices for 26 stocks.

load BuyWriteStockUniverse Universe

% Extract information from fints object Universe.

Assets = fieldnames(Universe, 1);			% stock symbols
X = fts2mat(Universe);						% stock total return prices
Y = log(X);									% log stock total return prices
numassets = numel(Assets);					% number of stocks in universe

ftsinfo(Universe);

%% Calibrate Geometric Brownian Motion

% Under an assumption that stock prices are geometric Brownian motion processes, the next step
% calibrates a continuous multivariate geometric Brownian motion process based on discrete samples
% of total return prices.

t0 = busdate(Universe.dates(1), -1);		% first business day prior to first date in data
T = Universe.dates(end);					% last date in data

% Determine average number of days in a year for the historical period. In this example, the period
% is known and fixed to be 15 years.

average_days_per_year = (T - t0)/15;

% Form "dates" for data relative to t0 in years based on average number of days in a year

t = linspace(0, (T - t0), 1 + size(X,1))'/average_days_per_year;	% "dates" from t0 for data

% Calibrate the model with maximum likelihood estimation.

tic

[x0, mu, gamma] = gbm_calibration(t(1), X, t(2:end));

toc_cal = toc;

fprintf('Time to calibrate gbm parameters %g\n',toc_cal);

% Form various ancillary statistics from the estimated diffusion matrix.

covar = gamma*gamma';
[sigma, rho] = cov2corr(covar);
sigma = sigma(:);

% List calibrated parameters.

fprintf('Calibrated multivariate geometric Brownian motion parameters ...\n');
fprintf('  %5s  %10s  %10s  %10s\n','Asset','Initial','Drift','Diffusion');
fprintf('  %5s  %10s  %10s  %10s\n','','Price','Parameter','Parameter');
for i = 1:numel(x0)
	fprintf('  %5s  %10.2f  %10.2f  %10.2f\n',Assets{i},x0(i),100*mu(i),100*sigma(i));
end

%% Check log total return prices with annualized approximate calibration

% Select 4 assets with indices between 1 and 26 and run this cell to see fits for the selected
% assets.

ii = [ 2, 4, 6, 8 ];

for i = 1:4
	Y1 = Y(:,ii(i));
	EY1 = log(x0(ii(i))) + (mu(ii(i)) - 0.5*sigma(ii(i))^2)*(t(2:end) - t(1));
	SY1 = sigma(ii(i))*sqrt(t(2:end) - t(1));

	subplot(2,2,i);
	plot(t(2:end), Y1, 'b', t(2:end), EY1, 'g', t(2:end), [EY1 - SY1, EY1 + SY1], ':r');
	title(['\bf' Assets{ii(i)}]);
	xlabel('Years');
end

%% Plot scatter diagram of estimated returns and risks

clf;
scatter(sigma, mu, 'Filled');
text(sigma + 0.005, mu, Assets, 'FontSize', 8);
title('\bfReturn versus Risk for Assets in Universe');
xlabel('Annualized Standard Deviation \sigma Derived from GBM Diffusion');
ylabel('Annualized Mean \mu Derived from GBM Drift');
