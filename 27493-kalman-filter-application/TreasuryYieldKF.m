function [para, sumll] = TreasuryYieldKF()
% author: biao from www.mathfinance.cn
%http://www.mathfinance.cn/kalman-filter-finance-revisited

%%CIR parameter estimation using Kalman Filter for given treasury bonds yields
% check paper ""estimating and testing exponential-affine term structure
% models by kalman filter " and "affine term structure models: theory and
% implementation" for detail
% S(t+1) = mu + F S(t) + noise(Q)
% Y(t) = A + H S(t) + noise(R)

Y = xlsread('ir.xls');
[nrow, ncol] = size(Y);
tau = [1/4 1/2 1 5]; % stand for 3M, 6M, 1Y, 5Y yield

para0 = [0.05, 0.1, 0.1, -0.1, 0.01*rand(1,ncol).*ones(1,ncol)];
[x, fval] = fmincon(@loglik, para0,[],[],[],[],[0.0001,0.0001,0.0001, -1, 0.00001*ones(1,ncol)],[ones(1,length(para0))],[],[],Y, tau, nrow, ncol);
para = x;
sumll = fval;
end




