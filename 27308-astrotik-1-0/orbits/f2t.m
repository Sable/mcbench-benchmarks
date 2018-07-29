% ASTROTIK by Francesco Santilli
% R2BP (Restricted Two Bodies Problem)
% Computes the time from periapsis passage of given true anomalies.
%
% Usage: t = f2t(f,c,e)
%
% where: f(k) = true anomaly [rad]
%        c = sqrt(mi/p^3) [T^-1] (c>0)
%           p = semi-latus rectum [L] (p>0)
%           mi = gravitational parameter [L^3*T^-2] (mi>0)
%        e = eccentricity [-] (e>=0)
%        t(k) = time from periapsis passage [T]

function t = f2t(f,c,e)

    if ~(nargin == 3)
        error('Wrong number of input arguments.')
    end
    
    check(f,1)
    check(c,0)
    check(e,0)
    
    if c <= 0
        error('c must be a strictly positive value.')
    end
    
    if e < 0
        error('e must be a positive value.')
    end
    
    f = mod(f+pi,2*pi)-pi;
    if e > 1
        fmax = acos(-1/e);
        if any(f<-fmax) || any(f>fmax)
            error('f out of the hyperbolic range')
        end
    end
    
    if e == 0      % Circular orbits
        t = f/c;
    elseif e < 1   % Elliptical orbits
        E = f2E(f,e);
        M = E2M(E,e);
        n = c*(1-e^2)^(3/2);
        t = M/n;
    elseif e == 1  % Parabolic orbits
        F = tan(f/2);
        B = (F.^3+3*F)/2;
        t = B/(3*c);
    elseif e > 1   % Hyperbolic orbits
        H = f2H(f,e);
        N = H2N(H,e);
        n = c*(e^2-1)^(3/2);
        t = N/n;
    end
    
end