function y = uquan(x,B)
% y = UQUAN(X,B)
% Uniformly quantizes input vector x for given number of bits B.

% Author: Evan Ruzanski, 2/17/2003

format long; % Ensure double precision
 
delta = (max(x)-min(x))/(2^B-1); % Get step size

% Perform quantization 
xmin = min(x);
x2 = (x-xmin)/delta;
y2 = round(x2);
y3 = y2*delta;
y = y3 + xmin;



