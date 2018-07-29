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



% get calibrated data
load 'MODEL_Hist';

% Discretization parameters
NTime = 12;                    % number of time steps
NSim = 10;                    % number of simulations
NBatches = 1;                  % number of batches

NHist = 1;                     % number of historic scenarios
NModels = 10;                  % number of models



% Options   
LF = 0; LC = 0.04; GF = 0; GC = 0.15;   % cliquet params
T= 1;                                   % maturity of option
 %exotic_price_c = @(x,y,r) Price_ArithmeticAsian(x,y,1,r,T);
 %exotic_price_p = @(x,y,r) Price_ArithmeticAsian(x,y,0,r,T);

%exotic_price = @(x,r) Price_ArithmeticCliquet(x,LF,LC,GF,GC,r,T);
% exotic_price_c = @(x,y,r) Price_LookBackFixedStrike(x,y,1,r,T);
% exotic_price_p = @(x,y,r) Price_LookBackFixedStrike(x,y,0,r,T);
exotic_price_c = @(x,y,r) Price_KnockOut(x,x(1,1),y,1,r,T);
exotic_price_p = @(x,y,r) Price_KnockOut(x,x(1,1),y,0,r,T);
vanilla_price_c = @(x,y,r) Price_CallPut(x,y,1,r,T);
vanilla_price_p = @(x,y,r) Price_CallPut(x,y,0,r,T);

% output
ep1c = zeros(NHist,NModels); %ep2c = ep1c; ep3c = ep1c;
ep1p = ep1c; %ep2p = ep1c; ep3p = ep1c;

vp_c = ep1c; vp_p = ep1c;
qp_c = ep1c; qp_p = ep1c;

vc = zeros(NHist,1); vp = vc;

% Black Scholes

l = 1;
    pathS = MC_B(Spot(l),r1y(l),0,T,BS_Par_Hist(l),NTime,NSim,NBatches);
    ep1c(1,1) = exotic_price_c(pathS,Spot(l)*1.2,r1y(l));
    ep1p(1,1) = exotic_price_p(pathS,Spot(l)*1.2,r1y(l));
    vp_c(1,1) = vanilla_price_c(pathS,Spot(l),r1y(l));
    vp_p(1,1) = vanilla_price_p(pathS,Spot(l),r1y(l));
    [vc(1), vp(1)] = blsprice(Spot(l), Spot(l), r1y(l), T, BS_Par_Hist(l),0);
    qp_c(1,1) = ep1c(1,1)/vp_c(1,1);
    qp_p(1,1) = ep1p(1,1)/vp_p(1,1);


% Merton

    pathS = MC_M(Spot(l),r1y(l),0,T,...
        MJ_Par_Hist(l,1),MJ_Par_Hist(l,2),MJ_Par_Hist(l,3),MJ_Par_Hist(l,4),...
        NTime,NSim,NBatches);
    ep1c(1,2) = exotic_price_c(pathS,Spot(l),r1y(l));
    ep1p(1,2) = exotic_price_p(pathS,Spot(l),r1y(l));
    vp_c(1,2) = vanilla_price_c(pathS,Spot(l),r1y(l));
    vp_p(1,2) = vanilla_price_p(pathS,Spot(l),r1y(l));
    qp_c(1,2) = ep1c(1,2)/vp_c(1,1);
    qp_p(1,2) = ep1p(1,2)/vp_p(1,1);


% Heston

    [pathS, pathV] = MC_QE(Spot(l),r1y(l),0,T,...
        HESTON_Par_Hist(l,1),HESTON_Par_Hist(l,2),HESTON_Par_Hist(l,4),...
        HESTON_Par_Hist(l,5),HESTON_Par_Hist(l,3),...
        NTime,NSim,NBatches);
    ep1c(1,3) = exotic_price_c(pathS,Spot(l),r1y(l));
    ep1p(1,3) = exotic_price_p(pathS,Spot(l),r1y(l));
    vp_c(1,3) = vanilla_price_c(pathS,Spot(l),r1y(l));
    vp_p(1,3) = vanilla_price_p(pathS,Spot(l),r1y(l));
    qp_c(1,3) = ep1c(1,3)/vp_c(1,1);
    qp_p(1,3) = ep1p(1,3)/vp_p(1,1);


% Bates

%     [pathS, pathV] = MC_QE_j(Spot(l),r1y(l),0,T,...
%         BATES_Par_Hist(l,1),BATES_Par_Hist(l,2),BATES_Par_Hist(l,4),BATES_Par_Hist(l,5),...
%         BATES_Par_Hist(l,3),BATES_Par_Hist(l,7),BATES_Par_Hist(l,7),BATES_Par_Hist(l,8),...
%         NTime,NSim,NBatches);
%     ep1c(1,4) = exotic_price_c(pathS,Spot(l),r1y(l));
%     ep1p(1,4) = exotic_price_p(pathS,Spot(l),r1y(l));
%     vp_c(1,4) = vanilla_price_c(pathS,Spot(l),r1y(l));
%     vp_p(1,4) = vanilla_price_p(pathS,Spot(l),r1y(l));
%     qp_c(1,4) = ep1c(1,4)/vp_c(1,1);
%     qp_p(1,4) = ep1p(1,4)/vp_p(1,1);
% 
% 
% % Variance Gamma CGM
% 
%     pathS  = MC_VG_CGM(Spot(l),r1y(l),0,T,...
%         VG_Par_Hist(l,1),VG_Par_Hist(l,2),VG_Par_Hist(l,3),...
%         NTime,NSim,NBatches);
%     ep1c(1,5) = exotic_price_c(pathS,Spot(l),r1y(l));
%     ep1p(1,5) = exotic_price_p(pathS,Spot(l),r1y(l));
%     vp_c(1,5) = vanilla_price_c(pathS,Spot(l),r1y(l));
%     vp_p(1,5) = vanilla_price_p(pathS,Spot(l),r1y(l));
%     qp_c(1,5) = ep1c(1,5)/vp_c(1,1);
%     qp_p(1,5) = ep1p(1,5)/vp_p(1,1);
% 
% 
% % Normal Inverse Gaussian
% 
%     pathS  = MC_NIG(Spot(l),r1y(l),0,T,...
%         NIG_Par_Hist(l,1),NIG_Par_Hist(l,2),NIG_Par_Hist(l,3),...
%         NTime,NSim,NBatches);
%     ep1c(1,6) = exotic_price_c(pathS,Spot(l),r1y(l));
%     ep1p(1,6) = exotic_price_p(pathS,Spot(l),r1y(l));
%     vp_c(1,6) = vanilla_price_c(pathS,Spot(l),r1y(l));
%     vp_p(1,6) = vanilla_price_p(pathS,Spot(l),r1y(l));
%     qp_c(1,6) = ep1c(1,1)/vp_c(1,1);
%     qp_p(1,6) = ep1p(1,6)/vp_p(1,1);
% 
% 
% % Variance Gamma - GOU
% 
%     pathS  = MC_VGGOU(Spot(l),r1y(l),0,T,...
%         VGGOU_Par_Hist(l,1), VGGOU_Par_Hist(l,2), VGGOU_Par_Hist(l,3),...
%         VGGOU_Par_Hist(l,6), VGGOU_Par_Hist(l,4), VGGOU_Par_Hist(l,5),...
%         NTime,NSim,NBatches);
%     ep1c(1,7) = exotic_price_c(pathS,Spot(l),r1y(l));
%     ep1p(1,7) = exotic_price_p(pathS,Spot(l),r1y(l));
%     vp_c(1,7) = vanilla_price_c(pathS,Spot(l),r1y(l));
%     vp_p(1,7) = vanilla_price_p(pathS,Spot(l),r1y(l));
%     qp_c(1,7) = ep1c(1,7)/vp_c(1,1);
%     qp_p(1,7) = ep1p(1,7)/vp_p(1,1);
% 
% 
% % % Variance Gamma - CIR
% 
%     pathS =  MC_VGCIR_1(Spot(l),r1y(l),0,T,...
%         VGCIR_Par_Hist(l,1),VGCIR_Par_Hist(l,2),VGCIR_Par_Hist(l,3), ...
%         VGCIR_Par_Hist(l,4),VGCIR_Par_Hist(l,5),VGCIR_Par_Hist(l,6),...
%         NTime,NSim,NBatches);
%     ep1c(1,8) = exotic_price_c(pathS,Spot(l),r1y(l));
%     ep1p(1,8) = exotic_price_p(pathS,Spot(l),r1y(l));
%     vp_c(1,8) = vanilla_price_c(pathS,Spot(l),r1y(l));
%     vp_p(1,8) = vanilla_price_p(pathS,Spot(l),r1y(l));
%     qp_c(1,8) = ep1c(1,8)/vp_c(1,1);
%     qp_p(1,8) = ep1p(1,8)/vp_p(1,1);
% 
% 
% % NIG - GOU
% 
%     pathS =  MC_NIGGOU(Spot(l),r1y(l),0,T,...
%         NIGGOU_Par_Hist(l,1),NIGGOU_Par_Hist(l,2),NIGGOU_Par_Hist(l,3), ...
%         NIGGOU_Par_Hist(l,4),NIGGOU_Par_Hist(l,5),NIGGOU_Par_Hist(l,6),NTime,NSim,NBatches);
%     ep1c(1,9) = exotic_price_c(pathS,Spot(l),r1y(l));
%     ep1p(1,9) = exotic_price_p(pathS,Spot(l),r1y(l));
%     vp_c(1,9) = vanilla_price_c(pathS,Spot(l),r1y(l));
%     vp_p(1,9) = vanilla_price_p(pathS,Spot(l),r1y(l));
%     qp_c(1,9) = ep1c(1,9)/vp_c(1,1);
%     qp_p(1,9) = ep1p(1,9)/vp_p(1,1);
% 
% 
% % NIG - CIR
% 
%     pathS =  MC_NIGCIR(Spot(l),r1y(l),0,T,...
%         NIGCIR_Par_Hist(l,1),NIGCIR_Par_Hist(l,2),NIGCIR_Par_Hist(l,3), ...
%         NIGCIR_Par_Hist(l,5),NIGCIR_Par_Hist(l,6),NIGCIR_Par_Hist(l,4),NTime,NSim,NBatches);
%     ep1c(1,10) = exotic_price_c(pathS,Spot(l),r1y(l));
%     ep1p(1,10) = exotic_price_p(pathS,Spot(l),r1y(l));
%     vp_c(1,10) = vanilla_price_c(pathS,Spot(l),r1y(l));
%     vp_p(1,10) = vanilla_price_p(pathS,Spot(l),r1y(l));
%     qp_c(1,10) = ep1c(1,10)/vp_c(1,1);
%     qp_p(1,10) = ep1p(1,10)/vp_p(1,1);
