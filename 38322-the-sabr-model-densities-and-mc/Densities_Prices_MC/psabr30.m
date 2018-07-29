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

function y = psabr30(t,T,f,F,alpha,A,beta,nu,rho)
% Wu expansion of SABR density (0th order)
tau = (T-t)/T;
if beta == 1    % account for log normal setting
    u = (log(f) - log(F))./(alpha * sqrt(T));
else
    u = (f^(1-beta)-F.^(1-beta))/(alpha*(1-beta)*sqrt(T));
end
v = log(alpha./A)./(nu*sqrt(T));
y = 1./(nu*T*F.^beta.*A.^2)./(2*pi*tau*sqrt(1-rho^2)) ...
    .*exp(-(u.^2-2*rho*u.*v+v.^2)/(2*tau*(1-rho^2)));
end