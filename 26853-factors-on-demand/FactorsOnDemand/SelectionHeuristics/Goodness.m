function g = Goodness(Who,M)

Cov_FF_k=M.Cov_FF(Who,Who);
Cov_XF_k=M.Cov_XF(:,Who);
minCov_U=Cov_XF_k*(Cov_FF_k\(Cov_XF_k')); % abriged version of variance of error
g=trace(minCov_U);                        % abridged version of r^2


