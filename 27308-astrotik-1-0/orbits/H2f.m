% ASTROTIK by Francesco Santilli
% R2BP (Restricted Two Bodies Problem)
% H2f converts hyperbolic anomaly to true anomaly for an hyperbolic orbit.
%
% Usage: f = H2f(H,e)
%
% where: H(k) = hyperbolic anomaly [rad]
%        e = eccentricity [-] (e>1)
%        f(k) = true anomaly [rad]

function f = H2f(H,e)

    if ~(nargin == 2)
        error('Wrong number of input arguments.')
    end
    
    check(H,1)
    check(e,0)
    
    if e <= 1
        error('e must be strictly major than 1.')
    end
    
    ee = sqrt((e+1)/(e-1));
    f = 2*atan( ee*tanh(H/2) );
    
    kk = H/(2*pi);
    k = round(kk) - ((kk-fix(kk)) == 0.5);
    f = f + k*(2*pi);
    
end