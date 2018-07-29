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



function pathS = MC_SABR_LE(S0, T, sigma_0, alfa, beta, rho, NTime, NSim)

Delta = 1/NTime;                    % size of time steps
NSteps = T/Delta;                   % number time steps overall

pathS = zeros(NSim,NSteps+1);       % init output
pathS(:,1) = S0;                    % set inital spot price
S_Delta_LogEuler = ones(NSim,1)*S0; 

for i = 1:NSteps
    Z = sqrt(Delta)*randn(NSim,1);
    sigma_Delta = sigma_0.*exp(alfa*(Z-0.5*alfa*Delta));
    dW = rho*Z + sqrt(1-rho^2)*sqrt(Delta)*randn(NSim,1);
    S_Delta_LogEuler = S_Delta_LogEuler.*exp(sigma_0.*S_Delta_LogEuler.^(beta-1)...
                                .*(-0.5*sigma_0.*S_Delta_LogEuler.^(beta-1)*Delta + dW));
    sigma_0 = sigma_Delta;
    pathS(:,i+1) = S_Delta_LogEuler;
end