function [p] = integrateSubIntervals(x, cdf)

[xLB, xUB] = subIntervals(x);

cdfUB = cdf(xUB);
cdfLB = cdf(xLB);

p = (cdfUB - cdfLB) ./ (xUB - xLB);
    
end
