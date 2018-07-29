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



function y = barrier_bintree(S, df, p, K, Barrier, type)
% prices an american barrier option using a binomial tree
n = size(S,2)-1;
v = cell(1, n+1);                               % option value

if type == 0
    index = @(mval,x) mval > Barrier * ones(2^x,1);
    payoff = @(x) max(x- K,0);
    m_val = max(S,[],2);
else
    index = @(mval,x) mval < Barrier * ones(2^x,1);
    payoff = @(x) max(K-x,0);
    m_val = min(S,[],2);
end

v{n+1} = index(m_val,n) .* payoff(S(:,end));

iVec = 1:length(S);
for i = n:-1:2
    iVec = iVec(1:length(iVec)/2) * 2;
    
    if type == 0 
        m_val = max(S(iVec,1:i),[], 2);
    else
        m_val = min(S(iVec,1:i),[], 2);
    end
    Jset = 1:2:2^i;
    expected_val = p * v{i+1}(Jset) ...
        + (1-p) * v{i+1}(1+Jset) * df;           % cont value
    
    v{i} = index(m_val,i-1) .* payoff(S(iVec,i));% current opt value    
    v{i}=max(v{i}, expected_val);                % option value at t_i
       
end

y = p * v{2}(1) * df + (1-p) * v{2}(2) * df;      % option value at t_0
end