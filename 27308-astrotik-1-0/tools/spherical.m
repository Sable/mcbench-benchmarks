% ASTROTIK by Francesco Santilli
% Compute spherical coordinates of a given position.
%
% Usage: [r,alpha,delta] = spherical(X)
%
% where: X = position [L]
%        r = radius [L]
%        alpha = right ascension [rad]
%        delta = declination [rad]

function [r,alpha,delta] = spherical(X)

    if ~(nargin == 1)
        error('Wrong number of input arguments.')
    end
    
    D = check(X,1);
    
    if ~(D==3)
        error('Wrong size of an input argument.')
    end

    xx1 = X(1)^2;
    xx2 = X(2)^2;
    xx3 = X(3)^2;
    r = sqrt(xx1 + xx2 + xx3);
    xy = sqrt(xx1 + xx2);
    alpha = atan2(X(2),X(1));
    delta = atan(X(3)/xy);

end