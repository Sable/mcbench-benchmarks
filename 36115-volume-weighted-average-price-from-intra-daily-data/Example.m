% Volume Weighted Average Price from Intra-Daily Data - Semin Ibisevic (2012)
% http://www.mathworks.com/matlabcentral/fileexchange/authors/114076
%
%   This tutorial demonstrates the use of the GETVWAP function, that is how
%   to obtain the historical volume weighted average price from historical
%   intra-daily data. Additionally I included a function
%   GETHISTORICALINTRADAYSTOCKPRICE, written by Ted Teng (2011), to obtain
%   historical intra-daily stock data.
%
%   The user is allowed to specify the ticker symbol and the exchange on
%   which the security of interest is listed (Google Finance), the interval
%   of the intra-daily data (frequency) and the period (historical dates).
%
%  $Date: 04/10/2012$
%
% -------------------------------------------------------------------------
% References
%
%   "get Intraday Stock Price"
%   Ted Teng, August 2011
%
%   http://www.mathworks.com/matlabcentral/fileexchange/32745-get-intraday-
%   stock-price
% -------------------------------------------------------------------------


% Visit http://www.google.com/finance and determine the ticker of interest
% and the exchange. See also GETHISTORICALINTRADAYSTOCKPRICE for more
% information.
ticker = 'GOOG';      % Google
exchange = 'NASDAQ';  % Market where the stock is listed

% Specify the interval and period (optional). See the reference for more
% information.
interval = '60';         % 60 seconds
period = '10d';          % 10 days

% Retrieve Intra-Daily Stock price data (Author: Ted Teng, 2011)
data = getHistoricalIntraDayStockPrice(ticker,exchange,interval,period);

price = data.close;
volume = data.volume;
dates = data.date;

% Calculate the VWAP at the end of each day
vwap = getVWAP(price, volume, dates);




% -------------------------------------------------------------------------
% Plot

% get the unique dates at the end of the day
[~, closeDate] = getUniqueDayElements(dates, dates);

% get the unique closing price at the end of the day
[~, closePrice] = getUniqueDayElements(dates, data.close);


hold on
startDate = closeDate(1);
endDate = closeDate(size(closeDate,2));
xData = linspace(startDate,endDate,size(closeDate,2));
plot(xData, vwap,'k', 'Linewidth', 2);
plot(xData, closePrice, 'b', 'Linewidth', 2);
legend('VWAP', 'closing Price');
datetick('x',1,'keepticks')
title(['VWAP of ',ticker,':',exchange,' (Last ',period,')']);
clear xData startDate endDate