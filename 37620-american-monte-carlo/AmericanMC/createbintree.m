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



function [S, u, d, df, p] = createbintree(S0, T, n, r, sigma)
% creates a simple binomial tree using repmat
    dt = T / n;                  % length of one period
    u = exp(sigma * sqrt(dt));   % up move
    d = 1 / u;                   % down move
    df = exp(-r * dt);           % discount
    p = (1/df - d) / (u - d);    % probability up

    S = zeros(2^n, n+1);
    S(:,1) = S0*ones(2^n,1);

    for i=1:1:n
        a = [u * ones(2^(n-i),1); d * ones(2^(n-i),1)];
        S(:,i+1) = S(:,i).*repmat(a, 2^(i-1),1);
    end

end