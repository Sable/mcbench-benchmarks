% CISCO stock ticker
stockTicker = 'NASDAQ:CSCO';

% Start Date 
startDate = 'Oct+1,2000';

% End Date 
endDate = 'Jun+15,2010';

% Retrieve the stock prices
ds = googleprices(stockTicker, startDate, endDate);
