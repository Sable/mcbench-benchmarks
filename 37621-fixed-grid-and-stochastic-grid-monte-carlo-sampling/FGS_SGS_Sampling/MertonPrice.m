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



function [call,put] = MertonPrice(Spot,Strike,sigma,r,T,a,b,lambda,n_max)

if T == 0         % Expired options.
    call = max(Spot - Strike, 0);
    put = max(Strike - Spot, 0);

elseif Spot == 0
    call = 0;                % Worthless calls.
    put = Strike*exp(-r*T);
    
elseif Strike == 0
    call = S;
    put  = 0;                % Worthless puts.
else
    m = exp(a+0.5*b^2)-1;
    nvec = (0:n_max)';
    fakul = [1;factorial(nvec(2:end))];

    lam = lambda*(1+m);
    arg = lam*T;
    sigma_n = sqrt(sigma*sigma + b*b*nvec/T);
    r_n = r-lambda*m+nvec*log(1+m)/T;

    d1 = (log(Spot/Strike)+(r_n + 0.5*sigma_n.*sigma_n)*T)./(sigma_n*sqrt(T));
    d2 = d1 - sigma_n*sqrt(T);

    call = exp(-arg)*sum(arg.^nvec./fakul.*(Spot*normcdf(d1)-Strike*exp(-r_n*T).*normcdf(d2)));
    put = exp(-arg)*sum(arg.^nvec./fakul.*(Strike*exp(-r_n*T).*normcdf(-d2)-Spot*normcdf(-d1)));
end