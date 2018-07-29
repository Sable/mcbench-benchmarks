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

function y=svol_3(a, b, r, n, f, k, t)
% SABR asymptotic expansion corrected version by Obloj 2008

eps = 1e-004;                       % determines range around ATM
fleft = f-eps; fright = f+eps;      % range around ATM needs correction

z = n/a*(f^(1-b)-k.^(1-b))/(1-b);
    
I0 = -n*log(k/f)./(log((sqrt(1-2*r*z+z.^2)+z-r)/(1-r)));

I1 = ((b-1)^2/24 * a^2./(f*k).^(1-b) ...
    + 0.25*(r*b*n*a)./(f*k).^((1-b)/2) ...
    + (2-3*r^2)/24 * n^2);

y = I0.*(1+t*I1);                       % standard Obloj
y(fleft<k & k<fright) = a / f^(1-b) ...
    * (1+t*I1(fleft < k & k < fright)); % correction around ATM

end