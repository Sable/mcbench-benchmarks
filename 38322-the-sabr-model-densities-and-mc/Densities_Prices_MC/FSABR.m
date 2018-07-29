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

function y = FSABR(ulimit, f)
% cumulative distribution of the SABR model using density f
% f = psabr, psabr1,...,psabr4
% psabr4 is our preferred form

n = length(ulimit);              % number of quantiles to determine
y = ones(1, n);                  % result vector
for j = 1:n
    if ulimit(j) < 0 
    % if the quantile is negative the integral is 0
    y(j) = 0;                                           
    else
    % integrate the density starting in 0 up to j-th quantile
        y(j) = real(max(min(quadv(f,0,ulimit(j)),1),0));    
    end
end
end