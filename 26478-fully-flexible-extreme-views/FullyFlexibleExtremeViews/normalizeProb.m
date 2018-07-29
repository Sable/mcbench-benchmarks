function [normalizedp] = normalizeProb(p)

tol = 1e-20;
tmp = p;
tmp(tmp < tol) = tol;
normalizedp = exp(log(tmp) - log(sum(tmp)));

end