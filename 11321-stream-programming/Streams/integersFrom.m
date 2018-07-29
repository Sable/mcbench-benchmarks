function s = integersFrom(n)
% INTEGERSFROM  Returns a stream of integers
s = {n, delayEval(@integersFrom,{n+1})};
