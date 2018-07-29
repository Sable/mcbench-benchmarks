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

function y = erfcomplex(x)
% complex error function
% used for valuation method using local times suggested by
% Benhamou et al.
    xr = real(x); xi = imag(x); 
    s1 = erf(xr);
    s2 = 0.5/pi./xr .* exp(-xr.^2) .*(1-cos(2*xr.*xi)+ 1i*sin(2*xr.*xi));
    sum = 0.0;
    f = @(n) exp(-0.25*n.^2)./(n^2+4*xr.^2).*(2*xr -2*xr.*cosh(n*xi) ...
        .*cos(2*xr.*xi)+n*sinh(n*xi).*sin(2*xr.*xi) ...
        + 1i * (2*xr.*cosh(n*xi) .* sin(2*xr.*xi) ...
        + n*sinh(n*xi).* cos(2*xr.*xi)));
 
    for jj = 1:10
        sum = sum + f(jj);
    end
    s3 = 2/pi * exp(-xr.^2).*sum;
    
    y = s1 + s2 + s3;
end