% ASTROTIK by Francesco Santilli
% R2BP (Restricted Two Bodies Problem)
% f2E converts true anomaly in eccentric anomaly for an elliptical orbit.
%
% Usage: E = f2E(f,e)
%
% where: f(k) = true anomaly [rad]
%        e = eccentricity [-] (0<e<1)
%        E(k) = eccentric anomaly [rad]

function E = f2E(f,e)

    if ~(nargin == 2)
        error('Wrong number of input arguments.')
    end
    
    check(f,1)
    check(e,0)
    
    if (e<=0 || e>=1)
        error('e must be in the range (0,1).')
    end
    
    ee = sqrt((1-e)/(1+e));
    E = 2*atan( ee*tan(f/2) );
        
    kk = f/(2*pi);
    k = round(kk) - ((kk-fix(kk)) == 0.5);
    E = E + k*(2*pi);
    
end