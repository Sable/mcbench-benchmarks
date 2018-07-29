function z = sierpinski(n)
%SIERPINSKI Sierpinski Cross Curve
%   Z = SIERPINSKI(N) is a closed curve in the complex plane
%   with 4^(N+1)+1 points. N is a nonnegative integer. 
%
%   % Example
%   plot(sierpinski(4)), axis equal

%   Author: Jonas Lundgren <splinefit@gmail.com> 2010

% Constants
a = 1 + 1i;
b = 1 - 1i;
c = 2 - sqrt(2);

% Generate point sequence
z = c;
for k = 1:n
    w = 1i*z;
    z = [z+b; w+b; a-w; z+a]/2;
end

% Close cross
z = [z; 1i*z; -z; -1i*z; z(1)];
