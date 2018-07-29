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



function pathS = MC_NIG(S0,r,d,T,alpha,beta,delta,NTime,NSim,NBatches)
% discretization of NIG process
% using IG subordinator

pathS = zeros(NSim,NTime+1,NBatches);   % create output
lnS = ones(NSim,NTime+1);               % used during batches
lnS(:,1) = log(S0);                     % set spot

omega = delta*(sqrt(alpha^2-(beta+1)^2)...
    -sqrt(alpha^2-beta^2));             % martingale correction
dT = T/NTime;                           % delta time
b_par = delta*sqrt(alpha^2-beta^2);     % par for IG subordinator
theta = dT/b_par;                       % par for IG subordinator             
chi = dT^2;

for l = 1 : NBatches                    % batch loop
    % method based on loops
    for m = 2:NTime+1                   % time loop
        chisq1 = randn(NSim,1).^2;
        Yvec = theta + 0.5*theta./chi .* ( theta.*chisq1 - ...
        sqrt(4*theta.*chi.*chisq1 + theta.^2.*chisq1.^2) );
        Ind = find(rand(NSim,1) >= theta./(theta+Yvec));
        Yvec(Ind) = theta.^2./Yvec(Ind);% IG suborndinator
        dW = randn(NSim,1);             % Gaussians
        lnS(:,m) = lnS(:,m-1) + (r-d+omega)*dT  ...
            + beta*delta^2*Yvec ...
            + delta*sqrt(Yvec).*dW;
    end

    pathS(:,:,l) = exp(lnS);             % simulated paths
end  

