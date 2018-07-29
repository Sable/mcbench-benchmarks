function [mxScoresRealWorld,mxDiv,mxExpX,mxResid,Stats] = calcRealWorldFactorScores(mxLoadings,mxAssets,vecIdio,T)
%Written Martyn Dorey 20 Aug 2004
%Takes output from the factor analysis function factoran and translates it into realworld obervations:
%Lets say you've got a matrix or returns in mxAssets,
%1)Produce some factor analysis using the MATLAB function:
%
%[mxLoadings,vecIdio,T,stats,mxFactorScores] = factoran(mxAssets);
%
%2)Now split the returns into two parts, that which is explained and the residual.
%
%[mxScoresRealWorld,mxDiv,mxExpX,mxResid,Stats] = calcFactorScores(mxLoadings,mxAssets,vecIdio,T)
% 
%
%mxScoresRealWorld 
% unrotated factor scores
%
% mxDiv
% A divisor required by other functions for converting simulated factor
% scores into real world observations
% see example calcConvertSimulatedFactorsIntoObs function below
%
%mxExpX 
%   - Expected x values from the factor analysis
%
%mxResid 
%   - The residuals which can be used for further analysis
%
%Stats
%   - a structure containing some basic stats on 
%       Stats.TotalVar
%           Percentage of the total variance explained by the model
%       Stats.AssetExplained
%           This is the percentage of each assets variance explained by the model
%    
%Inputs
%mxLoadings - the loadings matrix that comes out of factoran
%mxAssets   - an num_Obs x num_Assets matrix of asset returns used in
%             factoran
%vecIdio    - The idiosyncratic vector that comes out of factoran
%T          - The rotation matrix that comes out of factoran


%Note this code only works for output WLS or bartlett not Regression.
%mxLoadings is the output straight out of factoran
%mxAssets is a nObs * nAssets matrix of asset returns
%vecIdio is the PSi vector from factoran, the idiosyncractic elements of
%risk
%X = Xstdised/mxDiv+mxMean;
%See also [mxExpX] = calcConvertSimulatedFactorsIntoObs(mxLoadings,mxMean,vecIdio,T,mxDiv,mxSimScores)
%
%
%
mxMean = repmat(mean(mxAssets),length(mxAssets),1);
mxXMinusMean = mxAssets-mxMean;
[Q,R] = qr(mxXMinusMean/sqrt(length(mxXMinusMean)-1),0);
mxDiv = diag(1./sqrt(sum(R.^2,1)));
mxXstdised = mxXMinusMean*mxDiv;
invsqrtvecIdio = diag(1 ./ sqrt(vecIdio));
mxLoadings_ = mxLoadings*inv(T);
%This next bit is equal to mxScores_ = mxFactorScores*T' 
%where mxFactor scores is the output from factoran with rotation;
mxScoresRealWorld = (mxXstdised*invsqrtvecIdio) / (mxLoadings_'*invsqrtvecIdio);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%This bit would need a small adjustment to work with Regression type only works for WLS or Bartlett
%output factor scores.
mxExpX = ((mxScoresRealWorld*(mxLoadings_'*invsqrtvecIdio))/invsqrtvecIdio)/mxDiv+mxMean;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mxResid = mxAssets - mxExpX;
Stats.AssetExplained = var(mxExpX)./var(mxAssets);
[n m] = size(mxExpX);
vecExpX = reshape(mxExpX,n*m,1);
vecAsset = reshape(mxAssets,n*m,1);
Stats.TotalVar = var(vecExpX)./var(vecAsset);



function [mxExpX] = calcConvertSimulatedFactorsIntoObs(mxLoadings,vecMean,vecIdio,T,mxDiv,mxSimScores)
%Written Martyn Dorey 20 Aug 2004
%Example function that uses mxDiv and your own simulation of factor scores
%In order to simulate real world obs mxSimScores will need to apply the following to
%convert back to real world:
mxMean = repmat(vecMean',length(mxSimScores),1);
mxLoadings_ = mxLoadings*inv(T);
invsqrtvecIdio = diag(1 ./ sqrt(vecIdio));
mxLoadings_ = mxLoadings*inv(T);
mxExpX = ((mxSimScores*(mxLoadings_'*invsqrtvecIdio))/invsqrtvecIdio)/mxDiv+mxMean;

