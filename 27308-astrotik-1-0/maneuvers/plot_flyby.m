% ASTROTIK by Francesco Santilli
% Patched Conics Method.
% Computes multiple Lambert arcs for 2d and 3d positions, performs powered
% swing-by around intermediate bodies.
%
% Usage: plot_flyby(scenario,s,t)
%        plot_flyby(scenario,s,t,colors)
%        plot_flyby(scenario,s,t,[],names)
%        [DV,orbits,f12,h,ha] = plot_flyby(...)
%
% where: scenario.orbits0(j,:) = [p e i o w] = 3d orbit elements (target)
%                .orbits0(j,:) = [p e w]     = 2d orbit elements (target)
%                    p = semi-latus rectum [L] (p>0)
%                    e = eccentricity [-] (e>0)
%                    i = inclinaion [rad]
%                    o = raan [rad]
%                    w = argument of perifocus [rad]
%                .t0(j) = time of periapsis [T]
%                .mi(j) = body gravitational parameter [L^3*T^-2] (mi>0)
%                .R(j) = body radius [L] (R>0)
%                .mi0 = system gravitational parameter [L^3*T^-2] (mi0>0)
%        s(k) = flyby body number (1-J)
%        t(k) = flyby time [T] (t0<t1<...<tK)
%        colors(k,:) = [R G B] plot color (0-1)
%        names(k,:) = orbit string name
%        DV(k) = delta-v for orbital change [L*T^-1]
%        orbits(k,:) = [p e i o w] = 3d orbit elements (transfer)
%        orbits(k,:) = [p e w]     = 2d orbit elements (transfer)
%        f12(k,:) = [f1 f2] = start/end true anomalies [rad]
%        h(k,:) = orbits plot handles
%        ha = axes handle

function [DV,orbits,f12,h,ha] = plot_flyby(scenario,s,t,colors,names0)

    if (nargin < 3 || nargin > 5)
        error('Wrong number of input arguments.');
    end
    
    if nargin < 5
        names0 = [ones(J,1)*'Orbit ' num2str((1:J)')];
    end
    
    if nargin < 4
        colors = [];
    end

    [DV,orbits,f12] = flyby(scenario,s,t);
    
    J = size(scenario.orbits0,1);
    K = size(orbits,1);
    
    orb = [scenario.orbits0; orbits];
    f012 = [nan(J,3); [nan(K,1) f12] ];
    mode = [false(1,J) true(1,K)];
    names1 = [ones(K,1)*'Transfer ' num2str((1:K)')];
    names = strvcat({names0;names1});
    [h,ha] = plot_orbits(orb,f012,mode,colors,names);
    
end