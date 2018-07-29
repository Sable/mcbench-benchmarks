function stocks = hist_stock_data(start_date, end_date, varargin)
% HIST_STOCK_DATA     Obtain historical stock data
%   hist_stock_data(X,Y,'Ticker1','Ticker2',...) retrieves historical stock
%   data for the ticker symbols Ticker1, Ticker2, etc... between the dates
%   specified by X and Y.  X and Y are strings in the format ddmmyyyy,
%   where X is the beginning date and Y is the ending date.  The program
%   returns the stock data in a structure giving the Date, Open, High, Low,
%   Close, Volume, and Adjusted Close price adjusted for dividends and
%   splits.
%
%   hist_stock_data(X,Y,'tickers.txt') retrieves historical stock data
%   using the ticker symbols found in the user-defined text file.  Ticker
%   symbols must be separated by line feeds.
%
%   EXAMPLES
%       stocks = hist_stock_data('23012003','15042008','GOOG','C');
%           Returns the structure array 'stocks' that holds historical
%           stock data for Google and CitiBank for dates from January
%           23, 2003 to April 15, 2008.
%
%       stocks = hist_stock_data('12101997','18092001','tickers.txt');
%           Returns the structure arrary 'stocks' which holds historical
%           stock data for the ticker symbols listed in the text file
%           'tickers.txt' for dates from October 12, 1997 to September 18,
%           2001.  The text file must be a column of ticker symbols
%           separated by new lines.
%
%       stocks = hist_stock_data('12101997','18092001','C','frequency','w')
%           Returns historical stock data for Citibank using the date range
%           specified with a frequency of weeks.  Possible values for
%           frequency are d (daily), w (weekly), or m (monthly).  If not
%           specified, the default frequency is daily.
%
%   DATA STRUCTURE
%       INPUT           DATA STRUCTURE      FORMAT
%       X (start date)  ddmmyyyy            String
%       Y (end date)    ddmmyyyy            String
%       Ticker          NA                  String 
%       ticker.txt      NA                  Text file
%
%   OUTPUT FORMAT
%       All data is output in the structure 'stocks'.  Each structure
%       element will contain the ticker name, then vectors consisting of
%       the organized data sorted by date, followed by the Open, High, Low,
%       Close, Volume, then Adjusted Close prices.
%
%   DATA FEED
%       The historical stock data is obtained using Yahoo! Finance website.
%       By using Yahoo! Finance, you agree not to redistribute the
%       information found therein.  Therefore, this program is for personal
%       use only, and any information that you obtain may not be
%       redistributed.
%
%   NOTE
%       This program uses the Matlab command urlread in a very basic form.
%       If the program gives you an error and does not retrieve the stock
%       information, it is most likely because there is a problem with the
%       urlread command.  You may have to tweak the code to let the program
%       connect to the internet and retrieve the data.

% Created by Josiah Renfree
% January 25, 2008

stocks = struct([]);        % initialize data structure

% split up beginning date into day, month, and year.  The month is
% subracted is subtracted by 1 since that is the format that Yahoo! uses
bd = start_date(1:2);       % beginning day
bm = sprintf('%02d',str2double(start_date(3:4))-1); % beginning month
by = start_date(5:8);       % beginning year

% split up ending date into day, month, and year.  The month is subracted
% by 1 since that is the format that Yahoo! uses
ed = end_date(1:2);         % ending day
em = sprintf('%02d',str2double(end_date(3:4))-1);   % ending month
ey = end_date(5:8);         % ending year

% determine if user specified frequency
temp = find(strcmp(varargin,'frequency') == 1); % search for frequency
if isempty(temp)                            % if not given
    freq = 'd';                             % default is daily
else                                        % if user supplies frequency
    freq = varargin{temp+1};                % assign to user input
    varargin(temp:temp+1) = [];             % remove from varargin
end
clear temp

% Determine if user supplied ticker symbols or a text file
if isempty(strfind(varargin{1},'.txt'))     % If individual tickers
    tickers = varargin;                     % obtain ticker symbols
else                                        % If text file supplied
    tickers = textread(varargin{1},'%s');   % obtain ticker symbols
end

h = waitbar(0, 'Please Wait...');           % create waitbar
idx = 1;                                    % idx for current stock data

% cycle through each ticker symbol and retrieve historical data
for i = 1:length(tickers)
    
    % update waitbar to display current ticker
    waitbar((i-1)/length(tickers),h,sprintf('%s %s %s%0.2f%s', ...
        'Retrieving stock data for',tickers{i},'(',(i-1)*100/length(tickers),'%)'))
        
    % download historical data using the Yahoo! Finance website
    [temp, status] = urlread(strcat('http://ichart.finance.yahoo.com/table.csv?s='...
        ,tickers{i},'&a=',bm,'&b=',bd,'&c=',by,'&d=',em,'&e=',ed,'&f=',...
        ey,'&g=',freq,'&ignore=.csv'));
    
    if status
        % organize data by using the comma delimiter
        [date, op, high, low, cl, volume, adj_close] = ...
            strread(temp(43:end),'%s%s%s%s%s%s%s','delimiter',',');

        stocks(idx).Ticker = tickers{i};        % obtain ticker symbol
        stocks(idx).Date = date;                % save date data
        stocks(idx).Open = str2double(op);      % save opening price data
        stocks(idx).High = str2double(high);    % save high price data
        stocks(idx).Low = str2double(low);      % save low price data
        stocks(idx).Close = str2double(cl);     % save closing price data
        stocks(idx).Volume = str2double(volume);      % save volume data
        stocks(idx).AdjClose = str2double(adj_close); % save adjustied close data
        
        idx = idx + 1;                          % increment stock index
    end
    
    % clear variables made in for loop for next iteration
    clear date op high low cl volume adj_close temp status
    
    % update waitbar
    waitbar(i/length(tickers),h)
end
close(h)    % close waitbar