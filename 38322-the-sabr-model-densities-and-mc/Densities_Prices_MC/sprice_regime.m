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

function y = sprice_regime(a, b, r, n, f, k, t,low,high,cp)
% computes prices using regimes of vol of vol this can be some function 
% used to extrapolate the volatility

sigma = svol_regime(a,b,r,n,f,k,t,low,high);    % SABR implied BS vol

d1= (log(f./k)+(0.5*t*sigma.*sigma))./(sqrt(t)*sigma); % d1 with sabr vol
d2= (log(f./k)-(0.5*t*sigma.*sigma))./(sqrt(t)*sigma); % d2 with sabr vol

if cp==1    % Call
    y = f.*normcdf( d1,0,1)-k.*normcdf( d2,0,1);
else        % Put
    y = k.*normcdf(-d2,0,1)-f.*normcdf(-d1,0,1);
end
                                                 % output
end