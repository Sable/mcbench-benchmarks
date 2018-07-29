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



function pathS = MC_VG_S(S0,r,d,T,nu,theta,sigma,NTime,NSim,NBatches)
% discretization of Variance Gamma process
% using subordination

pathS = zeros(NSim,NTime+1,NBatches);       % create the output
lnS = zeros(NSim,NTime+1);                  % used per batch
dT = T / NTime;                             % delta time
omegaT = -1/nu * log(1-theta(1)*nu ...
    - nu*sigma(1)^2/2);                     % martingale correction    
lnS(:,1) = log(S0);                         % Set the starting spot price

for l = 1 : NBatches                        % batch loop
    % G = nu * gamrnd(dT/nu,1,NSim,NTime);
    % dW = randn(NSim,NTime);
    for m=2:NTime+1                         % time loop
        G = nu * gamrnd(dT/nu,1,NSim,1);      % Gamma subordinator
        dW = randn(NSim,1);                 % Gaussians
        lnS(:,m) = lnS(:,m-1) ...           % log VG
            + (r-d-omegaT) * dT ...
            + theta(1) * G + sqrt(G) * sigma .* dW;
    end
    
    pathS(:,:,l) = exp(lnS);                % simulated paths
end

