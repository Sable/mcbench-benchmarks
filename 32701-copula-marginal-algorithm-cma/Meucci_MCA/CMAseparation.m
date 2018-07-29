function [x,u,U]=CMAseparation(X,p)
% =========================
%  Separation step of Copula-Marginal Algorithm (CMA) 
%  Meucci A., "New Breed of Copulas for Risk and Portfolio  Management", Risk, September 2011
%
%  Most recent version of article and code available at http://www.symmys.com/node/335
%  =========================

% preprocess variables
[J,N]=size(X);
l=J/(J+1);
p=max(p,1/J*10^(-8));
p=p/sum(p);
u=0*X;
U=0*X;

% core algorithm
[x,Indx]=sort(X);
for n=1:N % for each marginal...
    I=Indx(:,n); % sort
    cum_p=cumsum(p(I)); % compute cdf
    u(:,n)=cum_p*l; % rescale to be <1 at the far right
    Rnk = round(interp1(I,1:J,1:J)); % compute ranking of each entry
    U(:,n)=cum_p(Rnk)*l; % compute grade
end