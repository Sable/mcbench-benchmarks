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



function [Optionspreis] = BlackScholesPrice(S,K,r,T,sigma,type)
% calculates the black scholes price using matrices
    matS = repmat(S,1,length(T));   % S matrix
    matT = repmat(T',length(S),1);  % T matrix

    d1=(log(matS./K)+(r+sigma^2/2)*matT)./(sigma*sqrt(matT));
    d2=(log(matS./K)+(r-sigma^2/2)*matT)./(sigma*sqrt(matT));
    
    if type==0
        Optionspreis = K*exp(-r*matT).*normcdf(-d2)-matS.*normcdf(-d1);
    else
        Optionspreis = matS.*normcdf(d1)-K*exp(-r*matT).*normcdf(d2);
    end

end