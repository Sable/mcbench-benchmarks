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

function y = svol_regime(a, b, r, n, f, k, t,low,high)
% SABR implied BS volatility with using regimes for vol of vol
% this is a function for extrpolation of volatility

nu = 0 * k;         % allocation
klow = low*f;       % low strike for regime
khigh = high*f;     % high strike for regime
mu1 = 1; mu2 = 3;   % parameters for regime
% calculate the vol of vol due to regimes
nu(k<klow) = n * 1 ./ sqrt(1+mu1*(k(k<klow)-klow).^2);
nu(k>khigh) = n * 1 ./ sqrt(1+mu2*(k(k>khigh)-khigh).^2);
nu((klow <= k) & (k <= khigh)) = n;

% compute the sabr implied vol using Hagan formula
y =  svol_2(a,b,r,nu,f,k,t);
end
