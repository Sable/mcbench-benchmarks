function X = NewtonRaphson(X)

NoIter = 10 ;
% Run a loop for given number of iterations
for j=1:NoIter 
     % Governing equations
     f=[X(1)^3 - X(2); X(2)^3 - X(1)] ; 
     % Jacobian Matrix
     Jf=[3*X(1)^2 -1; -1 3*X(2)^2];   
     % Updating the root 
     X=X-Jf\f; 
end