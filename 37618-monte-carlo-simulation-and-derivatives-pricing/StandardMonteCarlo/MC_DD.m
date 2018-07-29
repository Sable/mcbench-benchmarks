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

function pathS = MC_DD(S0,r,d,T,sigma,a,NTime,NSim, NBatches)
%
% Path discretization in a displaced diffusion model
%
%   S0 spot price
%   K the strike price
%   r the riskless rate
%   d the dividend yield
%   sigma the volatility
%   T the maturity
%   a displacement parameter
%   NTime number of timesteps
%   NSim number of simulations
%   NBatches number of batches

Delta = T/NTime;                     % The discretisation step

pathS = zeros(NSim,NTime+1,NBatches);% init ouput

lnS1 = zeros(NSim,NTime+1);          % init the logspot price path
lnS1(:,1)=log((S0+a)*exp(-d*T));     % adjust due to displacement dividend

% Time stepping
omega = (r-d-0.5 * sigma^2) * Delta; % equidistant time step
% this could easily be replace by passing in a Delta array
% or used a grid construction adjusted to daycount and rolling conventions

% use the log dynamics
for l = 1:NBatches
    dW = randn(NSim,NTime);          % precompute all randoms for one batch
    
    for i=2:NTime+1
        lnS1(:,i) = lnS1(:,i-1) + omega + sigma* sqrt(Delta)*dW(:,i-1);
    end
 
    pathS(:,:,l) = exp(lnS1) - a;    % transfer to prices using exp 
end
