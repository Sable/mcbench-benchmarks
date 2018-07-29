function vwap = getVWAP(price, volume, dates)
%GETVWAP: calculate the Volume Weighted Average Price at the end of each
%day, given intra daily data of the closing price and volume.
%
%   VWAP = GETVWAP(price, volume, dates) returns the Volume Weighted
%   Average Price (VWAP) at the end of the day. The input consists of the
%   intra-daily price, volume and dates (in formatted form).
%
%   vwap:           is a vector of the VWAP prices at the end of each
%                   unique day, conditional on the dates.
%
%  $Date: 04/10/2012$
%
% -------------------------------------------------------------------------

% Not all securities publish their volume shares, i.e. sometimes the volume
% vector is empty.
if sum(volume) == 0, error('getVWAP:InvalidInput','No historical intra-daily data of volume'); end
if size(price,2) > 1 || size(volume,2) > 1 || size(dates,2) > 1, error('getVWAP:InvalidInput','Price, volume and dates should be a row vector'); end


% FIND THE UNIQUE DAYS. TWO OPTIONS ARE POSSIBLE:
% -- 1 --   make use of the included GETUNIQUEDAYELEMENTS code (general 
%           framework, adaptable for multi purposes, external)

uniqueDays = getUniqueDayElements(dates);
k = size(unique(day(dates)),1);
vwap = zeros(1, k );

% -- 2 --   get rid of the [EXTERNAL] GETUNIQUEDAYELEMENTS code and use the
%           following [INTERNAL] method:

    % k = size(unique(day(dates)),1);
    % vwap = zeros(1, k );
    % uniqueDays = zeros(1, k ); iter = 1; uniqueDays(iter) = day(dates(1));
    % 
    % % find the unique days
    % for i = 2:size(dates,1);
    %     if uniqueDays(iter) ~= day(dates(i));
    %         iter = iter + 1;
    %         uniqueDays(iter) = day(dates(i));
    %     end
    % end

% calculate vwap
for i = 1:size(uniqueDays,2)
    dayi = day(dates)==uniqueDays(i);
    vwap(i) = sum( volume(dayi) ...
        .*price( dayi ) ) / sum( volume( dayi ) );
end

