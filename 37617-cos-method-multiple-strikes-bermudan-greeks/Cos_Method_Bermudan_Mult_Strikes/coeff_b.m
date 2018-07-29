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



function [chi, psi] = coeff_b(k, x1, x2, a, b)
% compute chi and psi for cosine method

arg2 = k .* pi * diag((x2 - a) ./ (b - a));     % arg trig func
arg1 = k .* pi * diag((x1 - a) ./ (b - a));     % arg trig func

term1 = cos( arg2 ) * diag(exp(x2));
term2 = cos( arg1 ) * diag(exp(x1));

term3 = pi * k .* sin( arg2 ) * diag(exp(x2)./ (b-a));
term4 = pi * k .* sin( arg1 ) * diag(exp(x1)./ (b-a));

chi = 1 ./ ( 1 + ((k .* pi) *diag(1./ (b - a))).^2 ) ...
    .* ( term1 - term2 + term3 - term4 );   % modify init

chi(1,:) = (exp(x2)-exp(x1)); % init chi

psi = ((sin(arg2) - sin(arg1)) ./ (k .* pi)) *diag(b-a);    % modify init

psi(1,:) = (x2-x1);           % init psi

end
