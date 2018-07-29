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

function [c,fc] = FInvSABR4(y, f)
% This function computes the inverse of a SABR cumulative distribution
% Since it is based on FSABR2 it is very fast and works for vectors!
f2 = @(x) (y - FSABR2(x,f));

% Use simple bisection
a = 0.0001 * ones(1,length(y)); % left starting points
b = ones(1,length(y));          % right starting points

eps = 1e-3;                     % accuracy level
k = 0;                          % init iteration counter
fc = zeros(1,length(y));        % init fc vector

while(k <= 100)
    k = k+1;                       % increase iteration counter
    c = 0.5*(b+a);                 % calculate new c
    fc = f2(c);                    % evaluate function at new c
    
    if( (-eps <= fc) & (fc <= eps))
        break;                     % end if all values have been found
    else
        b(fc<0) = c(fc<0);         % update right boundary
        a(fc>=0) = c(fc>=0);       % update left boundary
    end
end

end