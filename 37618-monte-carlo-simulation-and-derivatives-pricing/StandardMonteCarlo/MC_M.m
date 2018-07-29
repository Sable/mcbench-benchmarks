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



function pathS = MC_M(S0,r,d,T,sigma,muj,sigj,lambda,...
    NTime,NSim,NBatches)
% discretization of Merton model
pathS = zeros(NSim,NTime+1,NBatches);

dT = T/NTime;                        % time step

lnS1 = zeros(NSim,NTime+1);          % used in batch
lnS1(:,1) = log(S0*exp(-d*T));       % set S(0) dividend adjusted

omega = (r-d-0.5 * sigma^2) * dT;    % martingale adjustment

for l = 1:NBatches                   % batch loop
    dW = randn(NSim,NTime);          % Gaussians
    Z = randn(NSim,NTime);           % Gaussians
    for i=2:NTime+1                  % time loop
        % Jumps
        P = poissrnd(lambda*dT,NSim,1);        % Poissonians
        lnY = muj*P + sigj*sqrt(P).* Z(:,i-1); % log jumps 

        lnS1(:,i) = lnS1(:,i-1) + omega + sigma* sqrt(dT)*dW(:,i-1)...
            + lnY - dT*lambda*(exp(muj+0.5*sigj^2)-1);
    end
    pathS(:,:,l) = exp(lnS1);
end


