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



function phi = cf_nigou(u,T,t_star,r,d,alpha,beta,delta,lambda,a,b)
y0 = 1;

psiX_u = (-1i) * (-delta)*(sqrt(alpha^2-(beta+1i*u).^2) ...
    -sqrt(alpha^2-beta^2));
psiX_i = (-1i) * (-delta)*(sqrt(alpha^2-(beta+1)^2) ...
    -sqrt(alpha^2-beta^2));

f2_u = 1i*psiX_u*(T-t_star)*lambda*a./(lambda*b-1i*psiX_u) ...
        + a*b*lambda./(b*lambda-1i*psiX_u) ...
        .*log(1 - 1i*psiX_u/(lambda*b)*(1-exp(-(T-t_star)*lambda)));  
f3_u = 1/lambda*psiX_u*(1-exp(-lambda*(T-t_star)));

f1_u = f2_u + 1i*y0*exp(-lambda*t_star)*f3_u ...
    + a*log((1-1i/b*exp(-lambda*t_star)*f3_u)./(1-1i/b*f3_u));

phi_T = 1i*psiX_i*y0*lambda^(-1)*(1-exp(-lambda*T)) ...
   + lambda*a./(1i*psiX_i-lambda*b) ...
   .*(b*log(b./(b-1i*psiX_i*lambda^(-1)*(1-exp(-lambda*T))))-1i*psiX_i*T);  
phi_tstar = 1i*psiX_i*y0*lambda^(-1)*(1-exp(-lambda*t_star)) ...
   + lambda*a./(1i*psiX_i-lambda*b) ...
   .*(b*log(b./(b-1i*psiX_i*lambda^(-1)*(1-exp(-lambda*t_star)))) ...
   -1i*psiX_i*t_star); %phi_Z(t)(-i)

phi = exp(1i*u*((r-d).*(T-t_star)-(phi_T-phi_tstar)) + f1_u);
end
