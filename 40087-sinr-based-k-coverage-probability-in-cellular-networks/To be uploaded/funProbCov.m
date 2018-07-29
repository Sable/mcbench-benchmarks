% funProbCov calculates and returns SINR-based coverage probability
% under arbtirary shadowing
% PCov=funProbCov(tValues,betaConst,x,numbMC,k)
% CovP is the 1-coverage probability
% tValues are the SINR threshold values. tValues can be a vector
% betaConst is the pathloss exponent.
% x is the input variable that incorporates the model parameters
% That is, x=W*a^(-2/betaConst)
% numbMc is number of sample (Sobol) points for  quasi-MC integration
% betaConst, x  and numbMC are scalars.
%
% Author: H.P. Keeler, Inria Paris/ENS, 2013
%
% References:
% [1] Keeler, B. Błaszczyszyn and M. Karray,
% 'SINR-based k-coverage probability in cellular networks with arbitrary
% shadowing', accepted at ISIT, 2013 


function PCov=funProbCov(tValues,betaConst,x,numbMC,k)
%General equation stems from Corollary 7 in [1]
if nargin==4
    k=1;
end

PCov=zeros(size(tValues));
%maxium number connections possible; see Lemma in [1]
nValues=max(1,ceil(1./tValues));
for j=1:length(tValues);
    nMax=nValues(j);
    
    for n=k:nMax
        Tn=tValues(j)./(1-tValues(j)*(n-1));     %eq. (17) in [1]
        In=funIn(betaConst,n,x); %eq. (12) in [1]
        Jn=funJn(Tn,betaConst,n,numbMC); %eq. (15) in [1]
        Sn=Tn.^(-2*n/betaConst).*In.*Jn; %eq. (18) in [1]
        PCov(j)=(-1)^(n-k)*nchoosek(n-1,k-1)*Sn+PCov(j); %eq. (8) in [1]
    end
end
