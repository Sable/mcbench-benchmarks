function [tickers,tickersInfo] = getStockSymbols(index)
%
% getStockSymbols obtains symbols in U.S. stock markets or symbols of U.S. 
% index components.  The function also outputs the company name, 
% sector type, market cap, p/e, last price, last price percent change
% and volume in the second output parameter in the form of structs.
% These data are pulled from http://finviz.com.  See below for usage.
%
% Usage:
% [tickers,tickersInfo] = getStockSymbols('exch_amex'); %get tickers in amex
% [tickers,tickersInfo] = getStockSymbols('exch_nasd'); %get tickers in nasdaq
% [tickers,tickersInfo] = getStockSymbols('exch_nyse'); %get tickers in nyse
% [tickers,tickersInfo] = getStockSymbols('idx_sp500'); %get tickers of S&P 500 components
% [tickers,tickersInfo] = getStockSymbols('idx_dji'); %get tickers of Dow Jones components
%
% $Revision: 1.0 $ $Date: 2011/08/14 13:00$ $Author: Pangyu Teng $

if nargin < 1,
	display('need at least 1 parameter (getTickers.m)');
end

%get tickers of index from finviz.com, save in temporary csv file
f = urlwrite(['http://finviz.com/export.ashx?v=111&f=',index],'getTickersTemp.csv');    

%import csv file
importDataStruct = importdata(f);
importNumbers = xlsread(f);

%extract ticker name and rest of ticker info from csv file
[szX,szY] = size(importDataStruct.textdata);
tickers = importDataStruct.textdata(2:end,2);

%save ticker info into struct
tickersInfo = struct('ticker',importDataStruct.textdata(2:end,2),...
    'company',importDataStruct.textdata(2:end,3),...
    'sector',importDataStruct.textdata(2:end,4),...
    'industry',importDataStruct.textdata(2:end,5),...    
    'country',importDataStruct.textdata(2:end,6),...
    'marketCap', num2cell(importNumbers(:,7)),...
    'pe', num2cell(importNumbers(:,8)),...
    'price', num2cell(importNumbers(:,9)),...
    'percentChange', num2cell(100*importNumbers(:,10)),...
    'volume', num2cell(importNumbers(:,11)));

%delete the temporary csv file
delete('getTickersTemp.csv');