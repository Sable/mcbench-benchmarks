%% Analyzing Investment Strategies with CVaR Portfolio Optimization in MATLAB - Normality Tests
%
% Robert Taylor
% The MathWorks, Inc.

% Copyright (C) 2012 The MathWorks, Inc.

%% Introduction

% This script displays the distributions of scenario returns for uncovered and covered positions. It
% also performs a Lilliefors test on the log of scenario returns to test for normality.

%% Load Scenarios

load BuyWriteScenarios

%% Display Distributions of Scenario Returns

% Given scenario returns for uncovered and two covered strategies with different strike cushions,
% plot the distributions of scenario returns.

n = size(XU, 2);

xmin = min([min(XU), min(XC1)]);
xmax = max([max(XU), max(XC1)]);
Nmax = max([max(hist(XU,20)), max(hist(XC1,20)), max(hist(XC2,20))]);

subplot(3,1,1);
hist(XU, 20);
axis([xmin,xmax,0,10000]);
title('\bfComparison of the Distributions of Scenario Returns');
xlabel('Uncovered Strategy Scenario Returns');
subplot(3,1,2);
hist(XC1, 20);
axis([xmin,xmax,0,10000]);
xlabel('Covered Strategy Scenario Returns with Strike 1');
subplot(3,1,3);
hist(XC2, 20);
axis([xmin,xmax,0,10000]);
xlabel('Covered Strategy Scenario Returns with Strike 2');

%% Lilliefors Test for Normality (of Log Scenario Returns)

% Use the Lilliefors test to assess normality of the log of scenario returns.

lillieU = zeros(n,1);
lillieC1 = zeros(n,1);
lillieC2 = zeros(n,1);

for i = 1:n
	lillieU(i) = lillietest(log(1 + XU(:,i)));
	lillieC1(i) = lillietest(log(1 + XC1(:,i)));
	lillieC2(i) = lillietest(log(1 + XC2(:,i)));
end

fprintf('Lilliefors test statistics H for scenarios across %d assets ...\n',n);
fprintf('  Null hypothesis is that scenarios are lognormal (reject at 5%% level if H = 1)\n');
fprintf('  Strategy   %5s  %5s\n','H = 0','H = 1');
fprintf('  ---------  -----  -----\n');
fprintf('  Uncovered  %5d  %5d\n',sum(lillieU < 1),sum(lillieU > 0));
fprintf('  Covered 1  %5d  %5d\n',sum(lillieC1 < 1),sum(lillieC1 > 0));
fprintf('  Covered 2  %5d  %5d\n',sum(lillieC2 < 1),sum(lillieC2 > 0));
