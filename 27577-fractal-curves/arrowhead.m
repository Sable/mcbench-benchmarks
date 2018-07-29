function z = arrowhead(n)
%ARROWHEAD Sierpinski Arrowhead Curve
%   Z = ARROWHEAD(N) is a continuous curve in the complex plane
%   with 3^N+1 points. N is a nonnegative integer. 
%
%   % Example
%   plot(arrowhead(7))

%   Author: Jonas Lundgren <splinefit@gmail.com> 2010

% Constants
a = (1 + sqrt(-3))/2;
b = (1 - sqrt(-3))/2;

% Generate point sequence
z = 0;
for k = 1:n
    w = conj(z);
    z = [a*w; z+a; b*w+a+1]/2;
end

% Add endpoint
z = [z; 1];
