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



function y = BinTree_CP(S0, K, r, T, sigma, n, type)
% American call/put pricing using a binomial tree
% S0: Spot value
% K: Strike
% r: riskless rate
% T: Maturity
% sigma: volatility
% n: periods for tree
% type: 0 put, 1 call

dt = T / n;                             % length of one period
u = exp(sigma * sqrt(dt));              % up move
d = 1 / u;                              % down move
D = exp(-r * dt);                       % discount
p = (1/D - d) / (u - d);                % probability 

S{n} = S0 * u^n * d.^(0:2:2*n);

if type == 0 
   cp = 1;
else 
   cp = -1;            % payoff at t_N
end

v{n} = max(cp*(S{n}-K), 0);            % payoff at t_N

for i = n-1:-1:1
   
    S{i} = S0 * u.^i * d.^(0:2:2*i);
    v{i} = max(cp*(S{i}-K), 0);
    
    expected_val = p * v{i+1}(1:end-1) * D ...
        + (1-p) * v{i+1}(2:end) * D;    % expected value of price
    index = v{i} < expected_val;        % early exercise or not
    v{i}(index) = expected_val(index);  % value at t_i
    
end

y = p * v{1}(1) * D + (1-p) * v{1}(2) * D; % option value t_0

end
