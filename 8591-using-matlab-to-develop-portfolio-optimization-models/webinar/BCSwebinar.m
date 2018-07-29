%
%	Using MATLAB to Develop Portfolio Optimization Models
%	Robert Taylor
%	29 September 2005
%
%	The MathWorks, Inc.
%	3 Apple Hill Drive
%	Natick, MA, 01760
%
%	www.mathworks.com
%

%
%	Examine asset return data and other inputs for analysis
%

load BlueChipStocks

%
%	Estimate optimized portfolios over time for BlueChipStocks versus DJIA
%

BCSestimate

%
%	Examine time-evolution of efficient frontiers
%

BCSfrontier

%
%	Examine turnover of portfolio sequences along efficient frontiers
%

BCSturnover

%
%	Examine portfolio holding of portfolio sequences along efficient frontiers
%

BCSportfolio

%
%	Examine backtest results in terms of risk and return
%

BCSbacktest

%
%	Examine maximum drawdown for a portfolio sequence along efficient frontiers
%

BCSdrawdown

%
%	Examine backtest results in terms of capital growth
%

BCSbacktest2
