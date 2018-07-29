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

function y = psabr_7(a,b,r,n,f,fbar,t)
% SABR risk neutral density calculated using the Lesniewski approximation

xi = (f^(1-b) - fbar.^(1-b))/(1-b)/a*n;
D = log((sqrt(xi.^2-2*r*xi+1)+xi-r)/(1-r));
I = sqrt(xi.^2-2*r*xi+1);

y = 1/sqrt(2*pi*t) ./ (a*fbar.^b.*I.^(1.5)) .* exp(-D.^2./(2*t*n^2)) ...
    .* (1 + (a * b * f^(b-1)*D)./(2*n*sqrt(1-r^2).*I) ...
    - .125 * t*n^2 *(1 + a * b * f^(b-1)*D./(2*n*sqrt(1-r^2).*I) ...
    + 6*r*a*b*f^(b-1)./(n*sqrt(1-r^2).*I.^2).*cosh(D) ...
    - (3*(1-r^2)./I + 3*a*b*f^(b-1)*(5-r^2)*D./(2*n*sqrt(1-r^2)*I.^2)) ...
    .* sinh(D)./D));
end