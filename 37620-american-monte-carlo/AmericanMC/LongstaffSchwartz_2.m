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



function [price, se, low, high] ...
    = LongstaffSchwartz_2(S, g, df, B, f, Nr, NSim, level)

v = g(:,end);   % start for backward induction

% backward induction and regression from t_{Nr-1} up to t_1
for i = Nr-1:-1:1
        index = find(g(:,i) > 0); % all ITM paths
        s = S(index,i+1);         % values of S at given time point 
        v = v * df(i+1);          % option value at t_i

        Acell = B(s);             % evaluate basis function in cell array B 
        A = cell2mat(Acell{:,:}); % convert to matrix
    
        c = A*f(:,i);                  % continuation value

        exercise = g(index,i) >= c;    % early exercise
        v(index(exercise)) = g(index(exercise),i);
end

price = mean(v * df(1));    % final option value

% standard error and confidence interval
sv = sqrt(1/(NSim-1)*sum((v - price * ones(NSim,1)).^2));
se = sv/sqrt(NSim);
low =  price - norminv(level) * sv/sqrt(NSim);
high = price + norminv(level) * sv/sqrt(NSim);

end