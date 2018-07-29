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


function [Price,Time] = HestonFullSampling(S0,K,r,T,kappa,vLong,volV,rho,vInst,NSim,NTime)
Timer = clock;

dt = T/NTime;
N = 800; eps = 0.25;        % parameters for the grid
grid = eps * (1:N);         % the grid

Vold = vInst*ones(NSim,1);  % holds the current variances
S = S0*ones(NSim,1);        %Initialise price vector
IVds = zeros(NSim,1);       %Initialise integral vector
options = optimset('TolX',1e-8); 
volV2 = volV^2;
% startval = (1-exp(-kappa*dt))/(kappa*dt) * (vInst-vLong) + vLong;
% startval = zeros(NSim,1);

V = 4 * kappa * vLong / (volV2);
Dorg = ( 4 * kappa * exp(-kappa*(dt))) / ( (volV2) * (1 - exp(-kappa*dt)) );
C = ( ( volV2 * (1 - exp(-kappa*dt)) ) / (4 * kappa) );

d = 4 * vLong * kappa / volV2;
gammagrid = sqrt(kappa^2 - 2 * volV2 * 1i * grid );
A = ( gammagrid .* exp( -0.5 * (gammagrid-kappa) * dt ) * (1 - exp(-kappa*dt)) ) ./ ( kappa * (1 - exp(-gammagrid*dt)) );
B2 = kappa * ( 1 + exp(-kappa * dt) ) / ( 1 - exp(-kappa * dt) );
B3 = gammagrid .* ( 1 + exp(-gammagrid * dt) ) ./ ( 1 - exp(-gammagrid * dt) );

C1const = 4 .* gammagrid .* exp(-0.5 * gammagrid * dt) ./ ( volV2 * (1 - exp(-gammagrid * dt)) );
C2const = 4 * kappa * exp(-0.5 * kappa * dt) / ( volV^2 * (1 - exp(-kappa * dt)) );
RCF = rand(NSim,NTime);
Const1 = 2 ./ grid  / pi * eps;

BDiff = B2-B3;
nu = 0.5 * d - 1;

for col = 2:NTime+1    
    D = Dorg * Vold;
    Vnew = C * ncx2rnd(V,D,NSim,1);
    
    B1 = (Vold + Vnew) / (volV2);   
    C2 = besseli(nu,sqrt(Vold .* Vnew) * C2const);
    C1repmat = besseli(nu,sqrt(Vold(:) .* Vnew(:)) * C1const);    
    startval = vLong + (Vold - vLong) * exp(-kappa*dt);
        
    for row = 1:NSim   
        ChFn = real(A .* exp(B1(row) .* BDiff) ...
            .* C1repmat(row,:) ./ C2(row));

        IVds(row) = fzero(@(x) eps*x/pi ...
            + sum(Const1 .* sin(grid * x) .* ChFn)  ...
            - RCF(row,col-1),startval(row),options);
        
%         C1 = besseli(nu,sqrt(Vold(row) .* Vnew(row)) * C1const);
%         C2 = besseli(nu,sqrt(Vold(row) .* Vnew(row)) * C2const);
%         ChFn = real(A .* exp(B1(row) .* BDiff) .* C1 ./ C2);
%         startval = vLong + (Vold(row) - vLong) * exp(-kappa*dt);
%         IVds(row) = fzero(@(x) eps*x/pi + sum(Const1 .* sin(grid * x) .* ChFn)  ...
%            - RandCDF(row),startval,options); %Sample values for integral of V_t
        
        IVds(row) = max(IVds(row),0);
    end

    IrtVdW = (1 / volV) * (Vnew - Vold - kappa * vLong * dt + kappa * IVds); %Sample values for integral of \sqrt{V_t}
    mu = log(S) + r * dt - 0.5 * IVds + rho * IrtVdW;
    sig = (1 - rho^2) * IVds;
    S = exp(mu + randn(NSim,1) .* sqrt(sig)); %Stock price sample
    Vold = Vnew;
end

Price = mean(max(S-K,0))*exp(-r*T);
Time = etime(clock,Timer);

    
%function FIn = FInv(grid,ChFn,x)
%    integrand = ( 2* sin(grid * x) ./ grid ) .* ChFn / pi ;
    %f = @(t) ( s* sin(grid * t) ./ grid ) .* ChFn /pi;
%    FIn = sum(integrand) * (grid(2)-grid(1));
    % FIn = (2 / pi) * trapz(grid,integrand);
    % could also be simpson


