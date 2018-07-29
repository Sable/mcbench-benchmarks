% ASTROTIK by Francesco Santilli
% R2BP (Restricted Two Bodies Problem)
% f2H converts true anomaly in hyperbolic anomaly for an hyperbolic orbit.
%
% Usage: H = f2H(f,e)
%
% where: f(k) = true anomaly [rad]
%        e = eccentricity [-] (e>1)
%        H(k) = hyperbolic anomaly [rad]

function H = f2H(f,e)

    if ~(nargin == 2)
        error('Wrong number of input arguments.')
    end
    
    check(f,1)
    check(e,0)
    
    if e <= 1
        error('e must be strictly major than 1.')
    end
    
    ee = sqrt((e-1)/(e+1));
    H = 2*atanh( ee*tan(f/2) );
        
    kk = f/(2*pi);
    k = round(kk) - ((kk-fix(kk)) == 0.5);
    H = H + k*(2*pi);
    
end