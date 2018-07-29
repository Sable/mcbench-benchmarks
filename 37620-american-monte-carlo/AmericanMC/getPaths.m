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



function y = getPaths(S0, r, sigma, dt, NSim, Nr)
% Path retrieval for american MC

if length(S0) > 1
    lenS = length(S0);             % for using this with different starting values
    R = exp((r - sigma^2 / 2) * dt ...
    + sigma * sqrt(dt) * randn(NSim,Nr,lenS));   % random noise + drift
    tmp = zeros(NSim,1,lenS);
    tmp(:,1,:) = repmat(log(S0)',NSim,1);
    y = exp(cumsum([tmp, R], 2));    % path set simple example
else
    R = exp((r - sigma^2 / 2) * dt ...
    + sigma * sqrt(dt) * randn(NSim,Nr));   % random noise + drift
    y = cumprod([S0 * ones(NSim,1), R], 2);    % path set simple example
end
end