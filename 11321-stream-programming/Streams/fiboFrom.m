function s = fiboFrom(a1,a2)
% FIBOFROM  Stream of fibonacci numbers
s = {a1,delayEval(@fiboFrom,{a2,a1+a2})};
