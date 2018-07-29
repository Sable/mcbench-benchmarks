%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ----------------- Model GSM-SOCONT -------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This model simulates daily discharge from partly glacierized catchments.

% Citation:
%   Schaefli, B., Hingray, B., Niggli, M. and Musy, A., 2005. 
%       A conceptual glacio-hydrological model for high mountainous catchments.     
%       Hydrology and Earth System Sciences, 9: 95 - 109.                                                                                             
%
% The above paper describes the model in detail. I it is freely available
% at:
%       http://www.hydrol-earth-syst-sci.net/9/95/2005/hess-9-95-2005.pdf
%
% It is applied e.g. in the following papers:

%  Horton, P., Schaefli, B., Hingray, B., Mezghani, A. and Musy, A., 2006. 
%       Assessment of climate change impacts on Alpine discharge regimes 
%       with climate model uncertainty. Hydrological Processes, 20: 2091-2109.
%  Schaefli, B., Hingray, B. and Musy, A., 2007. Climate change and 
%       hydropower production in the Swiss Alps: quantification of potential 
%       impacts and related modelling uncertainties. Hydrology and Earth 
%       System Sciences, 11(3): 1191-1205.
% Schaefli, B., and Zehe, E.: Hydrological model performance and parameter 
%       estimation in the wavelet-domain, Hydrology and Earth System Sciences, 13, 
%       1921–1936, 10.5194/hess-13-1921-2009, 2009.
%
% Schaefli, B., and Huss, M.: Integrating point glacier mass balance 
%       observations into hydrologic model identification, Hydrology and 
%       Earth System Sciences, 15, 1227-1241, 10.5194/hess-15-1227-2011, 2011.
%
% Copyright and Disclaimer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Developed at EPFL, 2003-2005, version V2.4, Jan. 2011
% Copyright, 2013, EPFL, www.epfl.ch

% Neither the authors nor EPFL make any warranty, express or implied or
% assume any liability for the use of this Matlab code. Redistribution of 
% this source code, with or without modification is permitted provided
% that the copyright notice and the disclaimer are included.  
% If the software is modified to produce derivative works, such modified 
% software should be clearly marked, so as not to confuse it with the 
% current version.
%                                                                                               
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MATLAB code written by Bettina Schaefli
% Ecole Polytechnique Fédérale de Lausanne,Switzerland
% E-mail: bettina.schaefli@a3.epfl.ch
% PLEASE REPORT ERRORS TO bettina.schaefli@a3.epfl.ch
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 0.5: April 2003
% Version 1.0: Jan. 2004
% Version 1.1: Sept 2006    modified temperature threshold for 
%                           snowfall-rainfall separation
%                           different from original publication
% Version 2.0: Dec 2008     modified numerical scheme in socontplus.m
% Versions 2.1-2.4: Dec 2009 - Jan. 2011: some new comments, balance checks
% Version 2.5: Sept. 2013, updated comments etc. for publication on web
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% 1) initialization of input variables and model parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[qobs,temp,prec,etp,constant,altmoy,corrpluie,lapse,tcrVal,tcrIntVal,...
    altstatT,altstatP,surfbandglac,surfbandnglac]= initgsmsocont;

% 2) interpolation of input series per elevation band
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[tempglac,rainglac,snowglac]    =adjmeteott(temp,prec,altmoy.glacier,...
    lapse,altstatT,corrpluie,altstatP,tcrVal,tcrIntVal);
[tempnglac,rainnglac,snownglac] =adjmeteott(temp,prec,altmoy.nonglacier,...
    lapse,altstatT,corrpluie,altstatP,tcrVal,tcrIntVal);

% 3) compute discharge
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set parameters
% example, not meant to have any relevance for the example data, just to
% check that the code works
agl=8; % condition: agl>an (for physical reasons)
an=4;
lk=-8;
A=1000;
beta=301;
kgl=3;
kn=10;
param=[agl,an,lk,A,beta,kgl,kn];

% new on 1.9.2013: check plausibility of param with respect to prior
% distribution

[parP,parRange]=gsmsocparprior(param);

if parP==1
    [qsim,qb,etr,s,h,Hnfgl]=gsmsocont(tempglac,tempnglac,rainglac,rainnglac,...
        snowglac,snownglac,etp,param,constant,surfbandglac,surfbandnglac);
end

% if the code works well, qsim should equal qobs with the above param set 

% Note: the model does not use any initial storage contents; 
% It is recommended to use at least 1 year of warmup to initialize all the
% stores; other option: run the model for a long period and use the average
% storage to initialize the stores (this requires modification of the
% present code.


% 4) Plot results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1)
set(gca,'FontSize',14)
plot(qsim)
title('Simulated discharge')
hold on
plot(qb,'-r')
legend('Total discharge','Base flow from non-glacier part')

figure(2)
subplot(2,2,1)
plot(etr)
title('Simulated actual evaporation')
subplot(2,2,2)
plot(s)
title('Evolution of slow soil storage')
subplot(2,2,3)
plot(h)
title('Evolution of quick soil storage')
subplot(2,2,4)
plot(Hnfgl)
title('Evolution of glacier storage')

% 5) Simple Monte Carlo simulation-based calibration exercise
% requires statistical toolbox
nMC=50;
for i=1:size(parRange,2)
    randpar(:,i)=random('Uniform',parRange(1,i),parRange(2,i),nMC,1);
end
warmup=100;

for i=1:nMC
    parset=randpar(i,:);
     qsim=gsmsocont(tempglac,tempnglac,rainglac,rainnglac,...
        snowglac,snownglac,etp,parset,constant,surfbandglac,surfbandnglac);
    [nash(i,1),nashlog(i,1),bias(i,1)]=nashbias(qobs(warmup+1:end),qsim(warmup+1:end));
end

[val,ind]=max(nash);
bestpar=randpar(ind,:)


