function [annualRet,annualCov,annualStd] = ComputeHistoricalStats(prices)

returns = tick2ret(prices,[],'continuous');
numReturns = size(returns,1);

[annualRet,annualCov] = geom2arith(mean(returns),cov(returns),numReturns);

annualRet = annualRet';
annualStd = sqrt(diag(annualCov));
