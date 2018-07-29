% ASTROTIK by Francesco Santilli
% R2BP (Restricted Two Bodies Problem)
% E2M converts eccentric anomaly to mean anomaly for an elliptical orbit.
%
% Usage: M = E2M(E,e)
%
% where: E(k) = eccentric anomaly [rad]
%        e = eccentricity [-] (0<e<1)
%        M(k) = mean anomaly [rad]

function M = E2M(E,e)

    if ~(nargin == 2)
        error('Wrong number of input arguments.')
    end
    
    check(E,1)
    check(e,0)
    
    if (e<=0 || e>=1)
        error('e must be in the range (0,1).')
    end
    
    M = E-e*sin(E);
    
end