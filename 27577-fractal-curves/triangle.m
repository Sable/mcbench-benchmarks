function z = triangle(n)
%TRIANGLE Sierpinski Triangle Curve
%   Z = TRIANGLE(N) is a closed curve in the complex plane
%   with 2*3^N+2 points. N is a nonnegative integer. 
%
%   % Example
%   plot(triangle(6))

%   Author: Jonas Lundgren <splinefit@gmail.com> 2010

% Constants
a = (1 + sqrt(-3))/2;

% Generate point sequence
z = [0; 1];
for k = 1:n
    z = [z; z+a; z+1]/2;
end

% Close triangle
z = [z; a; 0];
