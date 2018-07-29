function z = snowflake(n,a)
%SNOWFLAKE Koch Snowflake Curve
%   Z = SNOWFLAKE(N,A) is a closed curve in the complex plane
%   with 3*2^N+1 points. N is a nonnegative integer and A is a
%   complex number with |A| < 1 and |1-A| < 1.
%   Default is A = 1/2 + i*sqrt(3)/6.
%
%   % Examples
%   plot(snowflake(10)), axis equal
%   plot(snowflake(10,0.45+0.35i)), axis equal

%   Author: Jonas Lundgren <splinefit@gmail.com> 2010

if nargin < 1, n = 0; end
if nargin < 2, a = 1/2 + sqrt(-3)/6; end

% Constants
b = 1 - a;
c = 1/2 + sqrt(-3)/2;
d = 1 - c;

% Generate point sequence
z = 1;
for k = 1:n
    z = conj(z);
    z = [a*z; b*z+a];
end

% Close snowflake
z = [0; z; 1-c*z; 1-c-d*z];
