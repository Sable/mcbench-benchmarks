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



function y = pdd(t,K,S0,sigma,a)
% probability density for the displaced diffusion model based on the
% the lognormal density
    Sa= S0/a; sigmaa = sigma * a; Ka = K +(1-a)/a*S0;
    
    y = plng(Ka,Sa, t, 0, 0, sigmaa);
    
% based on call pricing and finite differencing
%    eps = 1e-004;
%    y1 = blsprice(Sa, Ka+eps, 0, t, sigmaa, 0);
%    y2 = blsprice(Sa, Ka, 0, t, sigmaa, 0);
%    y3 = blsprice(Sa, Ka-eps, 0, t, sigmaa, 0);
%    y = (y1-2*y2+y3)/eps^2;
end