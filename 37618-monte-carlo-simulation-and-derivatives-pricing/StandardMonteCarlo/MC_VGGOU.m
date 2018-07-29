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



function pathS = MC_VGGOU(S0,r,d,T,C,G,M,lambda,a,b,NTime,NSim,NBatches)
    intNt = 20;                 % steps in between orginial grid points
    allsteps = intNt * NTime;   % grid containing all necsseary steps
    dT = T / NTime;             % time step
    time = 0 : dT : T;          % tiem for martingale correction
    
    pathS = zeros(NSim,NTime+1,NBatches); % output
    lnS = zeros(NSim,NTime+1);      % used in batch
    lnS(:,1) = log(S0*exp(-d*T));   % set S(0) dividend adjusted
    
    %precompute the constants used for martingale correction
    y0 = 1;
    psiVG = (-1i)*C*log(G*M/(G*M+(M-G)-1));     % char exp                                     %characteristic exponent
    phiGOU = 1i*psiVG*y0/lambda*(1-exp(-lambda*time)) + ...
         lambda*a./(1i*psiVG-lambda*b).* ...                      
         (b*log(b./(b-1i*psiVG/lambda* ...
         (1-exp(-lambda*time))))-1i*psiVG*time); % char func
    omegaT = -phiGOU;           % martingale correction                                                         %martingale correction value
    omegaT(1) = 0;              % martingale correction in 0

for l = 1:NBatches              % batch loop
    yy = ones(NSim,allsteps+1); % init stochastic clock
    Np = poissrnd(a*lambda/allsteps*T,[NSim,allsteps]);
       
    for k = 1 : NSim
        for j = 1 : allsteps     % generating OU process
            if Np(k,j) > 0
                Ex = -log(rand(Np(k,j),1))/b; % exponential law
                U = exp(-lambda * T / allsteps * rand(Np(k,j),1));          % Uniforms
                yy(k,j+1) = (1-lambda*T/allsteps)*yy(k,j) ...
                    + sum(Ex .* U);
         else
                yy(k,j+1) = (1-lambda*T/allsteps)*yy(k,j);
            end
        end
    end

    ZZ = T*cumsum(yy,2)/allsteps;       %Integrated Time
    Y = zeros(NSim,NTime+1);
    for m = 2:NTime+1
        Y(:,m) = ZZ(:,(m-1)*intNt);
    end
   
    Intensity = C * (Y(:,2:end)-Y(:,1:end-1));      % intensity
    DGam = gamrnd(Intensity,1/M) - gamrnd(Intensity,1/G);
    diffomegaT = omegaT(2:end) - omegaT(1:end-1);   % maringale corr
    
    for m=2:NTime+1             % time loop
        lnS(:,m) = lnS(:,m-1) + (r-d)*dT ...
            + diffomegaT(m-1) + DGam(:,m-1);
    end
    pathS(:,:,l) = exp(lnS);
end
