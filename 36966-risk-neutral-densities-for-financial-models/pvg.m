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



function p = pvg(xnew, xold, t, r,C,G,M)
% the transition density of the variance gamma model
nu = 1/C;
mu = (1/M-1/G)/nu;
sigma = sqrt(((1/G+mu*nu/2)^2-mu^2*nu^2/4)*2/nu);

var = sigma * sigma;                                
omega = - t/nu * log(1 - mu*nu * var *nu /2);       %martingale correction due to model
x= xnew - xold - r*t - omega;                       %xnew - xold - martingale corrected drift

C = sqrt(var * nu / (2 * pi))*(mu^2*nu + 2*var)^(0.25 - t/(2*nu)) / gamma(t/nu);
A = mu / var;
B = sqrt(mu^2+2*var/nu)/var;

p = C.*abs(x).^(t/nu-0.5).*exp(A.*x).*besselk(t/nu-0.5,B.*abs(x));
end
