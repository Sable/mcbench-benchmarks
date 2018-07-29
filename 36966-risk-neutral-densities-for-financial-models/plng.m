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



function p = plng(xnew,xold, t, r, q, sigma)
% transition density of the Black-Scholes model
% using Call prices and finite differences
%     eps = 1e-004;
%     y1 = blsprice(xold, xnew+eps, r-q, t, sigma, 0);
%     y2 = blsprice(xold, xnew, r-q, t, sigma, 0);
%     y3 = blsprice(xold, xnew-eps, r-q, t, sigma, 0);
%     p = exp((r-q)*t)*(y1-2*y2+y3)/eps^2;

% analytic
var = sigma * sigma;
x= xnew./xold - (r - q - var/2) .* t;

p = 1./(x*(sqrt(2*pi*t)*sigma)) .* exp(-log(x).^2/(2*var*t)) / xold;

end