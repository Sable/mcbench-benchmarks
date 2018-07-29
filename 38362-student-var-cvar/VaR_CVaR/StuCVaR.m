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



function y = StuCVaR(x,n)
% General method to compute CVaR for Student distribution with n degrees
% of freedom
    f = @(t,n) -(n^(n-2)*(n+t.^2).^(.5-.5*n)*gamma(.5*(n-1))/(2*sqrt(pi)*gamma(.5*n)));
    arg = FMinusOne(x,n);
    y = sqrt((n-2) / n) * f(arg,n)./x;
end

