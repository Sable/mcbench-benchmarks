%% Analyzing Investment Strategies with CVaR Portfolio Optimization in MATLAB
%
% Robert Taylor
% The MathWorks, Inc.

% Copyright (C) 2012 The MathWorks, Inc.

%% Introduction

% This script is a "superscript" that organizes the scripts for the webinar "Analyzing Investment
% Strategies with CVaR Portfolio Optimization in MATLAB." It describes what each script does and
% shows the order in which the scripts should be examined.

%% Instructions

% The file structure for these scripts has a top-level folder that contains these scripts and should
% have two folders 'data' and 'source' with data and analytics. To add these folders to the path,
% start in the folder with the scripts and execute the commands

setlocalpaths

% The script cvarwebinar_scenarios.m, which simulates scenarios, must be run before subsequent
% scripts can be run because it generates a file BuyWriteScenarios.mat that is needed for these
% scripts. The script to generate scenarios can take about one hour on a typical computer and
% requires that the computer be a 64-bit machine. It creates a 12MB file in the ./data folder. Make
% sure that the script to generate scenarios is run in the folder that contains this script so that
% the scenarios file ends up in the correct data folder.

%% Theory

% This script illustrates basic features of covered-call strategies and provides a theoretical
% analysis of issues regarding slippage due to assignment and re-investment.

cvarwebinar_theory

%% From Theory to Reality

% This script illustrates an event-driven simulation of total returns for uncovered and covered
% positions based on a single realization of an underlying stock. It moves from the simplicity of
% theory to the messiness of reality as it models and simulates various contributions to slippage.

cvarwebinar_reality

%% Calibration

% This script is the first of the sequence of scripts to illustrate a complete workflow to analyze a
% covered-call strategy for a universe of 26 stocks. Given total return price data, this script
% illustrates maximum likelihood calibration of the assumed geometric Brownian motion process for
% the universe of stocks.

cvarwebinar_calibration

%% Scenario Generation

% This script is the second of the sequence of scripts that generates scenarios for uncovered and
% covered positions to be used for subsequent portfolio optimization and analysis. This is the
% slowest script since it generates scenarios by simulation of investment actions during the course
% of an investment period.

cvarwebinar_scenarios

%% Normality Tests

% This script is the third of the sequence of scripts that examines the statistical properties of
% the scenarios. As the probability of early exercise increases during an investment period, the
% distribution of the log of covered-call returns becomes increasingly non-normal.

cvarwebinar_normality

%% Optimization

% This script is the final of the sequence of scripts that performs several portfolio optimization
% steps with both CVaR and mean-variance portfolio optimization. The difference in results between
% the two types of optimization is examined to provide greater insights into the normative
% implications of covered-call strategies.

cvarwebinar_optimization

%% References
%
% # P. Bernstein (1998), _Against the Gods: The Remarkable Story of Risk_, Wiley.
% # F. Black (1975), "Fact and Fantasy in the Use of Options," _Financial Analysts Journal_, Vol. 31,
% No. 4, pp. 36-41 and 61-72.
% # P. Glassermann (1991), _Monte Carlo Methods in Financial Engineering_, Springer.
% # I. Karatzas and S. Shreve (1991), _Brownian Motion and Stochastic Calculus_, 2nd ed., Springer.
% # H. Markowitz (1952), "Portfolio Selection," _Journal of Finance_, Vol. 7, No. 1, pp. 77-91.
% # R. Merton, M. Scholes, and M. Gladstein (1978), "The Returns and Risk of Alternative Call Option 
% Portfolio Investment Strategies," _Journal of Business_, Vol. 51, No. 2, pp. 183-242.
% # R. T. Rockafellar and S. Uryasev (2002). "Conditional Value-at-Risk for General Loss
% Distributions," _Journal of Banking and Finance_, Vol. 26, pp. 1443-1471.
