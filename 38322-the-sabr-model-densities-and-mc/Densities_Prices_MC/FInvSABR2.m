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

function [c,fc] = FInvSABR2(x, a, b, r, n, f, t)
% This function computes the inverse of a SABR cumulative distribution
% Since it is based on FSABR2 it is very fast!
% x is the quantile for which we have to find the value to use
f = @(k) psabr_4(a, b, r, n, f, k, t); % handle
f2 = @(t) (x - FSABR2(t,f));           % objective function

% Use simple bisection
a = 0.001;  b = 1;                     % lower and upper bound
eps = 1e-3;         % threshold
k = 0;              % index

fc = zeros(1,10);   % initialize

while(k <= 100)
    k = k+1;
    c=0.5*(b+a);
    fc = f2(c);
    if( (-eps <= fc) && (fc <= eps))
        break;
    elseif (f2(c) < 0)
        b = c;
    else
        a = c;
    end
end

end