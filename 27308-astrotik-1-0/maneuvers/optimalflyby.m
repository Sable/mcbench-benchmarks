% ASTROTIK by Francesco Santilli
% Patched Conics Method.
% Computes multiple Lambert arcs for 2d and 3d positions, performs powered
% swing-by around intermediate bodies. Search for the optimal time sequence
% into given bounds and under the constraint of a maximum flight time.
%
% Usage: [t,DV,orbits,f12] = optimalflyby(scenario,s,t00,tt,t_max,W)
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
%        t00 = reference time [T]
%        tt(k,:) = [lb dt ub] (lb<dt<ub)
%           lb = lower bound [T]
%           dt = delta-time (initial guess) [T]
%           ub = upper bound [T]
%        t_max = max flight time [T]
%        W(k) = delta-v optimization weigth [-]
%        t(k) = flyby time [T]
%        DV(k) = delta-v for orbital change [L*T^-1]
%        orbits(k,:) = [p e i o w] = 3d orbit elements (transfer)
%        orbits(k,:) = [p e w]     = 2d orbit elements (transfer)
%        f12(k,:) = [f1 f2] = start/end true anomalies [rad]

function [t,DV,orbits,f12] = optimalflyby(scenario,s,t00,tt,t_max,W)

    if ~(nargin == 6)
        error('Wrong number of input arguments.');
    end
    
    [orbits0,~,~,~,mi0,J] = checkscenario(scenario);
    check(s,1)
    check(t00,0)
    [K,D] = check(tt,2);
    check(t_max,0)
    check(W,1)
    
    if ~(D==3 && length(s)==K && length(W)==K)
        error('Wrong size of input arguments.')
    end
    
    S = zeros(1,J);
    for j = 1:J
        S(j) = norm( f2v(orbits0(j,:),pi/2,mi0) );
    end
    S = norm(S);
    
    T = max(max(abs(tt)));
    [lb,dt0,ub] = take(tt/T);
    A = [0 ones(1,K-1)];
    B = t_max/T;
    W = W(:);
    
    opt = optimset('Algorithm','active-set','Display','off',...
                   'TolCon',eps,'TolX',eps,'TolFun',0,...
                   'MaxFunEvals',1e4,'MaxIter',1e4);
    
    dt = fmincon(@deltav,dt0,A,B,[],[],lb,ub,[],opt);
    
    t = conv(dt);
    [DV,orbits,f12] = flyby(scenario,s,t);

    function dv = deltav(dt)
        
        t = conv(dt);
        DV = flyby(scenario,s,t);
        dv = DV*W/S;
        
    end

    function t = conv(dt)
        
        t = zeros(K,1);
        t(1) = t00 + dt(1)*T;
        for k = 2:K
            t(k) = t(k-1) + dt(k)*T;
        end

    end

end