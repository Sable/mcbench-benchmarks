function z = hilbert(n)
%HILBERT Hilbert Curve
%   Z = HILBERT(N) is a continuous curve in the complex plane
%   with 4^N points. N is a nonnegative integer.
%
%   % Example
%   plot(hilbert(5))

%   Author: Jonas Lundgren <splinefit@gmail.com> 2010

% Constants
a = 1 + 1i;
b = 1 - 1i;

% Generate point sequence
z = 0;
for k = 1:n
    w = 1i*conj(z);
    z = [w-a; z-b; z+a; b-w]/2;
end
