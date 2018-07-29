% ASTROTIK by Francesco Santilli
% f2v computes velocity vector of an orbit at different true anomalies
%
% Usage: V = f2v(orbit,f,mi)
%
% where: orbit = [p e i o w] = 3d orbit elements
%        orbit = [p e w]     = 2d orbit elements
%           p = semi-latus rectum [L] (p>0)
%           e = eccentricity [-] (e>=0)
%           i = inclinaion [rad]
%           o = raan [rad]
%           w = argument of perifocus [rad]
%        f(k) = true anomalies [rad]
%        mi = gravitational parameter [L^3*T^-2] (mi>0)
%        V(k,:) = velocity [L*T^-1]

function V = f2v(orbit,f,mi)

    if ~(nargin == 3)
        error('Wrong number of input arguments.')
    end
    
    D = check(orbit,1);
    K = check(f,1);
    check(mi,0)
    
    if ~(D==3 || D==5)
        error('Wrong size of input arguments.')
    end

    d3 = (D==5);
    f = f(:);
    cf = cos(f);
    sf = sin(f);
    
    % rotation matrix
    if d3
        [p,e,i,o,w] = take(orbit);
        R = rotation([o i w]);
        R = R(1:2,:);
    else
        [p,e,w] = take(orbit);
        cw = cos(w);
        sw = sin(w);
        R = [ cw sw
             -sw cw];
    end
    
    if mi <= 0
        error('mi must be a strictly positive value.')
    end
    
    if p <= 0
        error('p must be a stricly positive value.')
    end
    
    if e < 0
        error('e must be a positive value.')
    end
        
    % velocity
    v = sqrt(mi/p);
    V = v * [-sf e+cf] * R;
    
end