% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Joerg Kienitz
%           Daniel Wetterau
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 




% get workspace with calibrated data
load 'MODEL_Hist_new';

% Simulation parameters
NTime = 12;                    % number of time steps
NSim = 10000;                    % number of simulations
NBatches = 1;                  % number of batches

NHist = 251;                     % number of historic scenarios

NModels = 5;                  % number of models

% options and option parameters 
T= 1;                                   % maturity of option

% option1 = 'Arithmetic Asian Call';
% option2 = 'Arithmetic Asian Put';
% exotic_price_c = @(x,y,r) Price_ArithmeticAsian(x,y,1,r,T);
% exotic_price_p = @(x,y,r) Price_ArithmeticAsian(x,y,0,r,T);

%exotic_price = @(x,r) Price_ArithmeticCliquet(x,LF,LC,GF,GC,r,T);
% option1 = 'FixedStrike Lookback Call';
% option2 = 'FixedStrike Lookback Put';
% exotic_price_c = @(x,y,r) Price_LookBackFixedStrike(x,y,1,r,T);
% exotic_price_p = @(x,y,r) Price_LookBackFixedStrike(x,y,0,r,T);

% option1 = 'FloatingStrike Lookback Call';
% option2 = 'FloatingStrike Lookback Put';
% exotic_price_c = @(x,y,r) Price_LookBackFloatingStrike(x,y,1,r,T);
% exotic_price_p = @(x,y,r) Price_LookBackFloatingStrike(x,y,0,r,T);

option1 = 'Knock-Out Call';
option2 = 'Knock-Out Put';
exotic_price_c = @(x,y,r) Price_KnockOut(x,x(1,1),y,1,r,T);
exotic_price_p = @(x,y,r) Price_KnockOut(x,x(1,1),y,0,r,T);

vanilla_price_c = @(x,y,r) Price_CallPut(x,y,1,r,T);
vanilla_price_p = @(x,y,r) Price_CallPut(x,y,0,r,T);

% output
ep1c = zeros(NHist,NModels); %ep2c = ep1c; ep3c = ep1c;
ep1p = ep1c; %ep2p = ep1c; ep3p = ep1c;

vp_c = ep1c; vp_p = ep1c;

vc = zeros(NHist,1); vp = vc;

U = Spot * 0.9;
L = Spot * 1.1;

matlabpool open local 3

% Black Scholes
parfor l = 1: NHist
%for l = 1: NHist
    pathS = MC_B(Spot(l),r1y(l),0,T,BS_Par_Hist(l),NTime,NSim,NBatches);
    ep1c(l,1) = exotic_price_c(pathS,L(l),r1y(l));
    ep1p(l,1) = exotic_price_p(pathS,U(l),r1y(l));
%    ep1c(l,2) = exotic_price_c(pathS,Spot(l),r1y(l));
%    ep1p(l,2) = exotic_price_p(pathS,Spot(l),r1y(l));
    vp_c(l,1) = vanilla_price_c(pathS,Spot(l),r1y(l));
    vp_p(l,1) = vanilla_price_p(pathS,Spot(l),r1y(l));
    [vc(l), vp(l)] = blsprice(Spot(l), Spot(l), r1y(l), T, BS_ATM_1Y(l),0);
end

% Heston
parfor l = 1: NHist
    [pathS, pathV] = MC_QE(Spot(l),r1y(l),0,T,...
        HESTON_Par_Hist(l,1),HESTON_Par_Hist(l,2),HESTON_Par_Hist(l,3),...
        HESTON_Par_Hist(l,4),HESTON_Par_Hist(l,5),...
        NTime,NSim,NBatches);
    ep1c(l,2) = exotic_price_c(pathS,L(l),r1y(l));
    ep1p(l,2) = exotic_price_p(pathS,U(l),r1y(l));
%    ep1c(l,2) = exotic_price_c(pathS,Spot(l),r1y(l));
%    ep1p(l,2) = exotic_price_p(pathS,Spot(l),r1y(l));
    vp_c(l,2) = vanilla_price_c(pathS,Spot(l),r1y(l));
    vp_p(l,2) = vanilla_price_p(pathS,Spot(l),r1y(l));
end

% Bates
parfor l = 1: NHist
    [pathS, pathV] = MC_QE_j(Spot(l),r1y(l),0,T,...
        BATES_Par_Hist(l,1),BATES_Par_Hist(l,2),BATES_Par_Hist(l,3),BATES_Par_Hist(l,4),...
        BATES_Par_Hist(l,5),BATES_Par_Hist(l,7),BATES_Par_Hist(l,8),BATES_Par_Hist(l,6),...
        NTime,NSim,NBatches);
    ep1c(l,3) = exotic_price_c(pathS,L(l),r1y(l));
    ep1p(l,3) = exotic_price_p(pathS,U(l),r1y(l));
%    ep1c(l,3) = exotic_price_c(pathS,Spot(l),r1y(l));
%    ep1p(l,3) = exotic_price_p(pathS,Spot(l),r1y(l));
    vp_c(l,3) = vanilla_price_c(pathS,Spot(l),r1y(l));
    vp_p(l,3) = vanilla_price_p(pathS,Spot(l),r1y(l));
end

% Variance Gamma CGM
parfor l = 1:NHist
    pathS  = MC_VG_CGM(Spot(l),r1y(l),0,T,...
        VG_Par_Hist(l,1),VG_Par_Hist(l,2),VG_Par_Hist(l,3),...
        NTime,NSim,NBatches);
    ep1c(l,4) = exotic_price_c(pathS,L(l),r1y(l));
    ep1p(l,4) = exotic_price_p(pathS,U(l),r1y(l));
%    ep1c(l,4) = exotic_price_c(pathS,Spot(l),r1y(l));
%    ep1p(l,4) = exotic_price_p(pathS,Spot(l),r1y(l));
    vp_c(l,4) = vanilla_price_c(pathS,Spot(l),r1y(l));
    vp_p(l,4) = vanilla_price_p(pathS,Spot(l),r1y(l));
end

% % Variance Gamma - CIR
parfor l = 1: NHist
    pathS =  MC_VGCIR(Spot(l),r1y(l),0,T,...
        VGCIR_Par_Hist(l,1),VGCIR_Par_Hist(l,2),VGCIR_Par_Hist(l,3), ...
        VGCIR_Par_Hist(l,4),VGCIR_Par_Hist(l,5),VGCIR_Par_Hist(l,6),...
        NTime,NSim,NBatches);
    ep1c(l,5) = exotic_price_c(pathS,L(l),r1y(l));
    ep1p(l,5) = exotic_price_p(pathS,U(l),r1y(l));
%    ep1c(l,5) = exotic_price_c(pathS,Spot(l),r1y(l));
%    ep1p(l,5) = exotic_price_p(pathS,Spot(l),r1y(l));
    vp_c(l,5) = vanilla_price_c(pathS,Spot(l),r1y(l));
    vp_p(l,5) = vanilla_price_p(pathS,Spot(l),r1y(l));
end
% 
m1 = 'BS'; m2 = 'Heston'; m3 = 'Bates';
m4 = 'VG'; m5 = 'VGCIR';
 
plotit2(ep1c,option1,m1, m2, m3, m4, m5);
plotit2(ep1p,option2,m1, m2, m3, m4, m5);

modelriskc_up = repmat(max(ep1c,[],2),1,NModels)-ep1c;
modelriskc_low = -repmat(min(ep1c,[],2),1,NModels)+ep1c;
modelriskp_up = repmat(max(ep1p,[],2),1,NModels)-ep1p;
modelriskp_low = -repmat(min(ep1p,[],2),1,NModels)+ep1p;
plotit2(modelriskc_up,option1,m1, m2, m3, m4, m5);
plotit2(modelriskc_low,option1,m1, m2, m3, m4, m5);
plotit2(modelriskp_up,option2,m1, m2, m3, m4, m5);
plotit2(modelriskp_low,option2,m1, m2, m3, m4, m5);

qp_c = ep1c./ vp_c;
qp_p = ep1p./ vp_p;
plotit2(qp_c,strcat('Normalized ',option1),m1, m2, m3, m4, m5);
plotit2(qp_p,strcat('Normalized ',option2),m1, m2, m3, m4, m5);
matlabpool close
