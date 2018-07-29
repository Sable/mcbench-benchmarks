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

function phi = CharacteristicFunctionLib(model,u,lnS,T,r,d,varargin)
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
%---------------------------------------------------------

optAlfaCalculation = true;

ME1 = MException('VerifyInput:InvalidNrOfArguments',...
    'Invalid number of Input arguments');
ME2 = MException('VerifyInput:InvalidModel',...
    'Undefined Model');

if strcmp(model,'BlackScholes')
    if nargin == 7
        funobj = @Black_characteristicFn;
    else 
        throw(ME1)
    end
elseif strcmp(model,'Heston')
    if nargin == 11
        funobj = @Heston_characteristicFn;
    else 
        throw(ME1)
    end
elseif strcmp(model,'Merton')
    if nargin == 10
        funobj = @Merton_characteristicFn;
    else 
        throw(ME1)
    end
elseif strcmp(model,'Bates')
    if nargin == 14
        funobj = @Bates_characteristicFn;
    else 
        throw(ME1)
    end
elseif strcmp(model,'VarianceGamma')
    if nargin == 9
        funobj = @VG_characteristicFn;
    else 
        throw(ME1)
    end
elseif strcmp(model,'NIG')
    if nargin == 10
        funobj = @NIG_characteristicFn;
    else
        throw(ME1)
    end
elseif strcmp(model,'CGMY')
    if nargin == 10
        funobj = @CGMY_characteristicFn;
    else
        throw(ME1)
    end
elseif strcmp(model,'Meixner')
    if nargin == 9
        funobj = @Meixner_characteristicFn;
    else
        throw(ME1)
    end
elseif strcmp(model,'GH')
    if nargin == 10
        funobj = @GH_characteristicFn;
    else
        throw(ME1)
    end
elseif strcmp(model,'IntegratedCIR')
    if nargin == 13
        funobj = @VarianceGammaCIR_characteristicFn;
    else
        throw(ME1)
    end
elseif strcmp(model,'VarianceGammaOU')
    if nargin == 12
        funobj = @VarianceGammaOU_characteristicFn;
    else
        throw(ME1)
    end
else
    throw(ME2)
end

fval = feval(funobj,u,lnS,T,r,d,varargin{:});

if optAlfaCalculation == true
    phi = fval;
else
    phi = exp(fval);
end

end


%% Explicit Implementation of the characteristic Functions E[exp(iu*lnS_T)]
%-----------------------------------------------------------------------

% Black Scholes    
function phi = Black_characteristicFn(u,lnS,T,r,d,sigma)
    %phi = exp(i*u*(lnS+(r-d-0.5*sigma*sigma)*T) - 0.5*sigma*sigma*u.*u*T);
    phi = 1i*u*(lnS+(r-d-0.5*sigma*sigma)*T) - 0.5*sigma*sigma*u.*u*T;
end

% Merton Jump Diffusion
function phi = Merton_characteristicFn(u,lnS,T,r,d,sigma,a,b,lambda)
    phi = Black_characteristicFn(u,lnS,T,r,d,sigma) + LogNormalJump_characteristicFn(u,a,b,lambda,T);
end

% Heston
function phi = Heston_characteristicFn(u,lnS,T,r,d,V0,theta,kappa,omega,rho)
    
alfa = -0.5*(u.*u + u*1i);
beta = kappa - rho*omega*u*1i;

omega2 = omega * omega;
gamma = 0.5 * omega2;

D = sqrt(beta .* beta - 4.0 * alfa .* gamma);

bD = beta - D;
eDt = exp(- D * T);


G = bD ./ (beta + D);
B = (bD ./ omega2) .* ((1.0 - eDt) ./ (1.0 - G .* eDt));
psi = (G .* eDt - 1.0) ./(G - 1.0);
A = ((kappa * theta) / (omega2)) * (bD * T - 2.0 * log(psi));


phi = A + B*V0 + 1i*u*(lnS+(r-d)*T);

end
    
% Bates
function phi = Bates_characteristicFn(u,lnS,T,r,d,V0,theta,kappa,omega,rho,a,b,lambda)
    phiHes = Heston_characteristicFn(u,lnS,T,r,d,V0,theta,kappa,omega,rho);
    phi = phiHes + LogNormalJump_characteristicFn(u,a,b,lambda,T); 
end

% LogNormalJump for Merton and Bates
function phiJump = LogNormalJump_characteristicFn(u,a,b,lambda,T)
    %phiJump = exp(lambda*T*(-a*u*i + (exp(u*i*log(1.0+a)+0.5*b*b*u*i.*(u*i-1.0))-1.0)));
    phiJump = lambda*T*(-a*u*1i + (exp(u*1i*log(1.0+a)+0.5*b*b*u*1i.*(u*1i-1.0))-1.0));
end

% Variance Gamma
function phi = VG_characteristicFn(u,lnS,T,r,d,sigma,nu,theta)
    omega = (1/nu)*( log(1-theta*nu-sigma*sigma*nu/2) );
    tmp = 1 - 1i * theta * nu * u + 0.5 * sigma * sigma * u .* u * nu;
    %tmp = tmp.^(-T / nu);
    %phi = exp( i * u * (lnS + (r + omega - d) * T )) .* tmp;
    phi = 1i * u * (lnS + (r + omega - d) * T ) - T*log(tmp)/nu;

end

% Normal Inverse Gaussian
function phi = NIG_characteristicFn(u,lnS,T,r,d,alfa,beta,mu,delta)
    m = delta*(sqrt(alfa*alfa-(beta+1)^2)-sqrt(alfa*alfa-beta*beta));
    %tmp = exp(i*u*mu*T-delta*T*(sqrt(alfa*alfa-(beta+i*u).^2)-sqrt(alfa*alfa-beta*beta)));
    %phi = exp( i*u*(lnS + (r-d+m)*T)).*tmp;
    tmp = 1i*u*mu*T-delta*T*(sqrt(alfa*alfa-(beta+1i*u).^2)-sqrt(alfa*alfa-beta*beta));
    phi = 1i*u*(lnS + (r-d+m)*T) + tmp;
end

% Meixner
function phi = Meixner_characteristicFn(u,lnS,T,r,d,alfa,beta,delta)
    m = -2*delta*(log(cos(0.5*beta)) - log(cos((alfa+beta)/2)));
    tmp = (cos(0.5*beta)./cosh(0.5*(alfa*u-1i*beta))).^(2*T*delta);
    %phi = exp( i*u*(lnS + (r-d+m)*T)).*tmp;
    phi = 1i*u*(lnS + (r-d+m)*T) + log(tmp);
end

% Generalized Hyperbolic
function phi = GH_characteristicFn(u,lnS,T,r,d,alfa,beta,delta,nu)
    arg1 = alfa*alfa-beta*beta;
    arg2 = arg1-2*1i*u*beta + u.*u;
    argm = arg1-2*beta-1;
    m = -log((arg1./argm).^(0.5*nu).*besselk(nu,delta*sqrt(argm))./besselk(nu,delta*sqrt(arg1)));
    tmp = (arg1./arg2).^(0.5*nu).*besselk(nu,delta*sqrt(arg2))./besselk(nu,delta*sqrt(arg1));
    %phi = exp( i*u*(lnS + (r-d+m)*T)).*tmp.^T;
    phi = 1i*u*(lnS + (r-d+m)*T) + log(tmp).*T;
end

% CGMY
function phi = CGMY_characteristicFn(u,lnS,T,r,d,C,G,M,Y)
    m = -C*gamma(-Y)*((M-1)^Y-M^Y+(G+1)^Y-G^Y);
    %tmp = exp(C*T*gamma(-Y)*((M-i*u).^Y-M^Y+(G+i*u).^Y-G^Y));
    %phi = exp( i*u*(lnS + (r-d+m)*T)).*tmp;
    tmp = C*T*gamma(-Y)*((M-1i*u).^Y-M^Y+(G+1i*u).^Y-G^Y);
    phi = 1i*u*(lnS + (r-d+m)*T) + tmp;
end

%function phi = IntegratedCIR_characteristicFn(u,lnS,T,r,d,sigma,nu,theta,kappa,eta,lambda,y0)

%v1 = i*log(1 - i * theta * nu * u + 0.5 * sigma * sigma * u .* u * nu)/nu;
%v2 = i*log(1 - i * theta * nu *(-i) + 0.5 * sigma * sigma * (-i) .* (-i) * nu)/nu;

function phi = VarianceGammaCIR_characteristicFn(u,lnS,T,r,d,C,G,M,kappa,eta,lambda,y0)

v1 = -1i*C*(log(G*M)-log(G*M+(M-G)*1i*u + u.*u));
v2 = -1i*C*(log(G*M)-log(G*M+(M-G)*1i*(-1i) + (-1i).*(-1i)));


gamma1 = sqrt(kappa^2 - 2*lambda^2*1i*v1);
gamma2 = sqrt(kappa^2 - 2*lambda^2*1i*v2);
phi1 = kappa^2*eta*T/lambda^2 + 2*y0*1i*v1 ./ (kappa + gamma1.*coth(0.5*gamma1*T))...
    - 2*kappa*eta/lambda^2*log(cosh(0.5*gamma1*T) + kappa*sinh(0.5*gamma1*T)./gamma1);
phi2 = kappa^2*eta*T/lambda^2 + 2*y0*1i*v2 / (kappa + gamma2*coth(0.5*gamma2*T))...
    - 2*kappa*eta/lambda^2*log(cosh(0.5*gamma2*T) + kappa*sinh(0.5*gamma2*T)/gamma2);

%gam = sqrt(kappa^2-2*lambda^2);
m = 0;%- (kappa^2*eta*T/lambda^2 + 2*y0/(kappa+gam*coth(gam*T/2))) + 2*kappa*eta/lambda^2*log(cosh(gam*T/2)+kappa*sinh(gam*T/2)/gam);
phi = 1i*u*(lnS + (r-d+m)*T) + phi1 - 1i*u*phi2;%0.5*(log(phi1.^2) - i*u*log(phi2.^2));

end

function phi = VarianceGammaOU_characteristicFn(u,lnS,T,r,d,C,G,M,lambda,a,b)
    psiX1 = (-1i)*log((G*M./(G*M+(M-G)*1i*u+u.*u)).^C);
    psiX2 = (-1i)*log((G*M/(G*M+(M-G)-1)).^C);    
    phiCIR1 = 1i*psiX1*lambda^(-1)*(1-exp(-lambda*T)) + lambda*a./(1i*psiX1-lambda*b).*(b*log(b./(b-1i*psiX1*lambda^(-1)*(1-exp(-lambda*T))))-1i*psiX1*T);
    phiCIR2 = 1i*psiX2*lambda^(-1)*(1-exp(-lambda*T)) + lambda*a./(1i*psiX2-lambda*b).*(b*log(b./(b-1i*psiX2*lambda^(-1)*(1-exp(-lambda*T))))-1i*psiX2*T);
    phi = 1i*u*(lnS + (r-d)*T)+phiCIR1 - 1i*u.*phiCIR2;
end
