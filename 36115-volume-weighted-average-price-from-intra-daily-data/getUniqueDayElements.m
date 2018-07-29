function [uniqueDays, dayElements] = getUniqueDayElements(dates, input)
%GETUNIQUEDAYELEMENS: get the unique DAILY ELEMENTS (such as closing
%prices, volume, etc at the end of each day [input]) given a vector of
%INTRA-DAILY data.
%
%   [UNIQUEDAYS, DAYELEMENTS] = GETUNIQUEELEMENTS('dates', ...) returns the 
%   unique elements of the input at the end of each day, given intra-daily
%   data. The following input parameter is needed:
%   'dates'     :   vector of the intra-daily dates
%
%   [UNIQUEDAYS, DAYELEMENTS] = GETUNIQUEELEMENTS(dates, 'input' allows you
%   to include an additional input vector for which the unique elements at
%   the end of each day are extracted, such as closing price. The unique
%   elements should be synchronized with 'dates'.
%   'input'     :   the relevant vector for which the unique elements at
%                   the end of each day need to be extracted from the
%                   intra-daily data. 
%
%  $Date: 04/10/2012$
%
% -------------------------------------------------------------------------

% initialization and error check
k = size(unique(day(dates)),1);
uniqueDays = zeros(1, k); iter = 1; uniqueDays(iter) = day(dates(1));

if nargin < 2 
    dayElements = 'No input specified, only uniquedates generated';
else
    dayElements = zeros(1,k);
end


% find the unique days and unique input
for i = 2:size(dates,1);
    if uniqueDays(iter) ~= day(dates(i));
        iter = iter + 1;
        uniqueDays(iter) = day(dates(i));
        if nargin == 2, dayElements(iter-1) = input(i-1); end
    end
end
if nargin == 2, dayElements(iter) = input(size(dates,1)); end % final input