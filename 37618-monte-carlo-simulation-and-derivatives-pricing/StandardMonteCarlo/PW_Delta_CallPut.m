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



function optval = PW_Delta_CallPut(S,K,C,r,T)
% S = NSim x 1 matrix of simulated prices
% K = Strike price
% C = 1 -> Call; C = 0 -> Put
    
    if(C==1)
        Indicator = (S(:,end)>K);
    else
        Indicator = (S(:,end)<=K);
    end
    optval = mean(S(:,end)./S(1,1).*Indicator)*exp(-r*T);
end