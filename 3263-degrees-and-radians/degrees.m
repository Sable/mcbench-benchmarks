function degrees = degrees(radians)

% DEGREES (RADIANS)
%
% Conversion function from Radians to Degrees.
% Richard Medlock 12-03-2002
%
% Last Updated: 18-09-2009
% - Calculation simplified to make it more efficient
%   based on a suggestion by Joel Parker.

% Original calculation
% radians = radians/((2*pi)/360);



degrees = radians/(pi/180);