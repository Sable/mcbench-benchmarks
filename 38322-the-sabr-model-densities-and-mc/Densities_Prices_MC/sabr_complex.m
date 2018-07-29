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

function y = sabr_complex(f,k,T,alpha,beta,rho,nu)
% sabr price based on the complex Black-Scholes formula
% from a paper by Benhamou et al.

    f0 = k; % projected fwd as suggested by Benhamou et al. makes z0=0
    z = (f^(1-beta) - k.^(1-beta))./(alpha * (1-beta));
    z0 = (f0.^(1-beta) - k.^(1-beta))/(alpha * (1-beta));

    x = log((-rho + nu*z+sqrt(1-2*nu*rho*z+nu^2*z.^2))./(1-rho))/nu;
    b1 = beta ./(alpha * (1-beta) * z0 + k.^(1-beta));
    
    theta = 0.25 * rho*nu*alpha*b1.*z.^2 ...
        + log(alpha*(f*k).^(0.5*beta).*z./(f-k)) ...
        + log(x./z.*(1-2*nu*rho*z+nu^2*z.^2).^0.25);
    
    kappa = 0.125 .* (alpha^2*(beta-2)*beta*k.^(2*beta) ...
        ./(k-alpha*(beta-1)*k.^beta.*z0).^2 ...
        + 6*alpha*beta*k.^beta*nu*rho./(k-alpha*(beta-1)*k.^beta.*z0) ...
        + nu^2*(2-3*rho^2+2*nu*rho*z0-nu^2*z0.^2) ...
        ./(1-2*nu*rho*z0+nu^2*z0.^2));
        
    integral = sqrt(pi)./(2i*sqrt(kappa))...
        .*(exp( 1i * sqrt(2)* x.* sqrt(kappa)) ...
        .*(erfcomplex(x/sqrt(2*T)+1i*sqrt(kappa*T))-1) ...
        +  exp(-1i * sqrt(2)* x.* sqrt(kappa)) ...
        .*(erfcomplex(-x/sqrt(2*T)+1i*sqrt(kappa*T))+1));
    
    y = f-k+(f-k)./(2*x*sqrt(2*pi)).* real(exp(theta) .* integral);
end

