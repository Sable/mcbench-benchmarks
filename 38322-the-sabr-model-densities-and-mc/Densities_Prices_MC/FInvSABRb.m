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

function y = FInvSABRb(x, f1)
% This function computes the inverse of a SABR cumulative distribution
f2 = @(t) (x - quad(f1,0,t)).^2;

% need a better guess for the x0!!!!!!!!!!!!!

if (x < 0.4)
    y = fmincon(f2,x/100, -1, 0,[],[],0,[]);
else
    y = fmincon(f2,x, -1, 0,[],[],0,[]);
end
end