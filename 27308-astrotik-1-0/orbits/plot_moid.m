% ASTROTIK by Francesco Santilli
% R2BP (Restricted Two Bodies Problem)
% Compute the Minimum Orbit Intersection Distance (MOID)
%
% Usage: [d,f,h] = plot_moid(orbitA,orbitB)
%
% where: orbit = [p e i o w] = 3d orbit elements
%           p = semi-latus rectum [L] (p>0)
%           e = eccentricity [-] (e>=0)
%           i = inclinaion [rad]
%           o = raan [rad]
%           w = argument of perifocus [rad]
%        d = MOID [L]
%        f = [fA fB] = true anomalies [rad]
%        h.ha = [ha1 ha2] = axes handles
%         .hc = contour plot handles
%         .hf = true anomalies plot handle
%         .ho(k,:) = orbits plot handles
%         .hm = moid plot handle

function [d,f,h] = plot_moid(orbitA,orbitB)

    if ~(nargin == 2)
        error('Wrong number of input arguments.')
    end

    [d,f] = moid(orbitA,orbitB);
    
    ff = -pi:(pi/10):pi;
    N = length(ff);
    A = f2x(orbitA,ff);
    B = f2x(orbitB,ff);
    dd = zeros(N,N);
    for j = 1:N
        for k = 1:N
            dd(k,j) = norm(A(j,:)-B(k,:));
        end
    end
        
    figure('name','Contour plot of the orbital mutual distance')
    hold on
    axis([-180 180 -180 180])
    h.ha(1) = gca;
    set(gca,'Color','k')
    xlabel('f_{A} [deg]')
    ylabel('f_{B} [deg]')
    [~,h.hc] = contour(ff*(180/pi),ff*(180/pi),dd,20);
    h.hf = plot(f(1)*(180/pi),f(2)*(180/pi),'wo');
    
    [h.ho,h.ha(2)] = plot_orbits([orbitA;orbitB]);
    
    A = f2x(orbitA,f(1));
    B = f2x(orbitB,f(2));
    d3 = (length(orbitA)==5);
    if d3
        h.hm = plot3([A(1) B(1)],[A(2) B(2)],[A(3) B(3)],'ow-');
    else
        h.hm = plot([A(1) B(1)],[A(2) B(2)],'ow-');
    end

end