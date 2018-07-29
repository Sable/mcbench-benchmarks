function [MDD, MDDs, MDDe, MDDr] = MAXDRAWDOWN(r)
% Maximum drawdown is defined as the largest drop from a peak to a bottom
% experienced in a certain time period.
%
% [MDD, MDDs, MDDe, MDDr] = MAXDRAWDOWN(r)
%
% INPUTS:
% r...      vector of log returns
%
% OUTPUTS:
% MDD...   Maximum drawdown expressed as a log return figure
% MDDs...  Start of maximum drawdown period expressed as an
%          index on vector aReturnVector
% MDDe...  End of maximum drawdown period expressed as an
%          index on vector aReturnVector
% MDDr...  End of recovery period expressed as an index on vector
%          aReturnVector
%
% Andreas Steiner, March 2006
% performanceanalysis@andreassteiner.net,
% http://www.andreassteiner.net/performanceanalysis

% size of r
n = max(size(r));

% calculate vector of cum returns
cr = cumsum(r);

% calculate drawdown vector
for i = 1:n
    dd(i) = max(cr(1:i))-cr(i);
end;

% calculate maximum drawdown statistics
MDD = max(dd);
MDDe = find(dd==MDD);
MDDs = find(abs(cr(MDDe)+ MDD - cr) < 0.000001);
MDDr = MDDe+min(find(cr(MDDe:end) >= cr(MDDs)))-1;