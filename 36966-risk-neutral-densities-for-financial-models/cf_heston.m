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



function phi = cf_heston(u,vInst, vLong, kappa, omega, rho,t,r)
% charactersitic function for the heston model   
    beta = kappa - rho*omega*u*1i;
    omega2 = omega*omega;
    
    D = sqrt(beta.*beta - 4.0*(-1.0/2.0)*(u.*u+u*1i)*(1.0/2.0) * omega2);
    
    bD = beta-D;
    eDt = exp(-D * t);
    
    G = bD ./ (beta+D);
    B = (bD ./ omega2) .* ((1.0-eDt) ./ (1.0-G.*eDt));
    A = (kappa * vLong / omega2) ...
        *(bD*t-2.0*log((G .* eDt -1.0) ./ (G -1.0)));
    
    phi = exp(A+B*vInst+1i*u*r.*t);
end
