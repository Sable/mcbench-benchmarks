function data = getHistoricalIntraDayStockPrice(ticker,exchange,interval,period)

% COPYRIGHT INFORMATION
%   This function is written by Ted Teng, published on August 30, 2011
%   http://www.mathworks.com/matlabcentral/fileexchange/32745-get-intraday-stock-price
%
%   I use it as an exmaple to coincide with the GETVWAP function


%% getHistoricalIntraDayStockPrice pulls intraday stock price from Google.
%
% data = getHistoricalIntraDayStockPrice(ticker,exchange) pulls intraday
% stock price from Google given the symbol of stock, and the name of
% market which the stock is listed under.  This is base on a document [1]
% by Juan1R.
% 
% DISCLAIMER:
% Use output data with extreme care!
% Output data may have missing values,
% so be sure to inspect and clean the data before usage.
%
% Input: 
%       ticker - symbol of stock
%       exchange - market which the stock is listed under, this may be 
%                  blank ('') when the stock is in the US major markets
%       interval - (optional) frequency of the data in seconds, for example:
%                       '60' - for 60 seconds (default).
%                      '120' - for 120 seconds.
%       period - (optional) range of the data, for example:
%                        '1d' - for 1 day (default)
%                        '15d' - for 15 days 
%       see the references for more info on the inputs.
%
% Output:
%       data.dateStr
%       data.date
%       data.open
%       data.high
%       data.low
%       data.close
%       data.volume - A structure containing the date, date in string
%                     format and the corresponding open, close, high
%                     and low price of the specified stock.
%                     There are other values in the structure, please
%                     see below code and comments for more info.
%
% Example:
%       %get some stock price
%       huga = getHistoricalIntraDayStockPrice('GOOG','NASDAQ');
%       chaka = getHistoricalIntraDayStockPrice('.DJI','INDEXDJX');
%       %plot some 'normalized' stock price. :)
%       plot(huga.close/norm(huga.close),'b-'); hold on;
%       plot(chaka.close/norm(chaka.close),'r-');
%       title('what is this?');
%       legend(huga.ticker,chaka.ticker);
%
% Reference:
% [1] http://www.codeproject.com/KB/IP/google_finance_downloader.aspx
% [2] http://www.marketcalls.in/database/google-realtime-intraday-backfill-data.html
%
%$Revision: 1.0 $ $Date: 2011/08/29 22:00$ $Author: Pangyu Teng $

%check the inputs
if nargin < 2 || nargin ==3 || nargin > 4,
    display('getHistoricalIntraDayStockPrice.m requires 2 or 4 input parameters');
    return;
end

%initialize elements of the url for getting the intraday data.
data.ticker = upper(ticker);
data.exchange = upper(exchange);
if nargin < 3,
    data.interval = '60';
    data.period = '1d';
else
    display('using user specified interval and period');
    data.interval = interval;
    data.period = period;
end
data.field = 'd,c,h,l,o,v';

%build, get, and save url in a csv file.
f = urlwrite(['http://www.google.com/finance/getprices?q=',data.ticker,'&x=',...
    data.exchange,'&i=',data.interval,'&p=',data.period,'&f=',data.field],'tempStockPrice.csv');

%import csv file
importDataStruct = importdata(f);
data.close = importDataStruct.data(:,1);
data.high = importDataStruct.data(:,2);
data.low = importDataStruct.data(:,3);
data.open = importDataStruct.data(:,4);
data.volume = importDataStruct.data(:,5);

%get raw date
rawDate=importDataStruct.textdata(8:end);

%get time offset (seconds) according to UTC
  %see below link for more info,
  %http://en.wikipedia.org/wiki/Time_zone
timeZoneOffset = cell2mat(importDataStruct.textdata(7));
equalSignInd = strfind(timeZoneOffset,'=');
data.timeZoneOffsetNum = str2double(timeZoneOffset(equalSignInd+1:end));

%convert raw dates to date strings.
data.dateStr = cell([numel(rawDate),1]);
for i = 1:numel(rawDate),
    temp = cell2mat(rawDate(i));
    if strcmp(temp(1),'a'),
        dateAbsolute = str2double(temp(2:end));
        data.dateStr(i) = {epoch2date(dateAbsolute)};
    else
        data.dateStr(i) = {epoch2date(dateAbsolute + str2double(temp)*str2double(data.interval))};
    end
end

%convert date strings to datenums
data.date = datenum(data.dateStr,'dd/mm/yyyy HH:MM:SS');

%delete csv file
delete('tempStockPrice.csv');

% author: http://ketul.com/blog/?p=28
function [date_str] = epoch2date(epochTime)
% converts epoch time to human readable date string
% import java classes
import java.lang.System;
import java.text.SimpleDateFormat;
import java.util.Date;
% convert current system time if no input arguments
if (~exist('epochTime','var'))
    epochTime = System.currentTimeMillis/1000;
end
% convert epoch time (Date requires milliseconds)
jdate = Date(epochTime*1000);
% format text and convert to cell array
%sdf = SimpleDateFormat('dd/MM/yyyy HH:mm:ss.SS');
sdf = SimpleDateFormat('dd/MM/yyyy HH:mm:ss');
date_str = sdf.format(jdate);
date_str = char(cell(date_str));
