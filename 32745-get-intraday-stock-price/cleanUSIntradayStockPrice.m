function data=cleanUSIntradayStockPrice(data)
%% function cleanUSIntradayStockPricess "cleans the data"
%
% function cleanUSIntradayStockPricess DEMONSTRATES one
% method for cleaning the output from
% function getHistoricalIntradayStockPrice
%
%Example:
% foo(1) = getHistoricalIntraDayStockPrice('A','','60','2d');
% foo(2) = getHistoricalIntraDayStockPrice('ZMH','','60','2d');
% foo(3) = cleanUSIntradayStockPrice(foo(1));
% foo(4) = cleanUSIntradayStockPrice(foo(2));
% for i=1:numel(foo)
%   if i==1, display('before:'); end;
%   if i==3, display('after:'); end;
%   display(sprintf('%s, array size: %d',foo(i).ticker,numel(foo(i).close)));
% end
% 
%$Revision: 1.0 $ $Date: 2011/08/30 01:00$ $Author: Pangyu Teng $

%check the inputs
if nargin<1
    display('requires 1 input parameter! clearUSIntradayData.m');
    return;
end

%set when the market opens and closes
marketOpen=[8 30 0];
marketClose=[15 0 0];

%% create time array base on range of downloaded dates
%create date (and time) of fist data point
minDate=datevec(min(data.date));
minDate(4)=marketOpen(1);
minDate(5)=marketOpen(2);
minDate(6)=marketOpen(3);

%create date of last data point
maxDate=datevec(max(data.date));
maxDate(4)=marketClose(1);
maxDate(5)=marketClose(2);
maxDate(6)=marketClose(3);

%% create new data array.

%create equally spaced date array
dateArr = datenum(datestr(datenum(minDate):datenum(0,0,0,0,0,str2double(data.interval)):datenum(maxDate)));

%convert date array to date vector
dateVecArr = datevec(dateArr);

%get rid of non-business-day dates
[dayOfWeek,dayOfWeekStr] = weekday(dateArr);
dateArr(dayOfWeek==1) = NaN;
dateArr(dayOfWeek==7) = NaN;

%get rid of dates when market is closed
dateArr(dateVecArr(:,4) < marketOpen(1)) = NaN;
dateArr(dateVecArr(:,4)== marketOpen(1) & dateVecArr(:,5) < marketOpen(2)) = NaN;
dateArr(dateVecArr(:,4)== marketClose(1) & dateVecArr(:,5) > marketClose(2)) = NaN;
dateArr(dateVecArr(:,4)> marketClose(1)) = NaN;

%update date array
dateArr = dateArr(~isnan(dateArr));

%get index of intersecting dates
[common, iDA, iD]=intersect(dateArr,data.date);

%% update stuff in data.

fieldName = {'close' 'high' 'low' 'open' 'volume', 'date','dateStr'};
for i = 1:numel(fieldName)
    %upde the field value if field is open, high, low or close
    if isempty(strmatch(fieldName{i}, strvcat('date','dateStr'), 'exact')),
        %save old array
        tmp = getfield(data, fieldName{i});
        %initialize price arrays.
        blank = ones([numel(dateArr),1])*NaN;
        blank(iDA) = tmp(iD);    
        data = setfield(data,fieldName{i},blank);
        
    elseif ~isempty(strmatch(fieldName{i},'date'))    
        data = setfield(data,fieldName{i},dateArr);
        
    elseif ~isempty(strmatch(fieldName{i},'dateStr'))
        data = setfield(data,fieldName{i},cellstr(datestr(dateArr,'dd/mm/yyyy HH:MM:SS')));
        
    end
end
