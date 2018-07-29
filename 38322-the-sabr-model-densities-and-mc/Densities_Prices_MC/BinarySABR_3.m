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

function [value] = BinarySABR_3(f, k, t, a, b, r, n)
% the value of a digital option within a SABR model
    epsilon = 1e-004;
    kp = k + epsilon;
    km = k - epsilon;
    sigmap = svol_2(a,b,r,n,f,kp,t);
    sigmam = svol_2(a,b,r,n,f,km,t);
    d1p = 1./(sigmap .* sqrt(t)).*(log(f./kp)+0.5*sigmap.^2*t);
    d2p = 1./(sigmap .* sqrt(t)).*(log(f./kp)-0.5*sigmap.^2*t);
    d1m = 1./(sigmam .* sqrt(t)).*(log(f./km)+0.5*sigmam.^2*t);
    d2m = 1./(sigmam .* sqrt(t)).*(log(f./km)-0.5*sigmam.^2*t);
    pp = f * normcdf(d1p) - kp .* normcdf(d2p);
    pm = f * normcdf(d1m) - km.* normcdf(d2m);
    value = (pm-pp) / (2*epsilon);
end