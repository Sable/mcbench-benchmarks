function z = dragon(n)
%DRAGON Dragon Curve
%   Z = DRAGON(N) is a continuous curve in the complex plane
%   with 2^(N+1) points. N is a nonnegative integer. 
%
%   % Example
%   z = dragon(12);
%   figure(1), plot(z), axis equal
%   figure(2), plot(reshape(z,[],4)), axis equal

%   Author: Jonas Lundgren <splinefit@gmail.com> 2010

% Constants
a = (1 + 1i)/2;
b = (1 - 1i)/2;
c = sqrt(1/2);

% Generate point sequence
z = [1-c; c];
for k = 1:n
    w = z(end:-1:1);
    z = [a*z; 1-b*w];
end
