function em = emstd(X,N)
% exponential moving standard deviation
% we use the following formula:
%   std = sqrt(E[ (X - E[X])^2 ])
% where E = exponential moving average.

em = sqrt( ema( (X - ema(X,N)).^2, N) );