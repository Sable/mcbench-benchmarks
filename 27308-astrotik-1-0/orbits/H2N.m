% ASTROTIK by Francesco Santilli
% R2BP (Restricted Two Bodies Problem)
% H2N converts hyperbolic anomaly to mean anomaly for an hyperbolic orbit.
%
% Usage: N = H2N(H,e)
%
% where: H(k) = hyperbolic anomaly [rad]
%        e = eccentricity [-] (e>1)
%        N(k) = mean anomaly [rad]

function N = H2N(H,e)

    if ~(nargin == 2)
        error('Wrong number of input arguments.')
    end
    
    check(H,1)
    check(e,0)
    
    if e <= 1
        error('e must be strictly major than 1.')
    end
    
    N = e*sinh(H)-H;
    
end