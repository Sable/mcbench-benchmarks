% ASTROTIK by Francesco Santilli
% f2x computes position vectors of an orbit at different true anomalies
%
% Usage: X = f2x(orbit,f)
%
% where: orbit = [p e i o w] = 3d orbit elements
%        orbit = [p e w]     = 2d orbit elements
%           p = semi-latus rectum [L] (p>0)
%           e = eccentricity [-] (e>=0)
%           i = inclinaion [rad]
%           o = raan [rad]
%           w = argument of perifocus [rad]
%        f(k) = true anomalies [rad]
%        X(k,:) = position [L]

function X = f2x(orbit,f)

    if ~(nargin == 2)
        error('Wrong number of input arguments.')
    end
    
    D = check(orbit,1);
    check(f,1)
    
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
    
    if p <= 0
        error('p must be a stricly positive value.')
    end
    
    if e < 0
        error('e must be a positive value.')
    end
        
    % position
    r = p./(1+e*cf);
    X = [r.*cf r.*sf] * R;
        
end