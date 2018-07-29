function f = jacobian(x, system)
%JACOBIAN Calculate the Cartesian to 'system' Jacobian for common
%         coordinate systems
%
% written by Lee Ferchoff, 2006
% E-mail: umferch1 at cc DOT umanitoba DOT ca
%
%   When performing an integral in an arbitrary coordinate system,
%   the integrand must be multiplied by the Jacobian for the coordinate
%   system transformation from rectangular Cartesian coordinates to the
%   system. This function returns the Jacobian in a form suitable for
%   use in function definitions to be integrated by mcint.
%
%INPUT
%
%   x(i,j) -- matrix of points. The ith coordinate of the jth point.
%   system -- string containing the coordinate system to be used in
%             integration. Available choices are:
%
%               'polar' -- 2D polar coordinates
%                   x(1,:) -- r
%                   x(2,:) -- phi
%               'spherical' -- 3D spherical coordinates
%                   x(1,:) -- r
%                   x(2,:) -- theta
%                   x(3,:) -- phi
%               'cylindrical' -- 3D cylindrical coordinates
%                   x(1,:) -- r
%                   x(2,:) -- theta
%                   x(3,:) -- z
%
%OUTPUT
%
%   f(1,j) -- Jacobian of 'system' at the jth point
%
%FEATURES TO BE ADDED TO NEXT VERSION:
%
% - more coordinate systems
% - try-catch error handling in case 'system' is passed improperly
%
%Lee Ferchoff

switch system
    case { 'polar' 'Polar' 'POLAR' 'cylindrical' 'Cylindrical' 'CYLINDRICAL'}
        f = x(1,:);
    case {'spherical' 'Spherical' 'SPHERICAL'}
        f = x(1,:).^2 .* sin(x(2,:));
    otherwise
        error([system ' is not a supported coordinate system.']);
end

 