%% Intraday Pairs trading
% This demo shows how functionality within Econometric Toolbox can be used
% to identify and calibrate a simple, intraday pairs trading strategy.
%
% Copyright 2010-2011, The MathWorks, Inc.
% All rights reserved.

%% Load intraday data from a database
% We will download intraday data for Brent Crude (LCO) from our
% database.  We will also download data corresponding to West Texas
% Intermediate (WTI).

LCO = getMinuteDataFromDB('LCO');
WTI = getMinuteDataFromDB('WTI');

pairsChart(LCO, WTI)

% These two time series have historically tracked each other, but since
% December 2010, LCO has consistently traded higher than WTI.  It would
% seem that a pairs trading strategy would not work in 2011, but if we are
% willing to actively recalibrate our model on an intraday basis, we may
% find profitable opportunities.
%%
% Let's focus on the last 11 days' of data:
series = [LCO(end-4620+1 : end, 4) WTI(end-4620+1 : end, 4)];
plot(series)
legend('LCO','WTI')
%% The cointegration test framework
% Econometrics Toolbox supports both the Engle-Granger and the Johansen
% cointegration frameworks.  Engle-Granger is the older model, and Johansen
% is particularly useful for analyzing more than two time series at a time.
% We will use Engle-Granger for our trading model.

% First, we note that the last 11 days are not cointegrated as a whole
egcitest(series)
% (A zero indicates failure to reject the null hypothesis that no
% cointegrating relationship exists.)
%%
% Even so, there are smaller windows of time where a cointegrating
% relationship does exist.
[h, ~, ~, ~, reg1] = egcitest(series(1700:2000, :));
display(h)
%%
% The test estimates the coefficients of the cointegrating regression as
% well as the residuals and the standard errors of the residuals: all
% useful information for any pairs trading strategy.
display(reg1)

%% The pairs trading strategy
% The following function describes our pairs strategy.
edit pairs

%%
% We may test this strategy as we do our other rules:
pairs(series, 420, 60)
% Note that this strategy will not trade if the most recent minutes do not
% show signs of cointegration and that the size of the long/short positions
% are dynamically scaled with the volatility of the cointegrating
% relationship.  Many other customizations can be made.

%%
% We can use our existing parameter sweep framework to identify the best
% combination of calibration window and rebalancing frequency.
if matlabpool('size') == 0
    matlabpool local
end

window = 120:60:420;
freq   = 10:10:60;
range = {window, freq};

annualScaling = sqrt(250*7*60);
cost = 0.01;

pfun = @(x) pairsFun(x, series, annualScaling, cost);

tic
[~,param] = parameterSweep(pfun,range);
toc

pairs(series, param(1), param(2), 1, annualScaling, cost)
%%
% Despite the fact that these historically-tracking time series have
% diverged, we can still create a profitable pairs trading strategy by
% frequently recalibrating.