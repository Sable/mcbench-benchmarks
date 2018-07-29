function [xLB, xUB] = subIntervals(x)

n = length(x);
xMesh = NaN(n + 1, 1);
xMesh(1)     = x(1);
xMesh(n + 1) = x(n);
xMesh(2:n)   = x(2:n) - 0.5 * (x(2:n) - x(1:n-1));

% cadlag mesh 
xUB = xMesh(2:end) - 2.2e-308; % right
xLB = xMesh(1:end-1); % left

end