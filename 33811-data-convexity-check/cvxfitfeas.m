function [check,maxerr,yfit] = cvxfitfeas(U,y,err)

% Checks if a data set can be approximated with a convex function subject
% to a maximum residual constraint.
%
% Notation:
%
% U - matrix of input data points, with rows denoting the different points
% y - outputs corresponding to the inputs (row vector)
% err - maximum allowable residual
% check - returns 1 if it is possible to fit function, 0 otherwise
% maxerr - maximum residual of convex fit
% yfit - output values defining the fit

m = length(y);
n = length(U(1,:));

A1 = [-eye(m) zeros(m,m*n) -ones(m,1);
    eye(m) zeros(m,m*n) -ones(m,1)];
b1 = [-y'; y'];

A2 = zeros(m*(m-1),m+m*n+1);
lc = 1;
for i = 1:m
    for j = 1:m
        if i ~= j
            A2(lc,i) = 1;
            A2(lc,j) = -1;
            A2(lc,[1+m+(i-1)*n:m+i*n]) = U(j,:)-U(i,:);
            lc = lc + 1;
        end
    end
end

b2 = zeros(m*(m-1),1);

A = [A1;A2];
b = [b1;b2];

[xopt,maxerr,exit] = linprog([zeros(1,m+m*n) 1],A,b,[],[],[],[],[],optimset('disp','iter'));
if exit <= 0
    disp('Warning - Optimization did not terminate property.');
end
yfit = xopt(1:m);

if maxerr <= err 
    check = 1;
else
    check = 0;
end

end