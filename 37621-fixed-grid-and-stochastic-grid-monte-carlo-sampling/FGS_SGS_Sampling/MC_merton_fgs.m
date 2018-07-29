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



function y = MC_merton_fgs(S,r,sigma,T, ...
    a,b,lambda,NSim,Nt)
% Implements the FGS sampling for the Merton model
    
    nu = r - lambda*(exp(a+0.5*b^2)-1) - 0.5*sigma^2;       % adjustment
    dt = T/Nt;                              % dt
    X = log(S)*ones(NSim,1);                % X log price process

    for i = 1:Nt
        P = poissrnd(lambda*dt,NSim,1);    % randoms for jump part
        lnJ = a*P + b*sqrt(P)...
            .*randn(NSim,1);               % jump part
        X = X + nu*dt ...
            + sigma*sqrt(dt)*randn(NSim,1) ...
            + lnJ;                          % diff part + jump part                        
    end

    y = exp(X);                             % price process
end