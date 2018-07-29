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



function y = RegCoeff_M(S, M, Ns, g, df, B, Nb, Nr)
% Calculates the regression coefficiients

v = g(:,end);   % start for backward induction

f = zeros(Nb,Nr-1);

% backward induction and regression from t_{Nr-1} up to t_1
for i = Nr-1:-1:1
        index = find(g(:,i+1) > 0); % all ITM paths
        s = S(index,i+1);           % values of S at given time points
        m = M(index,i+1);           % values of M at given time points
        v = v * df(i+1);            % option value at t_i

        Acell = B(s,m);             % evaluate basis function in cell array B 
        A = cell2mat(Acell{:,:});   % convert to matrix
        
        f(:,i) = (A'*A)\(A'*v(index));  % determine coefficients
        c = A*f(:,i);                   % continuation value

        exercise = g(index,i+1) >= c;    % early exercise
        v(index(exercise)) = g(index(exercise),i+1);
end

y = f;

end