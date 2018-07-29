% ASTROTIK by Francesco Santilli
% R2BP (Restricted Two Bodies Problem)
% E2f converts eccentric anomaly to true anomaly for an elliptical orbit.
%
% Usage: f = E2f(E,e)
%
% where: E(k) = eccentric anomaly [rad]
%        e = eccentricity [-] (0<e<1)
%        f(k) = true anomaly [rad]

function f = E2f(E,e)
    
    if ~(nargin == 2)
        error('Wrong number of input arguments.')
    end
    
    check(E,1)
    check(e,0)
    
    if (e<=0 || e>=1)
        error('e must be in the range (0,1).')
    end
    
    ee = sqrt((1+e)/(1-e));
    f = 2*atan( ee*tan(E/2) );
    
    kk = E/(2*pi);
    k = round(kk) - ((kk-fix(kk)) == 0.5);
    f = f + k*(2*pi);
    
end