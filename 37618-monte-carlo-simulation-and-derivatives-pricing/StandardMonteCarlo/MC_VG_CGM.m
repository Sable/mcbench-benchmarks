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



function pathS = MC_VG_CGM(S0,r,d,T,C,G,M,NTime,NSim,NBatches)
% discretization of Variance Gamma process
% using the cgm representation

pathS = zeros(NSim,NTime+1,NBatches);       % create the output
lnS = zeros(NSim,NTime+1);                  % used per batch

dT = T / NTime;                         % delta time
omegaT = -C*log((G*M /(G*M + (M-G)-1)));    % martingale correction    
lnS(:,1) = log(S0);                         % set spot price
    
for l = 1 : NBatches                        % batch loop
    for m=2:NTime+1                         % time loop
        Gvec1 = gamrnd(C*dT, 1/M, NSim,1); % Gamma process1
        Gvec2 = gamrnd(C*dT, 1/G, NSim,1); % Gamma process2
        lnS(:,m) = lnS(:,m-1) + (r-d + omegaT) * dT  ...
                     + Gvec1 - Gvec2;       % log VG 
    end
    
    pathS(:,:,l) = exp(lnS);                % output sim result
end