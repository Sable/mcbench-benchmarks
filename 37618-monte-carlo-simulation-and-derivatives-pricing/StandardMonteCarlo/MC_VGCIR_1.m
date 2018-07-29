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



function pathS = MC_VGCIR_1(S0,r,d,T,C,G,M,kappa,eta,lambda,NTime,NSim,NBatches)
intNt = 20;             % Steps used for integration the CIR clock
allsteps = intNt * NTime;  % All Nts that have to be simulated
deltaT = T / NTime;
time = 0 : T/NTime : T;                     % Variable time for the martingale correction factor

pathS = zeros(NSim,NTime+1,NBatches);
lnS = ones(NSim,NTime+1);  % stores the values of the log asset prices
lnS(:,1) = log(S0);

% precompute constants
psiVG = (-1i)*C*log(G*M/(G*M+(M-G)-1));   % characteristic exponent
gamma = sqrt(kappa^2-2*lambda^2*1i*psiVG);  % parameter for CIR 
denom = ( cosh(0.5*gamma*time) ...
    + kappa*sinh(0.5*gamma*time)./gamma ).^(2*kappa*eta*lambda^(-2));   %denominator
% coth is inf at 0
phiCIR(time>0) = kappa^2*eta*time(time>0)*lambda^(-2) ...
         + 2*1i*psiVG./(kappa+gamma.*coth(gamma*time(time>0)/2)) ...
         - log(denom(time>0)); %characteristic function
phiCIR(1) = log(denom(1));
omegaT = -phiCIR;                                %martingale correction                              
omegaT(1) = 0;

Y = zeros(NSim,NTime+1);           % Integrated clock
y = zeros(NSim,allsteps+1);
y(:,1) = 1;
Y(:,1) = 0;

for l = 1 : NBatches      
    % Generating time change
   deltaaT = T / allsteps;
   sdeltaaT = sqrt(deltaaT);
   W = randn(NSim,allsteps);
   for n = 1 : allsteps             
       Y1 = y(:,n) + kappa * (eta - y(:,n)) * deltaaT + lambda * sqrt(y(:,n))*sdeltaaT .* W(:,n); % Time change process
       %Y1(Y1<0) = 0;               % absorbing
       Y1(Y1<0) = -Y1(Y1<0);        % reflecting
       y(:,n+1) = Y1;
   end
   y(:,1)=0;
   for m=1:NTime
        Y(:,m+1) = Y(:,m) + sum(y(:,1+(m-1)*intNt:m*intNt),2)*deltaaT;
   end
   
   Intensity = C * (Y(:,2:end)-Y(:,1:end-1));
   DGam = gamrnd(Intensity,1/M) - gamrnd(Intensity,1/G);
   diffomegaT = omegaT(2:end) - omegaT(1:end-1);     % Martingale correction
    
   for m=2:NTime+1
    lnS(:,m) = lnS(:,m-1) + (r-d)*deltaT + diffomegaT(m-1) + DGam(:,m-1);   %Simulate by difference
   end
   pathS(:,:,1) = exp(lnS);
end


