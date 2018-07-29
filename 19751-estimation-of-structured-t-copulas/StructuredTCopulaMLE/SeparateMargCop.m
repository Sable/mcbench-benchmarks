function [W,F,U]=SeparateMargCop(X)
% this function separates the empirical copula from the marginal distribution 
% in the joint realizations X. The methodology is detailed in 
% A. Meucci (2006) "Beyond Black-Litterman in Practice", Risk Magazine, 19, 9, 114-119
% available at www.symmys.com > Research > Working Papers

[J,K]=size(X);
F=0*X;

[W,C]=sort(X);
for k=1:K
    x=C(:,k);
    y=[1:J];
    xi=[1:J];
    yi = interp1(x,y,xi);
    U(:,k)=yi/(J+1);
    F(:,k)=[1:J]'/(J+1);
end