function prob = survProbWeibull(t,b)
% survProbWeibull: Computes survival probability using Weibull model

prob = exp(-((t./b(2)).^b(1)));
