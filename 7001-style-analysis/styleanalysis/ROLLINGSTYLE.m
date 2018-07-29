function [W, TE, R, R2, SDS] = ROLLINGSTYLE(F, S, N)
% Rolling style analysis
%
% INPUTS:
%   F... vector of fund returns
%   S... matrix of style factor returns
%   N... number of rolling periods
%
% OUTPUTS:
% W... vector of optimal style index weights
% TE... tracking error between calculated and actual fund
% Fcalc... vector of calculated fund time series
% R2... coefficient of determination between fund and calculated fund
% SDS... Style Drift Score
%
% Andreas Steiner
% performanceanalysis@andreassteiner.net,
% http://www.andreassteiner.net/performanceanalysis

W = []; TE = []; R = []; R2 = [];

for t = N:rows(F)
    
     [w, te, r, r2] = TEMINQP(F(t-(N-1):t), S(t-(N-1):t,:));
    
     W = [W; w];
     TE = [TE; te];
     R = [R; r(end)];
     R2 = [R2; r2];
    
end;

SDS = sqrt(sum(var(W)));

figure
bar(W, 'stacked')
title('Rolling Style Analysis: Style Weights Over Time')
axis tight