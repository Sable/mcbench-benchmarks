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



S0 = 100;           % spot price of stock index
r =  0.03;          % risk free rate
d =  0.00;          % dividend yield

sigma = 0.3;        % volatility
sigj = 0.2;         % volatility of jumps
muj = 0.1;          % mean of jumps

C = 18.0968;        % parameter for VG
G = 20.0276;        % parameter for VG
M = 26.3971;        % parameter for VG

nuVG = 1/C;                         % nu for VG
thetaVG = (1/M-1/G)/nuVG;           % theta for VG
sigmaVG = sqrt(((1/G+0.5 ...
    *thetaVG*nuVG)^2 ...
- 0.25*thetaVG^2 * nuVG^2)*2/nuVG); % sigma for VG
                  
kappa = 1.2145;   % parameter of CIR clock
eta = 0.5501;     % parameter of CIR
lambda = 1.7913;  % parameter of CIR
T = 3;

alpha = 0.8;      % parameter for NIG
beta = -0.3;      % parameter for NIG
delta = 0.1;      % parameter for NIG
a = 1;
b = 2;

NTime = 252;      % number of time steps
NSim = 1;         % number of simulations
NBatches = 1;     % number of batches

% Bachelier
pathS = MC_B(S0,r,d,T,sigma,NTime,NSim,NBatches);
figure; plot(pathS); title('Bachelier');
% Black Scholes
pathS = MC_BS(S0,r,d,T,sigma,NTime,NSim,NBatches);
figure; plot(pathS); title('Black-Scholes');
% Displaced diffusion
pathS = MC_DD(S0,r,d,T,sigma,5,NTime,NSim,NBatches);
figure; plot(pathS); title('DD');
% Merton
pathS = MC_M(S0,r,d,T,sigma,muj,sigj,lambda,NTime,NSim,NBatches);
figure; plot(pathS); title('Merton');
% Heston
[pathS, pathV] = MC_QE(S0,r,d,T,0.04,0.04,.2,.2,-.8,NTime,NSim,NBatches);
figure; plot(pathS); title('Heston');
figure; plot(pathV); title('Variance - Heston');
% Heston incl. martingale adjustment
[pathS, pathV] = MC_QE_m(S0,r,d,T,0.04,0.04,.2,.2,-.8,NTime,NSim,NBatches);
figure; plot(pathS); title('Heston - Martingale Adjust');
figure; plot(pathV); title('Variance - Heston - Martingale Adjust');
% Bates
[pathS,pathV] = MC_QE_j(S0,r,d,T,0.04,0.04,.2,.2,-.8,0.1,0.2,0.05,NTime,NSim,NBatches);
figure; plot(pathS); title('Bates');
figure; plot(pathV); title('Variance - Bates');
% Variance Gamma CGM
pathS = MC_VG_CGM(S0,r,d,T,C,G,M,NTime,NSim,NBatches);
figure; plot(pathS); title('VG-CGM');
% Variance Gamma sub
pathS = MC_VG_S(S0,r,d,T,nuVG,thetaVG,sigmaVG,NTime,NSim,NBatches);
figure; plot(pathS); title('VG -\nu,\sigma,\theta');
% Normal Inverse Gaussian
pathS = MC_NIG(S0,r,d,T,alpha,beta,delta,NTime,NSim,NBatches);
figure; plot(pathS); title('NIG');
% Variance Gamma - GOU
pathS = MC_VGGOU(S0,r,d,T,20,20,10,0.75,1,2,NTime,NSim,NBatches);
figure; plot(pathS); title('VGGOU');
% Variance Gamma - CIR
pathS = MC_VGCIR(S0,r,d,T,C,G,M,kappa,eta,lambda,NTime,NSim,NBatches);
figure; plot(pathS); title('VGCIR');
% NIG - GOU
pathS = MC_NIGGOU(S0,r,d,T,alpha,beta,delta,lambda,a,b,NTime,NSim,NBatches);
figure; plot(pathS); title('NIGGOu');
% NIG - CIR
pathS = MC_NIGCIR(S0,r,d,T,alpha,beta,delta,kappa,eta,lambda,NTime,NSim,NBatches);
figure; plot(pathS); title('NIGCIR');

