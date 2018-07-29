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



function y = CF(model,u,T,r,d,varargin)
%---------------------------------------------------------
% Characteristic Function Library of the following models:
%---------------------------------------------------------
% Black Scholes
% Merton Jump Diffusion
% Heston Stochastic Volatility Model
% Bates Stochastic Volatility / Jump Diffusion Model
% Variance Gamma
% Normal Inverse Gaussian
% Meixner
% Generalized Hyperbolic
% CGMY
% Variance Gamma with Gamma Ornstein Uhlenbeck clock
% Variance Gamma with CIR clock
% NIG with Gamma Ornstein Uhlenbeck clock
% NIG with CIR clock
%---------------------------------------------------------


optAlfaCalculation = true;

ME1 = MException('VerifyInput:InvalidNrOfArguments',...
    'Invalid number of Input arguments');
ME2 = MException('VerifyInput:InvalidModel',...
    'Undefined Model');

if strcmp(model,'BlackScholes')
    if nargin == 6
        funobj = @cf_bs;
    else 
        throw(ME1)
    end
elseif strcmp(model,'DDHeston')
    if nargin == 12
        funobj = @cf_ddheston;
    else 
        throw(ME1)
    end
elseif strcmp(model,'Heston')
    if nargin == 10
        funobj = @cf_heston;
    else 
        throw(ME1)
    end
elseif strcmp(model,'HestonHullWhite')
   if nargin == 13
       funobj = @cf_hestonhullwhite;
   else
       throw(ME1)
   end
elseif strcmp(model,'HHW')
   if nargin == 14
       funobj = @cf_hhw;
   else
       throw(ME1)
   end
elseif strcmp(model,'H1HW')
   if nargin == 14
       funobj = @cf_h1hw;
   else
       throw(ME1)
   end
elseif strcmp(model,'Merton')
    if nargin == 9
        funobj = @cf_merton;
    else 
        throw(ME1)
    end
elseif strcmp(model,'Bates')
    if nargin == 13
        funobj = @cf_bates;
    else 
        throw(ME1)
    end
elseif strcmp(model,'BatesHullWhite')
    if nargin == 16
        funobj = @cf_bateshullwhite;
    else 
        throw(ME1)
    end
elseif strcmp(model,'VarianceGamma')
    if nargin == 8
        funobj = @cf_vg;
    else 
        throw(ME1)
    end
elseif strcmp(model,'NIG')
    if nargin == 9
        funobj = @cf_nig;
    else
        throw(ME1)
    end
elseif strcmp(model,'CGMY')
    if nargin == 9
        funobj = @cf_cgmy;
    else
        throw(ME1)
    end
elseif strcmp(model,'Meixner')
    if nargin == 8
        funobj = @cf_meixner;
    else
        throw(ME1)
    end
elseif strcmp(model,'GH')
    if nargin == 9
        funobj = @cf_gh;
    else
        throw(ME1)
    end
elseif strcmp(model,'VarianceGammaCIR')
    if nargin == 11
        funobj = @cf_vg_cir;
    else
        throw(ME1)
    end
elseif strcmp(model,'VarianceGammaOU')
    if nargin == 11
        funobj = @cf_vg_gou;
    else
        throw(ME1)
    end
elseif strcmp(model,'NIGOU')
    if nargin == 11
        funobj = @cf_nig_gou;
    else
        throw(ME1)
    end
elseif strcmp(model,'NIGCIR')
    if nargin == 11
        funobj = @cf_nig_cir;
    else
        throw(ME1)
    end
else
    throw(ME2)
end

fval = feval(funobj,u,T,r,d,varargin{:});

if optAlfaCalculation == true
    y = fval;
else
    y = exp(fval);
end

end


%% Explicit Implementation of the characteristic Functions E[exp(iu*lnS_T)]
%-----------------------------------------------------------------------

% Black Scholes    
function y = cf_bs(u,T,r,d,sigma)
    y = 1i*u*((r-d-0.5*sigma*sigma)*T) - 0.5*sigma*sigma*u.*u*T;
end


function y = cf_merton(u,T,r,d,sigma,a,b,lambda)
% Merton Jump Diffusion
    y = cf_bs(u,T,r,d,sigma) ...
        + cf_jumplognormal(u,a,b,lambda,T);
end

function y = cf_ddheston(u,T,r,d,V0,theta,kappa,omega,rho,lambda,b)
% Displaced Diffusion Heston
U = 1i*u;
v = 0.5*(lambda*b)^2*1i*u.*(1i*u-1);
theta_star = kappa -rho*omega*lambda*b*U;
gamma = sqrt(theta_star.^2-2*omega^2*v);
Avu = kappa * theta / omega^2 *(2*log(2*gamma./(theta_star ...
    + gamma-exp(-gamma*T).*(theta_star-gamma)))+(theta_star-gamma)*T);
Bvu = 2*v.*(1-exp(-gamma*T))./((theta_star+gamma)...
    .*(1-exp(-gamma*T))+2*gamma.*exp(-gamma*T));

y = Avu + Bvu*V0 + 1i*u*((r-d)*T);
end

% Heston
function y = cf_heston(u,T,r,d,V0,theta,kappa,omega,rho)
    
alfa = -.5*(u.*u + u*1i);
beta = kappa - rho*omega*u*1i;
omega2 = omega * omega;
gamma = .5 * omega2;

D = sqrt(beta .* beta - 4.0 * alfa .* gamma);

bD = beta - D;
eDt = exp(- D * T);

G = bD ./ (beta + D);
B = (bD ./ omega2) .* ((1.0 - eDt) ./ (1.0 - G .* eDt));
psi = (G .* eDt - 1.0) ./(G - 1.0);
A = ((kappa * theta) / (omega2)) * (bD * T - 2.0 * log(psi));

y = A + B*V0 + 1i*u*((r-d)*T);

end

function y = cf_hhw(u,T,r,d,V0,theta,kappa,omega,lambda,eta,rho12,rho13,ircurve)
% Heston Hull White with % correlation(variance,rate) = 0
% dr(t) = lambda(r-r(t))dt + eta dW(t); r constant
    
    D1 = sqrt((omega*rho12*1i*u-kappa).^2-omega^2*1i*u.*(1i*u-1));
    g = (kappa-omega*rho12*1i*u-D1)./(kappa-omega*rho12*1i*u+D1);
    
    a = sqrt(theta - .125 * omega^2/kappa);
    b = sqrt(V0) - a;
    ct=.25*omega^2*(1-exp(-kappa))/kappa;
    lambdat=4*kappa*V0*exp(-kappa)/(omega^2*(1-exp(-kappa)));
    d2=4*kappa*theta/omega^2;
    F1 = sqrt(ct*(lambdat-1)+ct*d2+ct*d2/(2*(d2+lambdat)));
    c = -log((F1-a)/b);
    
    I2 = kappa*theta/omega^2*(T*(kappa-omega*rho12*1i*u-D1)-2*log((1-g.*exp(-D1*T))./(1-g)));
    I3 = eta^2*(1i+u).^2/(4*lambda^3)*(3+exp(-2*lambda*T)-4*exp(-lambda*T)-2*lambda*T);
    I4 = -eta*rho13/lambda *(1i*u+u.^2)*(b/c*(1-exp(-c*T))+a*T+a/lambda*(exp(-lambda*T)-1)+b/(c-lambda)*exp(-c*T)*(1-exp(-T*(lambda-c))));
    
    % curve stuff
    date_T = add2date(ircurve.Settle,T);
    Theta = (1-1i*u) * (log(ircurve.getDiscountFactors(date_T))+eta^2/(2*lambda^3)*(T/lambda+2*(exp(-lambda*T)-1)-0.5*(exp(-2*lambda)-1)));
    
    A = I2+I3+I4+Theta;
    BV = (1-exp(-D1*T))./(omega^2.*(1-g.*exp(-D1*T))).*(kappa-omega*rho12*1i*u-D1);
    Br = (1i*u-1)/lambda*(1-exp(-lambda*T));
    
    y = A + 1i*u * ( (r-d)*T) + BV * V0  + Br * r0;
end


function y = cf_hullwhite(u,T,lambda,eta,ircurve)
% Hull White  
    %maturity dates
    date_t = add2date(ircurve.Settle,0);
    date_T = add2date(ircurve.Settle,T);
 
    %time to maturity
    tau_0_T = diag(yearfrac(ircurve.Settle,date_T));
    %CURRENTLY equals zero
    tau_0_t = diag(yearfrac(ircurve.Settle,date_t));
    %CURRENTLY equal tau_0_T
    tau_t_T = diag(yearfrac(date_t,date_T));
    
    %used for short rate and  instantaneous forward rate calculations
    Delta = 1e-6;
    P0_T = ircurve.getDiscountFactors(date_T);
    %CURRENTLY P(0,t) equals one since t = 0
    P0_t = 1.0;
    P0_t_plus_Delta = interp1([ircurve.Settle;ircurve.Dates],...
        [1.0;ircurve.Data],datenum(date_t+Delta),'linear');

    %CURRENTLY short rate = instantaneous forward rate
    %--------------------------------------------------
    %short rate
    instR = (1.0/P0_t_plus_Delta-1)/yearfrac(ircurve.Settle,datenum(date_t+Delta));
    %instantaneous forward rate
    instF = -(P0_t_plus_Delta - P0_t)/yearfrac(ircurve.Settle,datenum(date_t+Delta))./P0_t;
    
    %CURRENTLY not used
    %----------------------------------------------
    %dt = yearfrac(ircurve.Settle, ircurve.Dates);
    %fwd_dates = add2date(date_t,dt);
    %fwd_rates = ircurve.getForwardRates(fwd_dates);
    %P0_t_T = ircurve.getDiscountFactors(date_T)./ircurve.getDiscountFactors(date_t);
    %P0_t_T_plus_Delta = ircurve.getDiscountFactors(datenum(date_T+Delta))./ircurve.getDiscountFactors(datenum(date_t));
    %------------------------------------------------

    %auxiliary variables
    aux = eta*eta/lambda/lambda;
    sigma2_func = @(t)aux*(t + (exp(-lambda*t)...
        .*(2.0 - 0.5*exp(-lambda*t))-1.5)/lambda);
    B_t_T = (1.0-exp(-lambda*tau_t_T))/lambda;
    %CURRENTLY psi_t = instantaneous forward rate since tau_0_t = 0
    psi_t = instF + .5*aux*(1-exp(-lambda*tau_0_t)).^2;

    %variance of integrated short rate
    sigma2_R = feval(sigma2_func,tau_t_T);
    
    %mean of integrated short rate
    mu_R = B_t_T.*(instR - psi_t) + diag(log(P0_t./P0_T)) ...
        + 0.5*(feval(sigma2_func,tau_0_T) - feval(sigma2_func,tau_0_t));
    
    y = 1i*u*mu_R - 0.5*u.*u*sigma2_R;
end

function y = cf_hestonhullwhite(u,T,r,d,V0,theta,kappa,omega,rho,lambda,eta,ircurve)
% Heston Hull White with correlation(variance,rate)=correlation(asset,rate)=0
% dr(t) = lambda(curve-r(t))dt + eta dW(t); curve is intial term structure
y = cf_heston(u,T,0*r,d,V0,theta,kappa,omega,rho) ...
        + cf_hullwhite(u+1i,T,lambda,eta,ircurve);
end

function y = cf_h1hw(u,T,r,d,V0,theta,kappa,omega,lambda,eta,rho12,rho13,thetar)
% Heston Hull White with % correlation(variance,rate) = 0
% dr(t) = lambda(r-r(t))dt + eta dW(t); r constant
    
    D1 = sqrt((omega*rho12*1i*u-kappa).^2-omega^2*1i*u.*(1i*u-1));
    g = (kappa-omega*rho12*1i*u-D1)./(kappa-omega*rho12*1i*u+D1);
    
    a = sqrt(theta - .125 * omega^2/kappa);
    b = sqrt(V0) - a;
    ct=.25*omega^2*(1-exp(-kappa))/kappa;
    lambdat=4*kappa*V0*exp(-kappa)/(omega^2*(1-exp(-kappa)));
    d2=4*kappa*theta/omega^2;
    F1 = sqrt(ct*(lambdat-1)+ct*d2+ct*d2/(2*(d2+lambdat)));
    c = -log((F1-a)/b);
    
    I1 = thetar * (1i*u-1) * (T+(exp(-lambda * T)-1)/lambda);
    I2 = kappa*theta/omega^2*(T*(kappa-omega*rho12*1i*u-D1)-2*log((1-g.*exp(-D1*T))./(1-g)));
    I3 = eta^2*(1i+u).^2/(4*lambda^3)*(3+exp(-2*lambda*T)-4*exp(-lambda*T)-2*lambda*T);
    I4 = -eta*rho13/lambda *(1i*u+u.^2)*(b/c*(1-exp(-c*T))+a*T+a/lambda*(exp(-lambda*T)-1)+b/(c-lambda)*exp(-c*T)*(1-exp(-T*(lambda-c))));

    
    A = I1+I2+I3+I4;
    BV = (1-exp(-D1*T))./(omega^2.*(1-g.*exp(-D1*T))).*(kappa-omega*rho12*1i*u-D1);
    Br = (1i*u-1)/lambda*(1-exp(-lambda*T));
    
    y = A + 1i*u * ( (r-d)*T) + BV * V0  + Br * r0;
end

function y = cf_bates(u,T,r,d,V0,theta,kappa,omega,rho,a,b,lambda)
% Bates
    y = cf_heston(u,T,r,d,V0,theta,kappa,omega,rho)...
    + cf_jumplognormal(u,a,b,lambda,T);
end

function y = cf_bateshullwhite(u,T,r,d,V0,theta,kappa,omega,rho,a,b,lambda,lambda1,eta,ircurve)
% Bates Hull White
    y = cf_heston(u,T,r,d,V0,theta,kappa,omega,rho)...
        + cf_jumplognormal(u,a,b,lambda,T)...
        + cf_hullwhite(u+1i,T,lambda1,eta,ircurve);
end

function yJump = cf_jumplognormal(u,a,b,lambda,T)
% LogNormalJump for Merton and Bates
    yJump = lambda*T*(-a*u*1i + (exp(u*1i*log(1.0+a)+0.5*b*b*u*1i.*(u*1i-1.0))-1.0));
end

function y = cf_vg(u,T,r,d,sigma,nu,theta)
% Variance Gamma
    omega = (1/nu)*( log(1-theta*nu-sigma*sigma*nu/2) );
    tmp = 1 - 1i * theta * nu * u + 0.5 * sigma * sigma * u .* u * nu;
    y = 1i * u * ( (r + omega - d) * T ) - T*log(tmp)/nu;
end


function y = cf_nig(u,T,r,d,alfa,beta,mu,delta)
% Normal Inverse Gaussian
    m = delta*(sqrt(alfa*alfa-(beta+1)^2)-sqrt(alfa*alfa-beta*beta));
    tmp = 1i*u*mu*T-delta*T*(sqrt(alfa*alfa-(beta+1i*u).^2)...
        -sqrt(alfa*alfa-beta*beta));
    y = 1i*u*( (r-d+m)*T) + tmp;
end

% Meixner
function y = cf_meixner(u,T,r,d,alfa,beta,delta)
    m = -2*delta*(log(cos(0.5*beta)) - log(cos((alfa+beta)/2)));
    tmp = (cos(0.5*beta)./cosh(0.5*(alfa*u-1i*beta))).^(2*T*delta);
    y = 1i*u*( (r-d+m)*T) + log(tmp);
end

% Generalized Hyperbolic
function y = cf_gh(u,T,r,d,alfa,beta,delta,nu)
    arg1 = alfa*alfa-beta*beta;
    arg2 = arg1-2*1i*u*beta + u.*u;
    argm = arg1-2*beta-1;
    m = -log((arg1./argm).^(0.5*nu).*besselk(nu,delta*sqrt(argm))./besselk(nu,delta*sqrt(arg1)));
    tmp = (arg1./arg2).^(0.5*nu).*besselk(nu,delta*sqrt(arg2))./besselk(nu,delta*sqrt(arg1));
    y = 1i*u*( (r-d+m)*T) + log(tmp).*T;
end


function y = cf_cgmy(u,T,r,d,C,G,M,Y)
% CGMY
    m = -C*gamma(1-Y)*((M-1)^Y-M^Y+(G+1)^Y-G^Y);
    tmp = C*T*gamma(-Y)*((M-1i*u).^Y-M^Y+(G+1i*u).^Y-G^Y);
    y = 1i*u*( (r-d+m)*T) + tmp;
end

function y = cf_vg_cir(u,T,r,d,C,G,M,kappa,eta,lambda)
% VG CIR
y0 = 1;
v1 = -1i*C*(log(G*M)-log(G*M+(M-G)*1i*u + u.*u));
v2 = -1i*C*(log(G*M)-log(G*M+(M-G)*1i*(-1i) + (-1i).*(-1i)));


gamma1 = sqrt(kappa^2 - 2*lambda^2*1i*v1);
gamma2 = sqrt(kappa^2 - 2*lambda^2*1i*v2);
y1 = kappa^2*eta*T/lambda^2 + 2*y0*1i*v1 ...
    ./ (kappa + gamma1.*coth(0.5*gamma1*T))...
    - 2*kappa*eta/lambda^2*log(cosh(0.5*gamma1*T) ...
    + kappa*sinh(0.5*gamma1*T)./gamma1);
y2 = kappa^2*eta*T/lambda^2 + 2*y0*1i*v2 ...
    / (kappa + gamma2*coth(0.5*gamma2*T))...
    - 2*kappa*eta/lambda^2*log(cosh(0.5*gamma2*T) ...
    + kappa*sinh(0.5*gamma2*T)/gamma2);

y = 1i*u*( (r-d)*T) + y1 - 1i*u*y2;
end

function y = cf_vg_gou(u,T,r,d,C,G,M,lambda,a,b)
% VG GOU
    psiX1 = (-1i)*log((G*M./(G*M+(M-G)*1i*u+u.*u)).^C);
    psiX2 = (-1i)*log((G*M/(G*M+(M-G)-1)).^C);    
    y1 = 1i*psiX1*lambda^(-1)*(1-exp(-lambda*T)) ...
        + lambda*a./(1i*psiX1-lambda*b)...
        .*(b*log(b./(b-1i*psiX1*lambda^(-1)*(1-exp(-lambda*T))))-1i*psiX1*T);
    y2 = 1i*psiX2*lambda^(-1)*(1-exp(-lambda*T)) ...
        + lambda*a./(1i*psiX2-lambda*b).*(b*log(b./(b-1i*psiX2*lambda^(-1)....
        *(1-exp(-lambda*T))))-1i*psiX2*T);
    y = 1i*u*( (r-d)*T)+y1 - 1i*u.*y2;
end

function y = cf_nig_gou(u,T,r,d,alpha,beta,delta,lambda,a,b)
% NIG GOU
y0 = 1;

psiX_u = (-1i) * (-delta)*(sqrt(alpha^2-(beta+1i*u).^2)-sqrt(alpha^2-beta^2));
psiX_i = (-1i) * (-delta)*(sqrt(alpha^2-(beta+1)^2)-sqrt(alpha^2-beta^2));

f2_u = 1i*psiX_u*T*lambda*a./(lambda*b-1i*psiX_u) ...
    + a*b*lambda./(b*lambda-1i*psiX_u)...
    .*log(1 - 1i*psiX_u/(lambda*b)*(1-exp(-T*lambda)));
f3_u = 1/lambda*psiX_u*(1-exp(-lambda*T));

f1_u = f2_u + 1i*y0*f3_u + a*log((1-1i/b*f3_u)./(1-1i/b*f3_u));

y_T = 1i*psiX_i*y0*lambda^(-1)*(1-exp(-lambda*T)) ...
    + lambda*a./(1i*psiX_i-lambda*b)...
    .*(b*log(b./(b-1i*psiX_i*lambda^(-1)*(1-exp(-lambda*T))))-1i*psiX_i*T);

y = 1i*u*( (r-d).*T) - y_T + f1_u;

end


function y = cf_nig_cir(u,T,r,d,alpha,beta,delta,lambda,kappa,eta)
% NIG CIR
y0 = 1;

psiX_u = (-1i) * (-delta)*(sqrt(alpha^2-(beta+1i*u).^2)-sqrt(alpha^2-beta^2));
psiX_i = (-1i) * (-delta)*(sqrt(alpha^2-(beta+1)^2)-sqrt(alpha^2-beta^2));

gamma_u = sqrt(kappa^2-2*lambda^2*1i*psiX_u); 
gamma_i = sqrt(kappa^2-2*lambda^2*1i*psiX_i); 

f2_u = (kappa^2*eta*T/(lambda^2))'-log(cosh(0.5*gamma_u*T) ...
    +kappa*sinh(0.5*gamma_u*T)./gamma_u)*(2*kappa*eta*lambda^(-2));
f3_u = 2*psiX_u./(kappa+gamma_u.*coth(gamma_u*T/2));

f1_u = f2_u + 1i*f3_u*y0;

y_T = kappa^2*eta*T*lambda^(-2) ...
    + 2*y0*1i*psiX_i./(kappa+gamma_i*coth(gamma_i*T/2)) ...
        -log( cosh(0.5*gamma_i*T) + kappa*sinh(0.5*gamma_i*T)/gamma_i )...
        *(2*kappa*eta/lambda^2);

y = 1i*u*((r-d).*T)- y_T + f1_u;
end


