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



function y = cf_vg(u, theta, nu, sigma, t, r)
% Computes the characteristic function for the Variance Gamma model
w  = t*r + t/nu*log(1 - theta*nu - .5*nu*sigma^2);
y  = exp(1i*w*u) .* (1 - 1i*theta*nu*u + .5*sigma^2*nu*(u.^2) ) .^ (-t/nu);
end
