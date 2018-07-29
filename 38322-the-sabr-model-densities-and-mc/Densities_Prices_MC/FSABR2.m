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

function y = FSABR2(x, f)
% P(f<x) based on cumsum instead of integration
% makes it fast!
y = f(x);
y = cumsum(y) * (x(2)-x(1));
% n = length(x);
% y = zeros(1, n);
% epsilon= 0.0001;                % 1 bp step
% 
% for j = 1:n
%     xvalues = 0:epsilon:x(j);   % compute the density starting in 0 up to the quantile x stepping 1 bp
%     y1 = f(xvalues);  % collect the values
%     y(j) = min(1,epsilon * sum(y1));      % take the final value and multiply by 1 bp
% end
end