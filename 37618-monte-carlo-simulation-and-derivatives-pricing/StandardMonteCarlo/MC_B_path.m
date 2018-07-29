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



function [pathS1, pathS2] = MC_B_path(S0,r,d,sigmaB, sigmaBS,T,Z)
%
% Simulate a path within the Bachelier model model
%
%   S0 spot price
%   K the strike price
%   r the riskless rate
%   d the dividend yield
%   sigma the volatility
%   T the maturity
%   NTime number of timesteps
%   NSim number of simulations


NSim = size(Z,1);
NTime = size(Z,2);
Delta = T/NTime;                          % The discretisation step

lnS1 = zeros(NSim,NTime+1);               % init the logspot price path
lnS1(:,1)=log(S0*exp(-d*T));              % adjust due to dividend yield
S1 = zeros(NSim,NTime+1);
S1(:,1) = S0;

%dW = randn(NSim,NTime);                   % precompute all randoms

for i=1:NTime
    lnS1(:,i+1) = lnS1(:,i) + (r-d) * Delta + sigmaBS* sqrt(Delta)*Z(:,i);
    S1(:,i+1) = S1(:,i) + (r-d) * Delta + sigmaB * sqrt(Delta) * Z(:,i);
end
  
pathS1 = exp(lnS1);
pathS2 = S1;
clear dW;
end
