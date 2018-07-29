% ASTROTIK by Francesco Santilli
% Patched Conics Method.
% Computes multiple Lambert arcs for 2d and 3d positions, performs powered
% swing-by around intermediate bodies.
%
% Usage: [DV,orbits,f12] = flyby(scenario,s,t)
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
%        DV(k) = delta-v for orbital change [L*T^-1]
%        orbits(k,:) = [p e i o w] = 3d orbit elements (transfer)
%        orbits(k,:) = [p e w]     = 2d orbit elements (transfer)
%        f12(k,:) = [f1 f2] = start/end true anomalies [rad]
%
% note: first/last: departure/arrive (orbit injection)
%       double: arrive/departure (orbit injection)
%       single: powered swing-by

function [DV,orbits,f12] = flyby(scenario,s,t)

    if ~(nargin == 3)
        error('Wrong number of input arguments.');
    end
    
    [orbits0,t0,mi,R,mi0,J] = checkscenario(scenario);
    K = check(s,1);
    check(t,1)
    D = size(orbits0,2);
    n = 3 - (D==3);
    
    if any((fix(s)<s) | (s<0) | (s>J))
        error('s must be an integer in the range [1,J]')
    end
    
    if ~(length(t)==K)
        error('Wrong size of input arguments.')
    end
    
    if ~issorted(t)
        error('t must be sorted.')
    end
    
    % Junction points
    X0 = zeros(K,n);
    V0 = zeros(K,n);
    for k = 1:K
        j = s(k);
        [X0(k,:),V0(k,:)] = t2xv(orbits0(j,:),t0(j),t(k),mi0);
    end
    
    % Lambert arcs
    V1 = zeros(K-1,n);
    V2 = zeros(K-1,n);
    orbits = zeros(K-1,D);
    f12 = zeros(K-1,2);
    for k = 1:K-1
        if s(k) == s(k+1)
            j = s(k);
            p = orbits0(j,1);
            e = orbits0(j,2);
            c = sqrt(mi0/p^3);
            orbits(k,:) = orbits0(j,:);
            f12(k,:) = t2f(t0(j),c,e,t(k:k+1));
            f12(k,:) = mod(f12(k,:)+pi,2*pi)-pi;
            if f12(k,1) > f12(k,2)
                f12(k,2) = f12(k,2)+2*pi;
            end
            V1(k,:) = V0(k,:);
            V2(k,:) = V0(k+1,:);
        else
            [orbits(k,:),f12(k,:)] = lambertx(X0(k:k+1,:),t(k:k+1),mi0);
            V = f2v(orbits(k,:),f12(k,:),mi0);
            V1(k,:) = V(1,:);
            V2(k,:) = V(2,:);
        end
    end
    
    body = (mi>0) & (R>0);
    DV = zeros(1,K);
    
    % first DV
    j = s(1);
    vout = norm(V1(1,:)-V0(1,:));
    if body(j)
        DV(1) = injection(vout,mi(j),R(j));
    else
        DV(1) = vout;
    end
    
    % intermediate DV
    for k = 2:K-1
        j = s(k);
        if body(j)
            if s(k-1) == j
                vout = norm(V1(k,:)-V0(k,:));
                DV(k) = injection(vout,mi(j),R(j));
            elseif s(k+1) == j
                vin = norm(V2(k-1,:)-V0(k,:));
                DV(k) = injection(vin,mi(j),R(j));
            else
                Vin = V2(k-1,:)-V0(k,:);
                Vout = V1(k,:)-V0(k,:);
                vin = norm(Vin);
                vout = norm(Vout);
                delta = real(acos((Vin/vin)*(Vout/vout)'));
                DV(k) = swingby(vin,vout,delta,mi(j),R(j));
            end
        else
            DV(k) = norm(V1(k,:)-V2(k-1,:));
        end
    end
    
    % last DV
    j = s(K);
    vin = norm(V2(K-1,:)-V0(K,:));
    if body(j)
        DV(K) = injection(vin,mi(j),R(j));
    else
        DV(K) = vin;
    end
    
    function DV = injection(vinf,mii,RR)
        
        a = mii/vinf^2;
        Vc = sqrt(mii/RR);
        Vp = sqrt(mii*(2/RR+1/a));
        DV = Vp-Vc;
        
    end

    function DV = swingby(vinf1,vinf2,d,mii,RR)
        
        a1 = mii/vinf1^2;
        a2 = mii/vinf2^2;
        rp = @(x) RR*tan(x);
        y1 = @(x) 1/(1+a1/rp(x));
        y2 = @(x) 1/(1+a2/rp(x));
        F = @(x) asin( y1(x) ) + asin( y2(x) ) - d;
        x = regulafalsi(F,eps,pi/2);
        rp = rp(x);
        
        if rp > RR
            v1 = sqrt(mii*(2/rp+1/a1));
            v2 = sqrt(mii*(2/rp+1/a2));
            DV = abs(v1-v2);
        else
            v1 = sqrt(mii*(2/RR+1/a1));
            v2 = sqrt(mii*(2/RR+1/a2));
            vc = sqrt(mii/RR);
            DV = (v1-vc) + (v2-vc);
        end
        
    end
    
end