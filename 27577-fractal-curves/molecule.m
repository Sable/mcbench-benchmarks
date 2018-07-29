function z = molecule(n)
%MOLECULE Hexagon Molecule Curve
%   Z = MOLECULE(N) is a closed curve in the complex plane
%   with 6*3^N+1 points. N is a nonnegative integer.
%
%   % Example
%   plot(molecule(6)), axis equal

%   Author: Jonas Lundgren <splinefit@gmail.com> 2010

% Constants
a = (1 + sqrt(-3))/2;
b = (1 - sqrt(-3))/2;
c = [1; a; -b; -1; -a; b];

% Segment angles (divided by pi/3)
u = 0;
for k = 1:n
    u = [u+1; -u; u-1];
end
u = [u; 1-u; 2+u; 3-u; 4+u; 5-u];
u = mod(u,6);

% Points
z = cumsum(c(u+1));
z = [0; z/2^n];
