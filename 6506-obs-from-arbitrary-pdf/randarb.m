function f = randarb(x,y)
% RANDARB generates a random observation from any arbitrary PDF defined by x,y
% function f = hfarbrand(x,y) x and y are vectors of length N that describe a PDF
% to some precision implicitly dictated by the size of N.  Fhe returned scalar f
% is an observation from the set of x with a probability of (x/y(x))/sum(y)

%% Sanity checks
if nargin ~= 2
    error('Two input vectors are required');
end
if length(x) ~= length(y)
    error('x and y must be of the same length');
end
if length(x) < 30
    warning('The size of x and y is very low');
end

%% Compute a uniform random number between 0 and sum(y)
randx = sum(y)*rand();

%% Find where the number lies on a conceptual line comprised of "segments" of
% length y
i = 1;
while sum(y(1:i)) < randx
    i = i + 1;
end

%% Return the x value corresponding to the y value we "landed on."
f = x(i);