
% funSimLogNormProbCov returns SINR-based k-coverage probability 
% under log-normal shadowing based on repeated simulations of
% of model outlined in [1]
%
% simPCovk=funSimLogNormProbCov(tValues,betaConst,K,lambda,sigma,W,diskRadius,simNumb,k)
% simPCovk is the k-coverage probability
% tValues are the SINR threshold values. tValues can be a vector
% betaConst is the pathloss exponent.
% K = path-loss constant
% lambda = density of base station/nodes of cellular network
% sigma = standard deviation of log-normal shadowing (not in dB)
% W = noise constant
% diskRadius = radius of simulation region (Warning: if too small, edge
% effects will not be sufficiently included and disagreement with analytic
% results may occurr)
% simNumb = number of simulations
% k = coverage number (often set to one)
% All input values (except tValues) are scalars
%
% Author: H.P. Keeler, Inria Paris/ENS, 2013
%
% References
% [1] H.P. Keeler, B. Błaszczyszyn and M. Karray,
% 'SINR-based k-coverage probability in cellular networks with arbitrary
% shadowing', accepted at ISIT, 2013 



function simPCovk=funSimLogNormProbCov(tValues,betaConst,K,lambda,sigma,W,diskRadius,simNumb,k)

if nargin==8
    k=1;
end

tNumb=length(tValues);

%%% Simulation Section %%%
%(uniformly) randomly places nodes on a disk of radius diskRadius
diskArea=pi*diskRadius^2;
coveredNumbk=zeros(size(tValues));
ESTwoBeta=exp(sigma^2*(2-betaConst)/betaConst^2);
%rescale lambda - see foot note 5 in [1]
lambdaSim=lambda*ESTwoBeta;
for i=1:simNumb
    randNumb=poissrnd(lambdaSim*diskArea);
    %shadowing distribution can be constant if lambda is rescaled - see [1]
    shadowRand=ones(randNumb,1); 
    %random distances from the typical node 
    rRand=diskRadius*sqrt(rand(randNumb,1)); %uniform in cartesion, not polar coordinates
    
    signalRand=shadowRand.*(K*rRand).^(-betaConst);
    interferTotal=sum(signalRand); %total inteference in network
    SINR=signalRand./((interferTotal-signalRand)+W); %calculate SINR for each node in the network
    
    for j=1:tNumb
        T=tValues(j);
        %counts how many nodes are exactly k or more connected/covered
        if sum(SINR>=T)>=k
            coveredNumbk(j)=coveredNumbk(j)+1;
        end
    end
    
end

simPCovk=coveredNumbk/simNumb;
