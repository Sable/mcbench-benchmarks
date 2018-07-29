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



function [pathS, pathV] = MC_SABR(S0,r,d,T,alpha,beta,rho,nu,NTime,NSim,NBatches)

dt = T/NTime;



pathS = zeros(NSim,NTime+1,NBatches);
pathV = pathS;

S = zeros(NSim,NTime+1);
V = zeros(NSim,NTime+1);
S(:,1) = S0;
V(:,1) = alpha;

NullVec = zeros(NSim,1);

for l = 1:NBatches
    N1 = randn(NSim,NTime);
    N2 = randn(NSim,NTime);
    N1 = rho * N1 + sqrt(1-rho^2) * N2;
    for k = 2:NTime+1
        dW1 = sqrt(dt)* N1(:,k-1);
        dW2 = sqrt(dt)* N2(:,k-1);
        S(:,k) = S(:,k-1) + (r-d) * dt + V(:,k-1).*max([S(:,k-1),NullVec],[],2).^beta.*dW1;
        V(:,k) = V(:,k-1) + nu*V(:,k-1).*dW2;
    end
    pathS(:,:,l) = S;
    pathV(:,:,l) = V;
end
