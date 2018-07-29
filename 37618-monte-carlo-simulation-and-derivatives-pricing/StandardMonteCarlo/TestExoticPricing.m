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




% used market data
load 'MODEL_Hist';
% load 'MODEL_Hist_new';

% Discretization parameters
NTime = 12;                    % number of time steps
NSim = 100;                  % number of simulations
NBatches = 1;                  % number of batches

NHist = 251;                     % number of historic scenarios

NModels = 10;                  % number of models

% Options
%K = 6800;                              % Strike
%C = 1;                                 % call (1) or put (0)    
LF = 0; LC = 0.04; GF = 0; GC = 0.15;   % cliquet params
U = Spot * 0.9;
L = Spot * 1.1;
T= 1;                                   % maturity of option

% Comment in the option you wish to price
option1 = 'Arithmetic Asian Call';
option2 = 'Arithmetic Asian Put';
exotic_price_c = @(x,y,r) Price_ArithmeticAsian(x,y,1,r,T);
exotic_price_p = @(x,y,r) Price_ArithmeticAsian(x,y,0,r,T);

%option1 = 'FixedStrike Lookback Call';
%option2 = 'FixedStrike Lookback Put';
%exotic_price_c = @(x,y,r) Price_LookBackFixedStrike(x,y,1,r,T);
%exotic_price_p = @(x,y,r) Price_LookBackFixedStrike(x,y,0,r,T);

%option1 = 'FloatingStrike Lookback Call';
%option2 = 'FloatingStrike Lookback Put';
%exotic_price_c = @(x,y,r) Price_LookBackFloatingStrike(x,y,1,r,T);
%exotic_price_p = @(x,y,r) Price_LookBackFloatingStrike(x,y,0,r,T);

% option1 = 'Arithmetic Cliquet';
% exotic_price_c = @(x,r) Price_ArithmeticCliquet(x,LF,LC,GF,GC,r,T);

% option1 = 'Knock-Out Call';
% option2 = 'Knock-Out Put';
% exotic_price_c = @(x,y,r) Price_KnockOut(x,x(1,1),y,1,r,T);
% exotic_price_p = @(x,y,r) Price_KnockOut(x,x(1,1),y,0,r,T);

vanilla_price_c = @(x,y,r) Price_CallPut(x,y,1,r,T);
vanilla_price_p = @(x,y,r) Price_CallPut(x,y,0,r,T);

% output
ep1c = zeros(NHist,NModels); %ep2c = ep1c; ep3c = ep1c;
ep1p = ep1c; %ep2p = ep1c; ep3p = ep1c;

vp_c = ep1c; vp_p = ep1c;
qp_c = ep1c; qp_p = ep1c;

vc = zeros(NHist,1); vp = vc;

% Black Scholes
for l = 1: NHist
    pathS = MC_B(Spot(l),r1y(l),0,T,BS_Par_Hist(l),NTime,NSim,NBatches);
    ep1c(l,1) = exotic_price_c(pathS,Spot(l),r1y(l));
    ep1p(l,1) = exotic_price_p(pathS,Spot(l),r1y(l));
    vp_c(l,1) = vanilla_price_c(pathS,Spot(l),r1y(l));
    vp_p(l,1) = vanilla_price_p(pathS,Spot(l),r1y(l));
    [vc(l), vp(l)] = blsprice(Spot(l), Spot(l), r1y(l), T, BS_Par_Hist(l),0);
    qp_c(l,1) = ep1c(l,1)/vp_c(l,1);
    qp_p(l,1) = ep1p(l,1)/vp_p(l,1);
end

% Merton
for l = 1: NHist
    pathS = MC_M(Spot(l),r1y(l),0,T,...
        MJ_Par_Hist(l,1),MJ_Par_Hist(l,2),MJ_Par_Hist(l,3),MJ_Par_Hist(l,4),...
        NTime,NSim,NBatches);
    ep1c(l,2) = exotic_price_c(pathS,Spot(l),r1y(l));
    ep1p(l,2) = exotic_price_p(pathS,Spot(l),r1y(l));
    vp_c(l,2) = vanilla_price_c(pathS,Spot(l),r1y(l));
    vp_p(l,2) = vanilla_price_p(pathS,Spot(l),r1y(l));
    qp_c(l,2) = ep1c(l,2)/vp_c(l,2);
    qp_p(l,2) = ep1p(l,2)/vp_p(l,2);
end

% Heston
for l = 1: NHist
    [pathS, pathV] = MC_QE(Spot(l),r1y(l),0,T,...
        HESTON_Par_Hist(l,1),HESTON_Par_Hist(l,2),HESTON_Par_Hist(l,4),...
        HESTON_Par_Hist(l,5),HESTON_Par_Hist(l,3),...
        NTime,NSim,NBatches);
    ep1c(l,3) = exotic_price_c(pathS,Spot(l),r1y(l));
    ep1p(l,3) = exotic_price_p(pathS,Spot(l),r1y(l));
    vp_c(l,3) = vanilla_price_c(pathS,Spot(l),r1y(l));
    vp_p(l,3) = vanilla_price_p(pathS,Spot(l),r1y(l));
    qp_c(l,3) = ep1c(l,3)/vp_c(l,3);
    qp_p(l,3) = ep1p(l,3)/vp_p(l,3);
end

% Bates
for l = 1: NHist
    [pathS, pathV] = MC_QE_j(Spot(l),r1y(l),0,T,...
        BATES_Par_Hist(l,1),BATES_Par_Hist(l,2),BATES_Par_Hist(l,4),BATES_Par_Hist(l,5),...
        BATES_Par_Hist(l,3),BATES_Par_Hist(l,7),BATES_Par_Hist(l,7),BATES_Par_Hist(l,8),...
        NTime,NSim,NBatches);
    ep1c(l,4) = exotic_price_c(pathS,Spot(l),r1y(l));
    ep1p(l,4) = exotic_price_p(pathS,Spot(l),r1y(l));
    vp_c(l,4) = vanilla_price_c(pathS,Spot(l),r1y(l));
    vp_p(l,4) = vanilla_price_p(pathS,Spot(l),r1y(l));
    qp_c(l,4) = ep1c(l,4)/vp_c(l,4);
    qp_p(l,4) = ep1p(l,4)/vp_p(l,4);
end

% Variance Gamma CGM
for l = 1:NHist
    pathS  = MC_VG_CGM(Spot(l),r1y(l),0,T,...
        VG_Par_Hist(l,1),VG_Par_Hist(l,2),VG_Par_Hist(l,3),...
        NTime,NSim,NBatches);
    ep1c(l,5) = exotic_price_c(pathS,Spot(l),r1y(l));
    ep1p(l,5) = exotic_price_p(pathS,Spot(l),r1y(l));
    vp_c(l,5) = vanilla_price_c(pathS,Spot(l),r1y(l));
    vp_p(l,5) = vanilla_price_p(pathS,Spot(l),r1y(l));
    qp_c(l,5) = ep1c(l,5)/vp_c(l,1);
    qp_p(l,5) = ep1p(l,5)/vp_p(l,1);
end

% Normal Inverse Gaussian
for l = 1:NHist
    pathS  = MC_NIG(Spot(l),r1y(l),0,T,...
        NIG_Par_Hist(l,1),NIG_Par_Hist(l,2),NIG_Par_Hist(l,3),...
        NTime,NSim,NBatches);
    ep1c(l,6) = exotic_price_c(pathS,Spot(l),r1y(l));
    ep1p(l,6) = exotic_price_p(pathS,Spot(l),r1y(l));
    vp_c(l,6) = vanilla_price_c(pathS,Spot(l),r1y(l));
    vp_p(l,6) = vanilla_price_p(pathS,Spot(l),r1y(l));
    qp_c(l,6) = ep1c(l,1)/vp_c(l,1);
    qp_p(l,6) = ep1p(l,6)/vp_p(l,1);
end

% Variance Gamma - GOU
for l = 1:NHist
    pathS  = MC_VGGOU(Spot(l),r1y(l),0,T,...
        VGGOU_Par_Hist(l,1), VGGOU_Par_Hist(l,2), VGGOU_Par_Hist(l,3),...
        VGGOU_Par_Hist(l,6), VGGOU_Par_Hist(l,4), VGGOU_Par_Hist(l,5),...
        NTime,NSim,NBatches);
    ep1c(l,7) = exotic_price_c(pathS,Spot(l),r1y(l));
    ep1p(l,7) = exotic_price_p(pathS,Spot(l),r1y(l));
    vp_c(l,1) = vanilla_price_c(pathS,Spot(l),r1y(l));
    vp_p(l,7) = vanilla_price_p(pathS,Spot(l),r1y(l));
    qp_c(l,7) = ep1c(l,7)/vp_c(l,1);
    qp_p(l,7) = ep1p(l,7)/vp_p(l,1);
end

% % Variance Gamma - CIR
for l = 1: NHist
    pathS =  MC_VGCIR(Spot(l),r1y(l),0,T,...
        VGCIR_Par_Hist(l,1),VGCIR_Par_Hist(l,2),VGCIR_Par_Hist(l,3), ...
        VGCIR_Par_Hist(l,4),VGCIR_Par_Hist(l,5),VGCIR_Par_Hist(l,6),...
        NTime,NSim,NBatches);
    ep1c(l,8) = exotic_price_c(pathS,Spot(l),r1y(l));
    ep1p(l,8) = exotic_price_p(pathS,Spot(l),r1y(l));
    vp_c(l,8) = vanilla_price_c(pathS,Spot(l),r1y(l));
    vp_p(l,8) = vanilla_price_p(pathS,Spot(l),r1y(l));
    qp_c(l,8) = ep1c(l,8)/vp_c(l,1);
    qp_p(l,8) = ep1p(l,8)/vp_p(l,1);
end

% NIG - GOU
for l = 1: NHist
    pathS =  MC_NIGGOU(Spot(l),r1y(l),0,T,...
        NIGGOU_Par_Hist(l,1),NIGGOU_Par_Hist(l,2),NIGGOU_Par_Hist(l,3), ...
        NIGGOU_Par_Hist(l,4),NIGGOU_Par_Hist(l,5),NIGGOU_Par_Hist(l,6),NTime,NSim,NBatches);
    ep1c(l,9) = exotic_price_c(pathS,Spot(l),r1y(l));
    ep1p(l,9) = exotic_price_p(pathS,Spot(l),r1y(l));
    vp_c(l,9) = vanilla_price_c(pathS,Spot(l),r1y(l));
    vp_p(l,9) = vanilla_price_p(pathS,Spot(l),r1y(l));
    qp_c(l,9) = ep1c(l,9)/vp_c(l,1);
    qp_p(l,9) = ep1p(l,9)/vp_p(l,1);
end

% NIG - CIR
for l = 1: NHist
    pathS =  MC_NIGCIR(Spot(l),r1y(l),0,T,...
        NIGCIR_Par_Hist(l,1),NIGCIR_Par_Hist(l,2),NIGCIR_Par_Hist(l,3), ...
        NIGCIR_Par_Hist(l,5),NIGCIR_Par_Hist(l,6),NIGCIR_Par_Hist(l,4),NTime,NSim,NBatches);
    ep1c(l,10) = exotic_price_c(pathS,Spot(l),r1y(l));
    ep1p(l,10) = exotic_price_p(pathS,Spot(l),r1y(l));
    vp_c(l,10) = vanilla_price_c(pathS,Spot(l),r1y(l));
    vp_p(l,10) = vanilla_price_p(pathS,Spot(l),r1y(l));
    qp_c(l,10) = ep1c(l,10)/vp_c(l,1);
    qp_p(l,10) = ep1p(l,10)/vp_p(l,1);
end
m1 = 'BS'; m2 = 'MJ'; m3 = 'Heston'; m4 = 'Bates';
m5 = 'VG'; m6 = 'NIG'; m7 = 'VGGOU'; m8 = 'VGCIR';
m9 = 'NIGGOU'; m10 =  'NIGCIR';

% plot the results
plotit(ep1c,option1,m1, m2, m3, m4, m5, m6 ,m7, m8, m9, m10);
plotit(ep1p,option2,m1, m2, m3, m4, m5, m6 ,m7, m8, m9, m10);
plotit(qp_c,strcat('Normalized ',option1),m1, m2, m3, m4, m5, m6 ,m7, m8, m9, m10);
plotit(qp_p,strcat('Normalized ',option2),m1, m2, m3, m4, m5, m6 ,m7, m8, m9, m10);

modelriskc = repmat(max(ep1c,[],2),1,NModels)-ep1c;
modelriskp = -repmat(max(ep1p,[],2),1,NModels)+ep1p;
