% ASTROTIK by Francesco Santilli
% R2BP (Restricted Two Bodies Problem)
% Computes multiple Lambert arcs for 2d and 3d positions.
%
% Usage: [orbits,f12] = lambertx(X,t,mi)
%
% where: X(k,:) = position at t(k) [L]
%        t(k) = point passage time [T] (t0<t1<...<tK)
%        mi = gravitational parameter [L^3*T^-2] (mi>0)
%        orbits(k,:) = [p e i o w] = 3d orbit elements
%        orbits(k,:) = [p e w]     = 2d orbit elements
%           p = semi-latus rectum [L]
%           e = eccentricity [-]
%           i = inclinaion [rad]
%           o = raan [rad]
%           w = argument of perifocus [rad]
%        f12(k,:) = [f1 f2] = start/end true anomalies [rad]

function [orbits,f12] = lambertx(X,t,mi)

    if ~(nargin == 3)
        error('Wrong number of input arguments.');
    end
    
    [K,D] = check(X,2);
    check(t,1)
    check(mi,0)
    
    if ~(D==2 || D==3)
        error('Wrong size of input arguments.')
    end
    
    if mi <= 0
        error('mi must be a strictly positive value.')
    end
    
    if ~issorted(t)
        error('t must be sorted.')
    end

    d3 = (D==3);
    
    if ~(length(t)==K)
        error('Wrong size of input arguments.')
    end
    
    Z = zeros(K-1,1);
    p = Z; e = Z; w = Z; f12 = [Z Z];
    if d3
        i = Z; o = Z;
    end
    
    r2 = norm(X(1,:));
    s = @(x) sign(x) + (x==0);
    for k = 1:K-1
        r1 = r2;
        r2 = norm(X(k+1,:));
        if r1 == 0 || r2 == 0
            error('r1 and r2 must be strictly positive.')
        end
        if d3
            H = cross(X(k,:),X(k+1,:));
            h = norm(H);
            if h < eps
                error('Invalid transfer angle.')
            end
            i = real(acos(H(3)/h));
            o = atan2(H(1),-H(2));
            O = [cos(o) sin(o) 0]';
            q1 = real(acos((X(k,:)/r1)*O)) * s(X(k,3));
            q2 = real(acos((X(k+1,:)/r2)*O)) * s(X(k+1,3));
        else
            q1 = atan2(X(k,2),X(k,1));
            q2 = atan2(X(k+1,2),X(k+1,1));
        end
        q = (q2-q1) + 2*pi*(q1>q2);
        dt = t(k+1)-t(k);
        [p(k),e(k),dw] = lambert(r1,r2,q,dt,mi);
        w(k) = mod(q1+dw+pi,2*pi)-pi;
        f12(k,:) = [-dw -dw+q];
    end
    
    if d3
        orbits = [p e i o w];
    else
        orbits = [p e w];
    end
    
end