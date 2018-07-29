function vol = hist_vol(ticker, N)
% HIST_VOL          Calculate historical volatility
%   vol = hist_vol(ticker, N) is used to calculate the historical
%   volatility for the underlying asset specified in TICKER over N trading
%   days.  If N is not specified, a default of 20 trading days will be
%   used.
%
%   INPUTS
%       ticker --> A string or cell array of strings specifying the ticker
%                  symbols for the underlying assets to use.
%   
%       N --> An integer specifying the number of days to use in the
%             volatility calculationg
%
%   OUTPUT
%       The function will return the historical volatility for each of the
%       tickers passed to the function
%
%   NOTES
%       This program uses the function 'hist_stock_data.m', which downloads
%       historical stock data to use for the volatility calculations.
%       Therefore, you must also download this function from my File
%       Exchange and place it in the same directory as this function.
%
%       The historical volatility is calculated by using the closing prices
%       of each trading day.  Additionally, one year of historical stock
%       data will be downloaded, limiting N to a maximum of roughly 252 (as
%       there are about 252 trading days in a year).  If the user wishes to
%       allow larger N, changes must be made to the code when creating the
%       variable 'start_date'.

% Created by Josiah Renfree
% July 20, 2009

% Error checking
if nargin == 0          % If no inputs provided
    error('Please provide at least one ticker symbol')
elseif nargin > 2       % If too many inputs provided
    error('Function accepts no more than 2 inputs')
elseif ~ischar(ticker) && ~iscell(ticker)   % If ticker input is wrong type
    error('Ticker input must be either a string or cell array of strings')
elseif nargin == 1      % If N not supplied, use default
    N = 20;
elseif ~isnumeric(N) || length(N) > 1  % If N is supplied, but is wrong type
    error('N must be a single integer value')
end

% If only one ticker given, convert to cell array
if ~iscell(ticker)
    ticker = {ticker};
end

% Cycle through each ticker and calculate historical volatility
vol = zeros(length(ticker), 1);
for i = 1:length(ticker)
    % Clear for loop variables for next iteration
    clear curr_date start_date data closing log_change stdev
    
    % Create date strings to pass to hist_stock_data function
    curr_date = datestr(now, 'ddmmyyyy');       % get current date string
    start_date = datestr(now-365, 'ddmmyyyy');  % go back 1 year
    
    % First step is to download historical stock data for the ticker
    data = hist_stock_data(start_date, curr_date, ticker{i});
    closing = data.Close;   % Use only closing data
    
    % Calculate the percentage change over the past N trading days
    log_change = log(closing(2:N+1)./closing(1:N));
    
    % Get standard deviation of that change
    stdev = std(log_change);
    
    % Now normalize to annual volatility
    vol(i) = stdev*sqrt(252);
end