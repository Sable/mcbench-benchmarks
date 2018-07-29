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

function y = svol_2(a, b, r, n, f, k, t)
% computes the SABR implied BS volatility due to Hagan's formula

	z = n./a.*(f*k).^((1-b)/2).*log(f./k);
	x = log((sqrt(1 - 2*r*z + z.^2) + z - r)/(1-r));
	Term1 = a ./ (f*k).^((1-b)/2) ./ (1 + (1-b)^2/24*log(f./k).^2 ...
        + (1-b)^4/1920*log(f./k).^4);
	Term2 = z ./ x;
	Term2(abs(x-z) < 1e-008) = 1;           % account for ATM
	Term3 = 1 + ((1-b)^2/24*a^2./(f*k).^(1-b) ...
        + r*b*n*a/4./(f*k).^((1-b)/2) + (2-3*r^2)/24*n.^2)*t;
	y = Term1.*Term2.*Term3;
end