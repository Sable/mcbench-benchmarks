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

function y = svol_flat(a, b, r, n, f, k, t,low,high)
% computes the sabr implied BS volatility using flat extrapolation

klow = low*f; khigh = high*f;           % calculate cut off levels

y = svol_2(a,b,r,n,f,k,t);              % standard SABR
y(k<klow) = svol_2(a,b,r,n,f,klow,t);   % const value at klow
y(k>khigh) = svol_2(a,b,r,n,f,khigh,t); % const value at khigh
end
