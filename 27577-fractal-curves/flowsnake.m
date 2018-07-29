function z = flowsnake(n)
%FLOWSNAKE Gosper Flowsnake Curve
%   Z = FLOWSNAKE(N) is a continuous curve in the complex plane
%   with 7^N+1 points. N is a nonnegative integer. 
%
%   % Example
%   plot(flowsnake(4)), axis equal

%   Author: Jonas Lundgren <splinefit@gmail.com> 2010

% Constants
a = (1 + sqrt(-3))/2;
b = (1 - sqrt(-3))/2;
c = [1; a; -b; -1; -a; b];

% Segment angles (divided by pi/3)
u = 0;
for k = 1:n
    v = u(end:-1:1);
    u = [u; v+1; v+3; u+2; u; u; v-1]; %#ok
end
u = mod(u,6);

% Points
z = cumsum(c(u+1));
z = [0; z/7^(n/2)];
