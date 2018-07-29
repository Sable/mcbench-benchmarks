% funProbCovFade calculates and returns SINR-based coverage probability under Rayleigh
% fading model (given by equation (24) in [1]) and log-normal shadowing
% CovPFade=funProbCovFade(tValues,betaConst,x)
% CovPFade is the 1-coverage probability
% tValues are the SINR threshold values. tValues can be a vector
% betaConst is the pathloss exponent.
% x=the input variable that incorporates the model parameters 
% That is, x=W*a^(-2/betaConst)
% betaConst and x are scalars
%
% Author: H.P. Keeler, Inria Paris/ENS, 2013
%
% References:
% [1] Keeler, B. Błaszczyszyn and M. Karray, 
% 'SINR-based k-coverage probability in cellular networks with arbitrary
% shadowing', accepted at ISIT, 2013 

function CovPFade=funProbCovFade(tValues,betaConst,x)
% Calculates 1-coverage probability with Rayleigh (mean=1) fading
% Uses numerical integration (x>0) or analytic solution (if x=0 (ie W=0))

%initiate CovP values based on tValues vector
CovPFade=zeros(size(tValues));
if x==0
    %analytic solution - eq (25) in [1]
    CovPFade=1./(1+2/betaConst*(hypergeom([1,-2/betaConst+1],-2/betaConst+2,-tValues).*tValues/(-2/betaConst+1)));    
else   
    %numerical solution
    for k=1:length(tValues)
        T=tValues(k);
        %constant (in terms of integration variable s) hypergeometric 
        %function term equation (24) in [1]
        constF12=hypergeom([1,-2/betaConst+1],-2/betaConst+2,-T)/(-2/betaConst+1);        
        %create internal kernerl in equation (24) in [1]         
        intKern=@(s)(2/betaConst)*(exp(-(2/betaConst)*(T*s.^(2/betaConst).*constF12)).*exp(-s.*x*T).*exp(-s.^(2/betaConst)).*s.^(2/betaConst-1));
        CovPFade(k)=quadgk(intKern,0,Inf);
        
    end
    
end

