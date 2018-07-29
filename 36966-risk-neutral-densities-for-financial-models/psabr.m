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



function y = psabr(t,T,f,F,alpha,A,beta,nu,rho)
% approximation of the prob distribution of th SABR model
% see the SABR files for more on the distribution and the chaps
% in the book

% t - current time
% T - maturity
% f - current forward
% F - final forward
% alpha - Inital volatility
% A - Final volatility
% beta - CEV parameter of SABR model
% nu - vol of vol
% rho - correlation BB forward and BB vol

tau = (T-t)/T;
u = (f^(1-beta)-F.^(1-beta))/(alpha*(1-beta)*sqrt(T));
v = log(alpha./A)./(nu*sqrt(T));

a11 = -beta * F.^(beta-1).*A./nu.*(u-rho*v);
a10 = u^2*v-rho*u*v.^2;

a = 2*rho+beta*F^(beta-1)*A./nu;
b = 2+beta*(1-beta)*F^(2*(beta-1))*A.^2./nu^2;
c = beta*F^(beta-1)*A./nu;

a23 = rho^4*(20-6*b)-12*rho^3*a+rho^2*(3*a.^2-28+12*b) ...
    +12*a*rho+8-3*a.^2-6*b;
a22 = u^2*(3*a.^2-12*a*rho+6*b*(-1+rho^2)+2*rho^2+10)...
    - 2*u*v.*(rho^3*(2+3*b)+rho^2*(-9*a+3*c)+rho*(10+3*a.^2-3*b) ...
    -(3*a+3*c))+ v.^2.*((2+3*(a-2*rho).^2)*rho^2+6*c*rho*(-1+rho^2)-2);
a21 = u^4+v.^4*rho^2+u^3*v.*(8*rho-6*a)+u*v.^3.*(8*rho^3-6*a*rho^2) ...
    +u^2*v.^2.*(-14*rho^2+12*a*rho-4);
a20 = 3*u^4*v.^2-6*u^3*v.^3*rho+3*u^2*v.^4*rho^2;
y = 1./(nu*T*F^beta*A.^2).*(1+nu*sqrt(T)./(2*(-1+rho^2)).*(a11+a10/tau) ...
    +(nu^2*T)./(24*(1-rho^2)^2).*(a23*tau+a22+a21/tau+a20/tau^2))...
    ./(2*pi*tau*sqrt(1-rho^2)) ...
    .*exp(-(u^2-2*rho*u*v+v.^2)./(2*tau*(1-rho^2)));
end
