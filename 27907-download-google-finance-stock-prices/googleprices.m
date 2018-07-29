function ds = googleprices(stockTicker, startDate, endDate)
% PURPOSE: Download the historical prices for a given stock from Google
% Finance and converts it into a MATLAB dataset format.
%---------------------------------------------------
% USAGE: ds = googleprices(stockTicker, startDate, endDate)
% where: stockTicker = Google stock ticker (ExchangeSymbol:SecuritySymbol),
%                      ex. NASDAQ:CSCO for Cisco Stocks.
%        startDate: start date of the prices series. It could be either in
%                   serial matlab form or in Google Date form (mmm+dd,yyyy).
%        endDate: end date of the prices series. It could be either in
%                   serial matlab form or in Google Date form
%                   (mmm+dd,yyyy).
%---------------------------------------------------
% RETURNS: A dataset representing the retrieved prices.
%---------------------------------------------------
% REFERENCES:  a references for the google formats could be found here:
% http://computerprogramming.suite101.com/article.cfm/an_introduction_to_go
% ogle_finance
%---------------------------------------------------

% Version: 1.0
% Written by:
% Display Name: El Moufatich, Fayssal
% Windows: Microsoft Windows NT 5.2.3790 Service Pack 2
% Date: 15-Jun-2010 17:38:18

if isnumeric(startDate)
    startDate = datestr(startDate, 'mmm+dd,yyyy');
end

if ~exist('exportFormat', 'var')
    exportFormat = 'csv';
end

% Download the data
fileName = urlwrite(['http://finance.google.com/finance/historical?q=' stockTicker '&startdate=' startDate '&enddate=' endDate '&output=' exportFormat], ['test.' exportFormat]);

% Import the file as a dataset.
ds = dataset('file', fileName, 'delimiter', ',');

% Delete the temporary file
delete(fileName);

% Adjust the Date VarName
names = get(ds, 'VarNames');
names{:, 1} = 'Date';
ds = set(ds, 'VarNames', names);
end