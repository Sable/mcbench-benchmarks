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



function fval = pmerton(XNew, XOld, t, vol,r, q,mj,volj,lambda)
% This function computes the transition probability in the Merton jump
% diffusion model;
% We assume an asset evolution given by S(t) = S(0) exp(M(t)) where M(t) is
% a junmp diffusion process. The compound Poisson part is given by a sum of
% lognormal distributed variables
    neval = 20;

    z = XNew - XOld - t * (r - q - lambda * (exp(mj+0.5*volj^2)-1) ...
        - 0.5 * vol^2);

    fval = zeros(size(XNew));

    nvec = (0:neval)';
    fak = factorial(nvec);
    tmp1 = ((lambda * t).^nvec) ...
        ./ (fak .* sqrt(2 * pi * (nvec * volj^2 + t * vol^2)));
    tmp2 = (2 * (nvec * volj^2 + vol^2 * t));
    
    for i = 1:length(nvec)
        fval = fval + tmp1(i)*exp(-(z-nvec(i)*mj).^2/tmp2(i));
    end
    fval = exp(-lambda * t) * fval;
end