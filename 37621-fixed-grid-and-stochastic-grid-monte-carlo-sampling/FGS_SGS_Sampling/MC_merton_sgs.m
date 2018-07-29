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



function y = MC_merton_sgs(S,r,sigma,T, a,b,lambda,NSim)
%Implements the SGS method for the Merton model
nu = r - lambda*(exp(a+0.5*b^2)-1)-0.5*sigma^2; % martingale correction

X = log(S)*ones(NSim,1);          % X is the log price path

for k=1:NSim
    t = 0;
    tau = [];
    %simulate the jump times first
    while t < T
        dt = -log(rand)/lambda;% jump time
        t = t + dt;            % add the jump times
        tau = [tau; dt];             % not good matlab but works!
    end
    tau(end) = T-(t-dt);
    N = length(tau);                    % N number of jumps + 1
    W1 = randn(1,N);                    % uniforms for diffusion
    if N > 1
        W2 = randn(1,N-1);              % uniforms for jumps
        for i = 1:N-1
            Z = nu*tau(i) + sigma*sqrt(tau(i)) * W1(i);
            lnY = a+b*W2(i);                                                              
            X(k) = X(k) + Z + lnY;
        end
    end
    
    dt_end = tau(end);
    Z = nu * dt_end + sigma * sqrt(dt_end) * W1(end);
    X(k) = X(k) + Z;
end
y = exp(X);
end

