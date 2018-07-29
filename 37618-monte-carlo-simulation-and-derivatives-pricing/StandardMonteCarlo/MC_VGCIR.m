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



function pathS = MC_VGCIR(S0,r,d,T,C,G,M,kappa,eta,...
    lambda,NTime,NSim,NBatches)
intNt = 20;                 % steps in between orginial grid points
allsteps = intNt * NTime;   % grid containing all necessary steps
dT = T / NTime;             % time step
daT = T/allsteps;           % time step
time = 0 : T/NTime : T;     % time for martingale correction

pathS = zeros(NSim,NTime+1,NBatches);% output
lnS = ones(NSim,NTime+1);            % used for each batch
lnS(:,1) = log(S0*exp(-d*T));        % set S(0) dividend adjusted

% precompute constants
psiVG = (-1i)*C*log(G*M/(G*M+(M-G)-1));   % char exp
gamma = sqrt(kappa^2-2*lambda^2*1i*psiVG);% CIR par
denom = ( cosh(0.5*gamma*time) ...        % denom
    + kappa*sinh(0.5*gamma*time)./gamma ).^(2*kappa*eta*lambda^(-2));   
% coth is inf at 0
phiCIR(time>0) = kappa^2*eta*time(time>0)*lambda^(-2) ...
         + 2*1i*psiVG./(kappa+gamma.*coth(gamma*time(time>0)/2)) ...
         - log(denom(time>0));            % char func
phiCIR(1) = log(denom(1));                % char func start
omegaT = -phiCIR;                         % martingale correction                              
omegaT(1) = 0;                            % maringale correction in 0


deg = 4*eta*kappa/lambda^2;       
fac1 = 4*kappa*exp(-kappa*daT)/lambda^2/(1-exp(-kappa*daT));
fac2 = lambda^2*(1-exp(-kappa*daT))/4/kappa;

Y = zeros(NSim,NTime);                   % Integrated clock


for l = 1 : NBatches                     % batch loop  
   % Generating time change
   yy = ones(NSim,allsteps+1);              % stochastic clock
   for n = 1 : allsteps             
       Nvec = poissrnd(0.5 * fac1 * yy(:,n));  % Poissonians 
       yy(:,n+1) = fac2 * chi2rnd(deg+2*Nvec); % stochastic time              
   end
    
   for m=1:NTime
        Y(:,m+1) = Y(:,m) + daT * sum(yy(:,1+(m-1)*intNt:m*intNt),2);
   end
    
   Intensity = C * (Y(:,2:end)-Y(:,1:end-1));           % intensity
   DGam = gamrnd(Intensity,1/M) - gamrnd(Intensity,1/G);% diff gamma proc
   diffomegaT = omegaT(2:end) - omegaT(1:end-1);        % Martingale correction
    
   for m=2:NTime+1                      % time loop
       lnS(:,m) = lnS(:,m-1) + (r-d)*dT + diffomegaT(m-1) + DGam(:,m-1); 
   end
   pathS(:,:,1) = exp(lnS);
end
