function [W, TE, Fcalc, R2] = TEMINQP(F,S)
% Tracking Error Minimization with QUADPROG
%
% INPUTS:
% F... vector of fund return times series
% S... matrix of style returntime series
%
% OUTPUTS:
% W... vector of optimal style index weights
% TE... tracking error between calculated and actual fund
% Fcalc... vector of calculated fund time series
% R2... coefficient of determination between fund and calculated fund
%
% BACKGROUND:
%
% min var[F(t)-sum[w(i,t)*S(i,t)]] s.t. sum[w(i)]=1, w(i,t) >=0
%   = var[F(t)-sum[w(i,t)*S(t)]] = Var[F] + w'*V*w-2*b'*C = w'*V*w-2*b'*C s.t. w'*e=1, w>=0
%
% w... style weights
% V... variance-covariance matrix of style index matrix
% C... vector of covariances between the style indices and the fund
% e... one vector
%
% Andreas Steiner
% performanceanalysis@andreassteiner.net,
% http://www.andreassteiner.net/performanceanalysis

s = cols(S); % number of style indices
V = cov(S);
for i = 1:s C(i,1) = COVAR(S(:,i),F); end; % build up vector of covariances between the style indices and the fund
Aeq = ones(1,s); % one vector for calculation of 100% invested constraint
beq= 1; % scalar one % one vector for calculation of 100% invested constraint
lb=zeros(1,s); % zero vector defining lower bound for style weights

[X,FVAL,EXITFLAG,OUTPUT,LAMBDA] = quadprog(V,-C,[],[],Aeq,beq,lb,[],[],OPTIMSET(OPTIMSET,'Display','off','LargeScale','off'));

W = abs(X)';
Fcalc = S*W';
TE = std(Fcalc-F);
R2 = CORREL(Fcalc,F)^2;