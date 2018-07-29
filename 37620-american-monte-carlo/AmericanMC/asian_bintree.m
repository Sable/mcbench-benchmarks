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



function y = asian_bintree(S, df, p, K, type)
% pricing an american asian option using a binomial tree
n = size(S,2)-1;
v = cell(1, n+1);               % option value

tmp = repmat(1:n, length(S), 1);
average_val = cumsum(S(:,2:end), 2) ./ tmp; % average value

if type == 0
   cp = 1;
else
    cp = -1;
end

v{n+1} = max(cp*(average_val(:,end)-K), 0); % payoff at t_N
    
iVec = 1:length(S);

for i = n:-1:2
    Jset = 1:2:2^i;
    expected_val = p * v{i+1}(Jset) * df ...
        + (1-p) * v{i+1}(1+Jset) * df;

    iVec = iVec(1:length(iVec)/2) * 2;
    
    v{i} = max(cp*(average_val(iVec,i-1)-K),0);   % payoff at t_i
    v{i}=max(v{i}, expected_val);                 % option value t_i    
end

y = p * v{2}(1) * df + (1-p) * v{2}(2) * df;      % option value t_0