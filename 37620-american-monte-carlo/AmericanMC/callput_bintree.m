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



function y = callput_bintree(S, df, p, K, type)
% option pricing using a binomial tree based on cell arrays
n = size(S,2)-1;
v = cell(1, n);               % option value

if type == 0
    v{n} = max(K - S(:,end), 0); % payoff at t_N
else
    v{n} = max(S(:,end) - K, 0); % payoff at t_N
end

for i = n-1:-1:1
    expected_val = p * v{i+1}(1:end-1) * df ...
        + (1-p) * v{i+1}(2:end) * df;    % expected value of price
    index = v{i} < expected_val;        % early exercise or not
    v{i}(index) = expected_val(index);  % value at t_i
    
end

y = p * v{2}(1) * df + (1-p) * v{2}(2) * df;  