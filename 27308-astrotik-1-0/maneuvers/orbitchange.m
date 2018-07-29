% ASTROTIK by Francesco Santilli
% R2BP (Restricted Two Bodies Problem)
% Compute the optimal free-time 2-impulses transfer orbit between 2 given
% orbits.
%
% Usage: [DV,orbit,f12,f] = orbitchange(orbitA,orbitB,mi)
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

function [DV,orbit,f12,f] = orbitchange(orbitA,orbitB,mi)

    if ~(nargin == 3)
        error('Wrong number of input arguments.')
    end
    
%     [h,hf] = plot_orbits([orbitA; orbitB]);
%     h = [];
    
    SA = norm( f2v(orbitA,pi/2,mi) );
    SB = norm( f2v(orbitB,pi/2,mi) );
    S = norm([SA SB]);
    
    f0 = [0 1 0 1
          0 0 1 1]*pi;
    
    f = zeros(2,4);
    dv = zeros(1,4);
    ef = zeros(1,4);
    
    opt = optimset('Display','off','TolX',eps,'TolFun',0,...
                   'MaxFunEvals',1e4,'MaxIter',1e4,'LargeScale','off');
    for k = 1:4
        try
            [f(:,k),dv(k),ef(k)] = fminunc(@deltav,f0(:,k),opt);
        catch
            f(:,k) = [NaN NaN]'; dv(k) = NaN; ef(k) = 0;
        end
    end
    
    bad = (ef==0);
    f(:,bad) = [];
    dv(:,bad) = [];
        
    f = mod(f+pi,2*pi)-pi;
    [~,k] = min(dv);
    f = f(:,k(1))';

    [XA,VA] = f2xv(orbitA,f(1),mi);
    [XB,VB] = f2xv(orbitB,f(2),mi);
    [DV,orbit,f12] = transfer(XA,VA,XB,VB,mi);
            
    function dv = deltav(f)

        [XA,VA] = f2xv(orbitA,f(1),mi);
        [XB,VB] = f2xv(orbitB,f(2),mi);
        [DV,orbit,f12] = transfer(XA,VA,XB,VB,mi); 
        dv = sum(DV)/S;
        
%         delete(h);
%         h = plot_orbits(orbit,[NaN f12],true,[],hf);
%         drawnow
        
    end
    
end