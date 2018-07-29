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

function y = sprice(a, b, r, n, f, k, t,cp)
% calculates the sabr price cp == 1 call else put using the standard Hagan
% et al. formula
sigma = svol_2(a,b,r,n,f,k,t);                        % vol
d1= (log(f./k)+(0.5*t*sigma.*sigma))./(sqrt(t)*sigma);% Quant 1
d2= (log(f./k)-(0.5*t*sigma.*sigma))./(sqrt(t)*sigma);% Quant 2

if cp==1
    y = f.*normcdf( d1,0,1)-k.*normcdf( d2,0,1);      % call price
else
    y = k.*normcdf(-d2,0,1)-f.*normcdf(-d1,0,1);      % put price
end
end