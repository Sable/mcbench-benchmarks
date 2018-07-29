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



function pathS = MC_NIGCIR(S0,r,d,T,alpha,beta,delta,...
    kappa,eta,lambda,NTime,NSim,NBatches)
% discretization for the NIG - CIR model

intNt = 10;                 % steps in between the org grid points
allsteps = intNt * NTime;   % grid containing all necessary steps
dT = T / NTime;             % time step
daT = T/allsteps;           % time step
time = 0 : dT : T;          % used to determine martingale correction

pathS = zeros(NSim,NTime+1,NBatches);  % output
lnS = ones(NSim,NTime+1);              % used for each batch
lnS(:,1) = log(S0*exp(-d*T));          % S(0) dividend adjusted

% precompute parameters
psiNIG = (-1i)*(-delta)*(sqrt(alpha^2-(beta+1)^2) ...
    -sqrt(alpha^2-beta^2));                  % char exp
gamma = sqrt(kappa^2-2*lambda^2*1i*psiNIG);  % CIR par
denom = ( cosh(0.5*gamma*time) ...           % denom
    + kappa*sinh(0.5*gamma*time)./gamma ).^(2*kappa*eta*lambda^(-2));   
% coth is inf at 0
phiCIR(time>0) = kappa^2*eta*time(time>0)*lambda^(-2) ...
         + 2*1i*psiNIG./(kappa+gamma.*coth(gamma*time(time>0)/2)) ...
         - log(denom(time>0));               % char func
phiCIR(1) = log(denom(1));  % char func at 0
omegaT = -phiCIR;           % martingale correction
omegaT(1) = 0;              % martingale correction at 0

deg = 4*eta*kappa/lambda^2;       
fac1 = 4*kappa*exp(-kappa*daT)/lambda^2/(1-exp(-kappa*daT));
fac2 = lambda^2*(1-exp(-kappa*daT))/4/kappa;

Y = zeros(NSim,NTime+1);            % Integrated clock

for l = 1 : NBatches                % batch loop
   % Generating time change
   yy = ones(NSim,allsteps+1);         % spot clock
   for n = 1 : allsteps             
       Nvec = poissrnd(0.5 * fac1 * yy(:,n));  % Poissonians 
       yy(:,n+1) = fac2 * chi2rnd(deg+2*Nvec); % stochastic time             
   end
   
   for m=1:NTime
        Y(:,m+1) = Y(:,m) + daT * sum(yy(:,1+(m-1)*intNt:m*intNt),2);
    end

    for m=2:NTime+1                 % time loop
        a_par = Y(:,m)-Y(:,m-1);            % parameter of IG distribution
        a_par(a_par<=0) = realmin;          % security check
        b_par = delta*sqrt(alpha^2-beta^2); % parameter of IG distribution
        theta = a_par/b_par;                  
        chi = a_par.^2;       

        chisq1 = randn(NSim,1).^2;
        Yvec = theta + 0.5*theta./chi .* ( theta.*chisq1 - ...
            sqrt(4*theta.*chi.*chisq1 + theta.^2.*chisq1.^2) );
        Ind = find(rand(NSim,1) >= theta./(theta+Yvec));
        Yvec(Ind) = theta(Ind).^2./Yvec(Ind);   % Subordinator
                    
        Zvec = randn(NSim,1);                   % Gaussians
        lnS(:,m) = lnS(:,m-1) + (r-d)*dT + omegaT(m)-omegaT(m-1) ...
                     + beta*delta^2*Yvec + delta*sqrt(Yvec).*Zvec;
    end
    
    pathS(:,:,l) = exp(lnS);   % spot paths
end