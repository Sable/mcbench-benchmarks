
% funSimLogNormProbCovFade returns SINR-based k-coverage probability
% under Rayleigh (mean one) fading model and log-normal shadowing based on
% repeated simulations of of model outlined in [1]
%
% simPCovFade=funSimLogNormProbCovFade(tValues,betaConst,K,lambda,sigma,W,diskRadius,simNumb)
% simPCovFade is the 1-coverage probability
% tValues are the SINR threshold values. tValues can be a vector
% betaConst is the pathloss exponent
% K = path-loss constant
% lambda = density of base station/nodes of cellular network
% sigma = standard deviation of log-normal shadowing (not in dB)
% W = noise constant
% diskRadius = radius of simulation region (Warning: if too small, edge
% effects will not be sufficiently included and disagreement with analytic
% results may occurr)
% simNumb = number of simulations
% All input values (except tValues) are scalars
%
% Author: H.P. Keeler, Inria Paris/ENS, 2013
%
% References
% [1] H.P. Keeler, B. Błaszczyszyn and M. Karray,
% 'SINR-based k-coverage probability in cellular networks with arbitrary
% shadowing', accepted at ISIT, 2013 


function simPCovFade=funSimLogNormProbCovFade(tValues,betaConst,K,lambda,sigma,W,diskRadius,simNumb)


tNumb=length(tValues);

%%% Simulation Section %%%
%(uniformly) randomly places nodes on a disk of radius diskRadius
diskArea=pi*diskRadius^2;
coveredNumb=zeros(size(tValues));
ESTwoBeta=exp(sigma^2*(2-betaConst)/betaConst^2);
%rescale lambda - see foot note 5 in [1]
lambdaSim=lambda*ESTwoBeta;
for i=1:simNumb
    
    randNumb=poissrnd(lambdaSim*diskArea);
    %shadowing distribution can be constant if lambda is rescaled - see [1], [2] and [3]
    shadowRand=ones(randNumb,1);
    fadeRand=exprnd(1,randNumb,1); %Rayleigh fading corresponds to exponential random variables
    %random distances from the typical node
    rRand=diskRadius*sqrt(rand(randNumb,1)); %uniform in cartesion, not polar coordinates
    signalRand=(K*rRand).^(betaConst)./shadowRand;
    [Y1 indexY1]=min(signalRand);    %find Y_1 (first order statistics)
    
    interferTotal=sum(fadeRand./signalRand); %total inteference in network
    newExp=fadeRand(indexY1); %use corresponding exponential variable
    SINR=(newExp/Y1)./((interferTotal-(newExp/Y1))+W);
    for j=1:tNumb
        T=tValues(j);
        %counts how many nodes are connected/covered
        if sum(SINR>=T)>=1
            coveredNumb(j)=coveredNumb(j)+1;
        end
    end
end

simPCovFade=coveredNumb/simNumb;
