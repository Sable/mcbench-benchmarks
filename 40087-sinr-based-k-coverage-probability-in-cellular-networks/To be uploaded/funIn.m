% funIn calcualtes and returns the In integral (eq (12) in [1])
% In=funIn(betaConst,n,x)
% In = I_{n,\beta} integral (scalar) value
% betaConstant = path-loss exponent
% n = integer parameter
% x = variable that incorporates model parameters
% That is, x=W*a^(-2/betaConst) where a is given by eq (6) in [1]
% betaConst, n and x are scalars
%
% WARNING: for x>0 and high values of n (corresponding to low values of SINR
% threshold) the integration method can fail (returning NaN). This is due
% to a singularity in the integral kernel. A couple different change of variables
% have been tried with different (Matlab) quadratuture methods. The best
% performing combination has been chosen. No doubt better numerical methods
% exist (possibly combining an asymptotic expansion at a singularity).
%
% Author: H.P. Keeler, Inria Paris/ENS, 2013
%
% References
% [1] H.P. Keeler, B. Błaszczyszyn and M. Karray,
% 'SINR-based k-coverage probability in cellular networks with arbitrary
% shadowing', accepted at ISIT, 2013 



function In=funIn(betaConst,n,x)
% Calculates I_n with numerical integration or analytic solution (if x=0 (ie W=0))
% x <>0 uses quadgk (which can handle singularities)
% x=0 uses analytic solution

C=gamma(1+2./betaConst).*gamma(1-2./betaConst); %constant C';eq. (13) in [1] 
if x==0
    %analytic solution
    In=(2./betaConst).^(n-1)./C.^n; %eq. (14) in [1]
else
    %numerical solution        
    %***old integrals methods - left for different approaches***
    %original integral (12) in [1]
    %fu=@(u)(u).^(2*n-1).*exp(-u.^2-(u).^(betaConst).*x.*((gamma(1-2./betaConst)).^(-betaConst/2)));
    %In=2^n./betaConst.^(n-1).*quad(fu,0,10)./C.^n/factorial(n-1);        
    %integral (12) in [1] after change of variable t=exp(-u.^2) or
    %u=log(1./t).^(1/2)
    %ft=@(t)(-log(t)).^(n-1).*exp(-(-log(t)).^(betaConst/2).*x.*((gamma(1-2./betaConst)).^(-betaConst/2)))/2;
    %In=2^n./betaConst.^(n-1).*quadgk(ft,0,1)./C.^n/factorial(n-1);        
    
    %latest quadrature of (12) in [1] after change of variable
    %%%u=t./(1-t);
    ft=@(t)t.^(2*n-1).*(1./(1-t)).^(2*n+1).*exp(-(t./(1-t)).^2-(t./(1-t)).^(betaConst).*x.*((gamma(1-2./betaConst)).^(-betaConst/2)));
    In=2^n./betaConst.^(n-1).*quadgk(ft,0,1)./C.^n/factorial(n-1);      
    
end

