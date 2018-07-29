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

function y = sprice_4(a, b, r, n, f, k, t,cp)
% sabr prices using the risk neutral density psabr_4 
% and integrating this density with respect to the payoff

nl = length(k);
y = ones(1,nl);
if (cp == 1)
    % call
    for j = 1:nl
    F = @(x) (x-k(j)) .* psabr_4(a, b, r, n, f, x, t);
    y(j) = quad(F,k(j),1);
    % using Put Call Parity
    %F = @(x) (k(j)-x) .* psabr_4(a, b, r, n, f, x, t);
    %f - k(j) - quad(F,k(j),1)
    end
else
    % put
    for j = 1:nl
%    F = @(x) (k(j)-x) .* psabr_4(a, b, r, n, f, x, t);
%    y(j) = quad(F,0,k(j));
    % using Put Call Parity
     F = @(x) (x-k(j)) .* psabr_4(a, b, r, n, f, x, t);
     y(j) = k(j) - f + quad(F,k(j),1);
    end    
end

end