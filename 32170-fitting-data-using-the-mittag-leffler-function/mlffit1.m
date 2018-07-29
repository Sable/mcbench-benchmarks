function [mlfcoeffs, R2] = mlffit1(XNodes, YDataPoints, mlfcoeffs0, Precision)
% 
% Fitting data [XNodes, YDataPoints] by one-parameter Mittag-Leffler function 
% y(t) = c*E_{alpha}(a*t^alpha)
% 
% Output:   mlfcoeffs(1) = alpha
%           mlfcoeffs(2) = beta
%           mlfcoeffs(3) = C
%           mlfcoeffs(4) = a
% 
%           R2 = sum of squares of vertical offsets 
%                of the fitting curve from the data points
% 
% (C) Igor Podlubny, 2011


% The following is just one-time installation
% of the necessary packages 8738 and 31069
% from Matlab Central FIle Exchange (FEX)

% Check if the function 'mlf' from the FEX package 8738
% (for evaluation of the Mittag-Leffler function)
% is on your MATLAB path, and if it is not there, 
% require the FEX packages 31069 ("requireFEXpackage")
% and 8738 ("Mittag-Leffler function"):
if ~(exist('mlf', 'file') == 2)
    P = requireFEXpackage(31069); % "requireFEXpackage" 
    P = requireFEXpackage(8738);  % "Mittag-Leffler function"
end

% Also, the function 'fminsearchbnd' (FEX package 8277) is nedeed:
if ~(exist('fminsearchbnd', 'file') == 2)
    P = requireFEXpackage(8277);  % fminsearchbnd is part of 8277
end


% Now, we have MLF.M installed and can do the fitting

c = fminsearchbnd(@(Params) mlfparam(Params, XNodes, Precision, YDataPoints), mlfcoeffs0, ...
            [eps; 1; -Inf; -Inf], [Inf; 1; Inf; Inf]);

R2 = sum(c(3)*XNodes.^(c(2)-1).*(mlf(c(1), c(2), c(4)*XNodes.^c(1), Precision) - YDataPoints).^2); 
mlfcoeffs = c; 
end

function f = mlfparam(Params, XNodes, Precision, YDataPoints)
R2 =  sum((Params(3)* XNodes.^(Params(2)-1).*mlf(Params(1), 1, ...
        Params(4)*XNodes.^Params(1), Precision) - YDataPoints).^2);
f = R2;
end