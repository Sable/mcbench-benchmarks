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

function y = psabr_low(a, b, r, n, f, k, t)
    Kl = max(k(k<0.5*f));
    V1 = psabr(a,b,r,n,f,Kl,t);
    V2 = dpsabr(a,b,r,n,f,Kl,t);
    b = V2/Kl - V1/Kl^2;
    a = 2*V1/Kl-V2;
    k1 = k(k <= 0.5*f);
    y = a .* k1 + b .* k1.^2;
end