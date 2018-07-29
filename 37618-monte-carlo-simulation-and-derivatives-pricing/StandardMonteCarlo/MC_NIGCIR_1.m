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




   
function pathS = MC_NIGCIR_1(S0,r,d,T,alpha,beta,delta,kappa,eta,lambda,NTime,NSim,NBatches)
 
% Discretization of Normal Inverse Gaussian process with 
% Cox-Ingersoll-Ross clock
% Option pricing using the Monte Carlo simulation

intNt = 10;              % Steps used for integration the GOU clock
allsteps = intNt * NTime;   % All steps that have to be simulated
deltaT = T / NTime;            % delta for time discretization
time = 0 : deltaT : T;        % variable time for the martingale correction factor

pathS = zeros(NSim,NTime+1,NBatches);
lnS = ones(NSim,NTime+1);  % defining matrix
lnS(:,1) = log(S0);         % Set the starting spot price

% precompute parameters
psiNIG = (-1i)*(-delta)*(sqrt(alpha^2-(beta+1)^2) ...
    -sqrt(alpha^2-beta^2)); % characteristic exponent
gamma = sqrt(kappa^2-2*lambda^2*1i*psiNIG);  % parameter for CIR 
denom = ( cosh(0.5*gamma*time) ...
    + kappa*sinh(0.5*gamma*time)./gamma ).^(2*kappa*eta*lambda^(-2));   %denominator
% coth is inf at 0
phiCIR(time>0) = kappa^2*eta*time(time>0)*lambda^(-2) ...
         + 2*1i*psiNIG./(kappa+gamma.*coth(gamma*time(time>0)/2)) ...
         - log(denom(time>0)); %characteristic function
phiCIR(1) = log(denom(1));
omegaT = -phiCIR;      % martingale correction
omegaT(1) = 0;

Y = zeros(NSim,NTime+1);           % Integrated clock
y = zeros(NSim,allsteps+1);
y(:,1) = 0;
Y(:,1) = 0;

for l = 1 : NBatches
    % Generating time change
   deltaaT = T / allsteps;
   sdeltaaT = sqrt(deltaaT);
   W = randn(NSim,allsteps);
   for n = 1 : allsteps             
       Y1 = y(:,n+1) + kappa * (eta - y(:,n)) * deltaaT + lambda * sqrt(y(:,n))*sdeltaaT .* W(:,n); % Time change process
       %Y1(Y1<0) = 0;
       Y1(Y1<0) = -Y1(Y1<0);
       y(:,n+1) = Y1;
   end
    
   for m=1:NTime
    Y(:,m+1) = Y(:,m) + sum(y(:,1+(m-1)*intNt:m*intNt),2)*deltaaT;
   end
    for m=2:NTime+1
        a_par = Y(:,m)-Y(:,m-1);                       % parameter of IG distribution
        b_par = delta*sqrt(alpha^2-beta^2);            % parameter of IG distribution
        theta = a_par/b_par;                  
        chi = a_par.^2;
        Yvec = ones(NSim,1);
        for n = 1:NSim
            Yvec(n) = randraw('ig', [theta(n), chi(n)], 1 );
        end
        Zvec = randn(NSim,1);
        lnS(:,m) = lnS(:,m-1) + (r-d)*deltaT + omegaT(m)-omegaT(m-1) ...
                     + beta*delta^2*Yvec + delta*sqrt(Yvec).*Zvec;
    end
    
    pathS(:,:,l) = exp(lnS);   % spot paths
end