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



function phi = cf_nigcir(u,T,t_star,r,d,alpha, beta, delta, ...
    lambda, kappa, eta)
% characteristic function for the NIG CIR model
y0 = 1;

psiX_u = (-1i) * (-delta)*(sqrt(alpha^2-(beta+1i*u).^2) ...
    -sqrt(alpha^2-beta^2));
psiX_i = (-1i) * (-delta)*(sqrt(alpha^2-(beta+1)^2) ...
    -sqrt(alpha^2-beta^2));

gamma_u = sqrt(kappa^2-2*lambda^2*1i*psiX_u); 
gamma_i = sqrt(kappa^2-2*lambda^2*1i*psiX_i); 

f2_u = (kappa^2*eta*(T-t_star)/(lambda^2)) ...
    - log(cosh(0.5*gamma_u*diag(T-t_star)) ...
    +kappa*sinh(0.5*gamma_u*diag(T-t_star))./gamma_u) ...
    *(2*kappa*eta*lambda^(-2));
f3_u = 2*psiX_u./(kappa+gamma_u.*coth(gamma_u*diag(T-t_star)/2));

f1_u = f2_u + log(1-0.5*1i*f3_u*lambda^2/kappa*(1-exp(-kappa*t_star))) ...
    *(-2*kappa*eta*lambda^(-2)) ...
    + 1i*f3_u*y0*exp(-kappa*t_star)./(1-0.5*1i*f3_u*lambda^2/kappa ...
    *(1-exp(-kappa*t_star)));

phi_T = kappa^2*eta*T*lambda^(-2) ...
    + 2*y0*1i*psiX_i ./(kappa+gamma_i*coth(gamma_i*T/2)) ...
        -log( cosh(0.5*gamma_i*T) ...
        + kappa*sinh(0.5*gamma_i*T)/gamma_i )*(2*kappa*eta/lambda^2);
phi_tstar = kappa^2*eta*t_star*lambda^(-2)  ...
    + 2*y0*1i*psiX_i/(kappa+gamma_i*coth(gamma_i*t_star/2)) ...
        -log( cosh(0.5*gamma_i*t_star) ...
        + kappa*sinh(0.5*gamma_i*t_star)/gamma_i )*(2*kappa*eta/lambda^2);

phi = exp(1i*u*diag((r-d).*(T-t_star)-(phi_T - phi_tstar)) + f1_u);

end

