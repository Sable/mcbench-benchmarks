% ASTROTIK by Francesco Santilli
% R2BP (Restricted Two Bodies Problem)
% Computes true anomalies of a time span with numerical methods.
%
% Usage: f = t2f(t0,c,e,t)
%
% where: t0(k) = time of periapsis [T]
%        c(k) = sqrt(mi/p^3) [T^-1] (c>0)
%           p = semi-latus rectum [L] (p>0)
%           mi = gravitational parameter [L^3*T^-2] (mi>0)
%        e(k) = eccentricity [-] (e>=0)
%        t(j) = time [T]
%        f(j,k) = true anomaly [rad]

function f = t2f(t0,c,e,t)

    if ~(nargin == 4)
        error('Wrong number of input arguments.')
    end
    
    K = check(t0,1);
    check(c,1)
    check(e,1)
    J = check(t,1);
    
    if ~(length(c)==K && length(e)==K)
        error('Wrong size of input arguments.')
    end
    
    if any(c<=0)
        error('c must be a strictly positive value.')
    end
    
    if any(e<0)
        error('e must be a positive value.')
    end

    f = zeros(J,K);
    for k = 1:K
        if e(k) == 0          % Circular orbits
            f(:,k) = c(k)*(t-t0(k));
        elseif e(k) < 1       % Elliptical orbits
            M = c(k)*(1-e(k)^2)^(3/2)*(t-t0(k));
            E = M2E(M,e(k));
            f(:,k) = E2f(E,e(k));
        elseif e(k) == 1      % Parabolic orbits
            B = 3*c(k)*(t-t0(k));
            A = (B + sqrt(B.^2+1) ).^(2/3);
            F = 2*A.*B ./ (A.^2+A+1);
            f(:,k) = 2*atan(F);
        elseif e(k) > 1       % Hyperbolic orbits
            N = c(k)*(e(k)^2-1)^(3/2)*(t-t0(k));
            H = N2H(N,e(k));
            f(:,k) = H2f(H,e(k));
        end
    end

end