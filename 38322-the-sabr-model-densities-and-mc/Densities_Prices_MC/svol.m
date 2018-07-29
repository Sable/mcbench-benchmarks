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

function y = svol(a, b, r, n, f, k, t)
% computes the sabr implied volatility ( yet incomplete for f == k )

eps = 1e-004;
 if k((f-eps<k) & (k<f+eps))
     y = 0.5*(sv(a,b,r,n,f-eps,k,t) + sv(a,b,r,n,f+eps,k,t));       % to ensure no jumps in the density
 else
    y = sv(a,b,r,n,f,k,t);
end
end

function y = sv(a,b,r,n,f,k,t)
barbeta = 1-b;
Denom = (f .* k).^(0.5*barbeta).*(1+barbeta^2./24.*(log(f./k)).^2+barbeta.^4/1920*(log(f./k)).^4);

z = n ./ a .* (f .* k).^(0.5.*barbeta) .* (log(f./k));
xz = log(((1-2*r*z+z.^2).^(0.5) +z-r)/(1-r)) + (k==f);

y = a ./ Denom .* ((z./xz) + (k==f)) .* (1+t*(barbeta^2/24*a^2 ./ ((f.*k).^barbeta)+0.25*r*b*a*n ./((f .* k).^(0.5*barbeta)) + (2-3*r^2)*n^2/24));
end
