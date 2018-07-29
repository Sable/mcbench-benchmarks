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



function pathS = MC_NIGGOU(S0,r,d,T,alpha,beta,delta,lambda,a,b,NTime,NSim,NBatches)
% discretization of Normal Inverse Gaussian process with 
% Gamma Ornstein-Uhlenbeck clock

intNt = 10;                 % steps in between orginial grid points
allsteps = intNt * NTime;   % All Nts that have to be simulated
dT = T / NTime;        % Delta for time discretization
time = 0 : dT : T;    % dummy for martingale correction

pathS = zeros(NSim,NTime+1,NBatches); % output
lnS = zeros(NSim,NTime+1);            % used in batch
lnS(:,1) = log(S0*exp(-d*T));         % set S(0) dividend adjusted

% precompute constants
y0 = 1;
psiNIG = (-1i)*(-delta)*(sqrt(alpha^2-(beta+1)^2) ...
    -sqrt(alpha^2-beta^2));                       % char exp
phiGOU = 1i*psiNIG*y0/lambda*(1-exp(-lambda*time)) ...
         + lambda*a./(1i*psiNIG-lambda*b) ...
         .*(b*log(b./(b-1i*psiNIG/lambda ...
         *(1-exp(-lambda*time))))-1i*psiNIG*time);% char func
omegaT = -phiGOU;           % martingale correction
omegaT(1) = 0;              % martingale correction in 0


for l = 1 : NBatches        % batch loop
    yy = ones(NSim,allsteps+1);             % spot clock
    Np = poissrnd(a*lambda/allsteps*T,[NSim,allsteps]);   % Poissonians       

    for k = 1 : NSim
        for j = 1 : allsteps                  % generating OU process
            if Np(k,j) > 0
                Ex = -log(rand(Np(k,j),1))/b; % RVs with exponential law
                U = exp(-lambda * T / allsteps * rand(Np(k,j),1));          % Uniforms
                yy(k,j+1) = (1-lambda*T/allsteps)*yy(k,j) + sum(Ex .* U);
         else
                yy(k,j+1) = (1-lambda*T/allsteps)*yy(k,j);
            end
        end
    end
    
    ZZ = T*cumsum(yy,2)/allsteps;       % integrated Gamma O-U process
    Y = zeros(NSim,NTime+1);            % intergrated time
    % compute the integrated time at discretization steps
    for m=2:NTime+1
        Y(:,m) = ZZ(:,(m-1)*intNt);
    end

    for m=2:NTime+1     % time loop
        a_par = Y(:,m)-Y(:,m-1);             % IG param
        b_par = delta*sqrt(alpha^2-beta^2);  % IG param
        theta = a_par/b_par;                  
        chi = a_par.^2;
        %Yvec = ones(NSim,1);
        %for n = 1:NSim
        %    Yvec(n) = randraw('ig', [theta(n), chi(n)], 1 );
        %end
        chisq1 = randn(NSim,1).^2;
        Yvec = theta + 0.5*theta./chi .* ( theta.*chisq1 - ...
            sqrt(4*theta.*chi.*chisq1 + theta.^2.*chisq1.^2) );
        Ind = find(rand(NSim,1) >= theta./(theta+Yvec));
        Yvec(Ind) = theta(Ind).^2./Yvec(Ind);   % subordinator
            
        Zvec = randn(NSim,1);       % Gaussian
        lnS(:,m) = lnS(:,m-1) + (r-d)*dT + omegaT(m)-omegaT(m-1) ...
                     + beta*delta^2*Yvec + delta*sqrt(Yvec).*Zvec;
    end
    pathS(:,:,l) = exp(lnS);   % spot paths
end
