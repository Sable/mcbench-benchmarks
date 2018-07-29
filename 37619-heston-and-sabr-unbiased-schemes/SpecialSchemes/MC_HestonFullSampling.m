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


function [pathS, pathV] = MC_HestonFullSampling(S0,r,T, ...
    vInst,vLong,kappa,omega,rho,NSim,NTime)

% qsobolset = sobolset(NTime,'Skip',1e3,'Leap',1e2);  % use sobol

dt = T/NTime;                                       % Time step size
N = 800; eps = 0.25;                                % parameter for grid
                         
pathV = zeros(NSim,NTime+1); pathV(:,1) = vInst;    % path Variance
Vold = vInst*ones(NSim,1);
IntVariance = zeros(NSim,1);                        % Integrated Variances
Variance = omega^2;

pathS = zeros(NSim,NTime+1); pathS(:,1) = S0;       % path S


options = optimset('TolX',1e-8);                    % for fzero
grid = eps * (1:N);                                 % the grid

V = 4 * kappa * vLong / Variance;
Dorg = 4 * kappa * exp(-kappa*dt) / (Variance * (1 - exp(-kappa*dt)));
C = Variance * (1 - exp(-kappa*dt)) / (4 * kappa);

d = 4 * vLong * kappa / Variance;
gammagrid = sqrt(kappa^2 - 2 * Variance * 1i * grid );
A = gammagrid .* exp( -0.5 * (gammagrid-kappa) * dt ) ...
    *(1 - exp(-kappa*dt)) ./ (kappa * (1 - exp(-gammagrid*dt)));
B2 = kappa * (1 + exp(-kappa * dt)) / (1 - exp(-kappa * dt));
B3 = gammagrid .* (1 + exp(-gammagrid * dt)) ./ (1-exp(-gammagrid * dt));


% constants used
C0const = 2 ./ grid  / pi * eps;
C1const = 4 .* gammagrid .* exp(-0.5 * gammagrid * dt) ...
    ./ ( Variance * (1 - exp(-gammagrid * dt)) );
C2const = 4 * kappa * exp(-0.5 * kappa * dt) ...
    / (Variance * (1 - exp(-kappa * dt)));

RCF = rand(NSim,NTime);                 % use for random numbers
% RCF = net(qsobolset,NSim);            % use for sobol numbers


BDiff = B2-B3;          % calculated out of the loop for speed
nu = 0.5 * d - 1;       % calculated out of the loop for speed

for col = 2:NTime+1    
    D = Dorg * Vold;
    Vnew = C * ncx2rnd(V,D,NSim,1);
    
    B1 = (Vold + Vnew) / (Variance);   
    C2 = besseli(nu,sqrt(Vold .* Vnew) * C2const);
    C1repmat = besseli(nu,sqrt(Vold(:) .* Vnew(:)) * C1const);    
    startval = vLong + (Vold - vLong) * exp(-kappa*dt); % start for fzero
        
    for row = 1:NSim
        CharFunc = real(A .* exp(B1(row) .* BDiff) ...
            .* C1repmat(row,:) ./ C2(row));             % char function
        
        IntVariance(row) = fzero(@(x) eps*x/pi ...
            + sum(C0const .* sin(grid * x) .* CharFunc)  ...
          - RCF(row,col-1),startval(row),options);      % Integrated Var
        
      IntVariance(row) = max(IntVariance(row),0);       % only use pos vals
    end

    SampledIntegratedVol = (1/omega)*(Vnew - Vold - kappa * vLong * dt ...
        + kappa * IntVariance);                         % Integrated Vol
    mu = log(pathS(:,col-1)) + r * dt - 0.5 * IntVariance ...
        + rho * SampledIntegratedVol;                   % drift
    sig = (1 - rho^2) * IntVariance;                    % vol
    
    pathS(:,col) = exp(mu + randn(NSim,1) .* sqrt(sig));% exact solution
    Vold = Vnew; pathV(:,col) = Vnew;
end
