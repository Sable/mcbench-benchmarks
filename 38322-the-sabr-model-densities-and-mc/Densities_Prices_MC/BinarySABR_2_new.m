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

function [value] = BinarySABR_2_new(f, k, t, sigma, disc)
% the value of a digital option within a SABR model
    d1 = 1./(sigma .* sqrt(t)).*(log(f./k)+0.5*sigma.^2*t);
    d2 = 1./(sigma .* sqrt(t)).*(log(f./k)-0.5*sigma.^2*t);
    binary = disc * normcdf(d2,0,1);
    vega = f * disc * normpdf(d1,0,1) * sqrt(t);
    epsilon = 1e-004;
    skew = ((sigma + epsilon) - (sigma - epsilon))/(2*epsilon);
    value = binary - skew .* vega;
    value(k==0.0001)=1;
end