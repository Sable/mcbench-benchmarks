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

function [c,fc] = FInvSABR4_1(x, f)
% This function computes the inverse of a SABR cumulative distribution
% Since it is based on FSABR2 it is very fast and works for vectors!
f2 = @(t) (x - FSABR2_1(t,f));

% Use simple bisection
a = 0.00001 * ones(1,length(x)); % left starting points
b = 1*ones(1,length(x));        % right starting points

eps = 1e-3;                     % accuracy level
k = 0;                          % init iteration counter

c=(b+a)/2;
fc = f2(c);
% Ind = -eps <= fc & fc <= eps;
while(k <= 200)
    k = k+1;                            % increase iteration counter
%     if sum(Ind) == length(x)
%         break;
%     else
%         b(fc(Ind)<0) = 0.5*(b(fc(Ind)<0)+a(fc(Ind)<0));               % update right boundary
%         a(fc(Ind)>=0) = 0.5*(b(fc(Ind)>=0)+a(fc(Ind)>=0));            % update left boundary
%     end
%     c(Ind) = 0.5*(b(Ind)+a(Ind));
%     fc = f2(c);
%     Ind = -eps <= fc & fc <= eps;

    if( (-eps <= min(fc)) & (max(fc) <= eps))
        break;                          % end if all values have been found
    else
        b(fc<0) = 0.5*(b(fc<0)+a(fc<0));               % update right boundary
        a(fc>=0) = 0.5*(b(fc>=0)+a(fc>=0));            % update left boundary
    end
    c = 0.5*(b+a);
    fc = f2(c);                         % evaluate function at new c
end

end