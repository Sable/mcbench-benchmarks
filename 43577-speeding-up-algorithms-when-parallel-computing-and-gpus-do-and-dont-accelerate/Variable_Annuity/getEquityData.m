function EP = getEquityData(Ticker, FromDate, ToDate, Period)
% GETEQUITYDATA loads stock price data for the GMWB demo.
%
% For the purposes of this demo, this data loading command has been
% replaced with a dummy call to a prepared MAT file.  (The main point of
% this demo is to show parallel computing, not data I/O.)

if size(Ticker,1) ~= 1 || size(Ticker,2) ~= 10 || ...
        ~all(strcmp(Ticker, {'MMM', 'AA', 'AXP', 'T', 'BAC', 'BA', 'CAT', 'CVX', 'CSCO', 'KO'}))
    warning('Edit getEquityData to use different ticker symbols.')
end
if ~strcmp(FromDate, '01/01/2000')
    warning('Edit getEquityData to use a different date range.')
end
if ~strcmp(ToDate, '01/01/2010')
    warning('Edit getEquityData to use a different date range.')
end
if ~strcmp(Period, 'm')
    warning('Edit getEquityData to use a different sample rate.')
end

d = load('stock.mat');
EP = d.EP.TimeSeries;

%-------------- Original Code Follows -----------------
% conn = yahoo;
% if isconnection(conn)
%     for i = 1:length(Ticker)
%     d = fetch(conn, Ticker(i), 'Close', FromDate, ToDate, Period);
%     sData(:, i) = d(:, 2);                                            %#ok
%     end
%     EP.TimeSeries = flipud(sData);
%     EP.Ticker = Ticker;
%     EP.FromDate = FromDate;
%     EP.ToDate = ToDate;
%     EP.Period = Period;
% else
%     d = load('stock.mat');
%     EP = d.EP;
% end