function X=CMAcombination(x,u,U)
% =========================
%  Combination step of Copula-Marginal Algorithm (CMA) 
%  Meucci A., "New Breed of Copulas for Risk and Portfolio  Management", Risk, September 2011
%
%  Most recent version of article and code available at http://www.symmys.com/node/335
%  =========================

[J,K]=size(x);
X=0*U;
for k=1:K
    X(:,k) = interp1(u(:,k),x(:,k),U(:,k),'linear','extrap');
end
