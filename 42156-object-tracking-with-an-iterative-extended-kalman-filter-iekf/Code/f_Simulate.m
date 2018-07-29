% function to simulate the dynamic model
% Input:
%  xint  = [xc xcd zc zcd p1 p2 w].' - initial state variable
%  n = number of steps to simulate
% Ouput:
%  X = matrix of all state variables
function X = f_Simulate(xint,n)

% x  = [xc xcd zc zcd p1 p2 w].'

load avar % r1,r2, L, and T

F = [1 T 0 0 0 0 0;
     0 1 0 0 0 0 0;
     0 0 1 T 0 0 0;
     0 0 0 1 0 0 0;
     0 0 0 0 1 0 T;
     0 0 0 0 0 1 T;
     0 0 0 0 0 0 1];  % state transition matrix

% initialize
X = zeros(7,n);

% first state is the supplied initial state
X(:,1) = xint;

for i=2:n;
    X(:,i) = F*X(:,i-1);
end



