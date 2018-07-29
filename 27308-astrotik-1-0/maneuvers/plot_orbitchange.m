% ASTROTIK by Francesco Santilli
% R2BP (Restricted Two Bodies Problem)
% Compute the optimal free-time transfer orbit between two given orbits in
% terms of the impulsive velocity changes.
%
% Usage: [DV,orbit,f12,f,h] = plot_orbitchange(orbitA,orbitB,mi)
%
% where: orbit = [p e i o w] = 3d orbit elements
%        orbit = [p e w] = 2d orbit elements
%           p = semi-latus rectum [L] (p>0)
%           e = eccentricity [-] (e>=0)
%           i = inclinaion [rad]
%           o = raan [rad]
%           w = argument of perifocus [rad]
%        mi = gravitational parameter [L^3*T^-2] (mi>0)
%        DV = [DV1 DV2] = velocity changes [L*T^-1]
%        f12 = [f1 f2] = start/end true anomalies (transfer orbit) [rad]
%        f = [fA fB] = optimal true anomalies (orbits A and B) [rad]
%        h.ha = [ha1 ha2] = axes handles
%         .hc = contour plot handles
%         .hf = optimal true anomalies plot handle
%         .ho(k,:) = orbits plot handles

function [DV,orbit,f12,f,h] = plot_orbitchange(orbitA,orbitB,mi)

    if ~(nargin == 3)
        error('Wrong number of input arguments.')
    end
    
    [DV,orbit,f12,f] = orbitchange(orbitA,orbitB,mi);
    
    ff = -pi:(pi/10):pi;
    N = length(ff);
    [XA,VA] = f2xv(orbitA,ff,mi);
    [XB,VB] = f2xv(orbitB,ff,mi);
    dv = zeros(N,N);
    for j = 1:N
        for k = 1:N
            dv(k,j) = sum(transfer(XA(j,:),VA(j,:),XB(k,:),VB(k,:),mi));
        end
    end
    
    figure('name','Contour plot of the velocity change')
    hold on
    axis([-180 180 -180 180])
    h.ha(1) = gca;
    set(gca,'Color','k')
    xlabel('f_{A} [deg]')
    ylabel('f_{B} [deg]')
    [~,h.hc] = contour(ff*(180/pi),ff*(180/pi),dv,40);
    h.hf = plot(f(1)*(180/pi),f(2)*(180/pi),'wo');
    
    orbits = [orbitA; orbitB; orbit];
    f012 = [nan(2,3); [NaN f12] ];
    mode = [false false true];
    names = ['Orbit A '
             'Orbit B '
             'Transfer'];
    [h.ho,h.ha(2)] = plot_orbits(orbits,f012,mode,[],names);
        
end