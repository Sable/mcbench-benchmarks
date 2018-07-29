% ASTROTIK by Francesco Santilli
% R2BP (Restricted Two Bodies Problem)
% Computes the optimal free-time 2-impulses transfer orbit between
% the initial state [X1,V1] and the final state [X2,V2].
%
% Usage: [DV,orbit,f12] = transfer(X1,V1,X2,V2,mi)
%
% where: X1 = initial position [L]
%        V1 = initial velocity [L*T^-1]
%        X2 = final position [L]
%        V2 = final velocity [L*T^-1]
%        mi = gravitational parameter [L^3*T^-2] (mi>0)
%        DV = [DV1 DV2] = velocity changes [L*T^-1]
%        orbit = [p e i o w] = 3d orbit elements
%        orbit = [p e w]     = 2d orbit elements
%           p = semi-latus rectum [L]
%           e = eccentricity [-]
%           i = inclinaion [rad]
%           o = raan [rad]
%           w = argument of perifocus [rad]
%        f12 = [f1 f2] = start/end true anomalies [rad]

function [DV,orbit,f12] = transfer(X1,V1,X2,V2,mi)

    if ~(nargin == 5)
        error('Wrong number of input arguments.');
    end
    
    D = check(X1,1);
    check(X2,1)
    check(V1,1)
    check(V2,1)
    check(mi,0)
    
    if ~(D==2 || D==3)
        error('Wrong size of input arguments.')
    end
    d3 = (D==3);
    
    if ~(length(X2)==D && length(V1)==D && length(V2)==D)
        error('Wrong size of input arguments.')
    end
    
    if mi <= 0
        error('mi must be a strictly positive value.')
    end
    
    X1 = X1(:)';
    X2 = X2(:)';
    V1 = V1(:)';
    V2 = V2(:)';
        
    r1 = norm(X1);
    r2 = norm(X2);
    
    if r1==0 || r2==0
        error('r1 and r2 must be strictly positive.')
    end
    
    L = r1;
    T = sqrt(L^3/mi);
    rho = r2/L;
    S = L/T;
    W1 = V1/S;
    W2 = V2/S;
    
    if d3
        H = cross(X1,X2);
        h = norm(H);
        if h < eps
            error('Invalid transfer angle.')
        end
        i = real(acos(H(3)/h));
        o = atan2(H(1),-H(2));
        O = [cos(o) sin(o) 0]';
        s = @(x) sign(x) + (x==0);
        q1 = real(acos((X1/r1)*O)) * s(X1(3));
        q2 = real(acos((X2/r2)*O)) * s(X2(3));
    else
        q1 = atan2(X1(2),X1(1));
        q2 = atan2(X2(2),X2(1));
    end
    q = (q2-q1) + 2*pi*(q1>q2);
    
    sq = sin(q);
    cq = cos(q);
    tq = sq/(1+cq);
    c = sqrt(1+rho^2-2*rho*cq);
    pp = rho*sq/c;

    X1_ = tq*X1/r1;
    X2_ = tq*X2/r2;
    C = X2-X1;
    C_ = C/norm(C)/pp;

    aF = (1+rho)/2;
    eF = (1-rho)/c;
    pF = aF*(1-eF^2);
    eP = sqrt(1-eF^2);

    opt = optimset('TolX',eps);
    eT1 = fminbnd(@deltav,-eP,eP,opt);
    deltav1 = deltav(eT1);

    pp = -pp;
    X1_ = -X1_;
    X2_ = -X2_;
    C_ = -C_;

    eT2 = fminbnd(@deltav,-eP,eP,opt);
    deltav2 = deltav(eT2);

    if deltav1 < deltav2
        eT = eT1;
        pp = -pp;
    else
        eT = eT2;
        sq = -sq;
        q = 2*pi-q;
        q1 = pi-q1;
        if d3
            i = pi-i;
            o = mod(o,2*pi)-pi;
        end
    end

    e = sqrt(eF^2+eT^2);
    p = (pF-eT*pp)*L;
    wc = atan2(eF*rho*sq, eF*(rho*cq-1));
    if abs(eF) > eps
        w = wc + atan(eT/eF);
    else
        w = wc + pi/2*sign(eT);
    end
    w = mod(w+pi,2*pi)-pi;
    f12 = [-w -w+q];
    w = mod(q1+w+pi,2*pi)-pi;
    
    if d3
        orbit = [p e i o w];
    else
        orbit = [p e w];
    end
    
    V = f2v(orbit,f12,mi);
    DV1 = norm(V(1,:)-V1);
    DV2 = norm(V(2,:)-V2);
    DV = [DV1 DV2];
    
    function dv = deltav(eT)
        
        p = pF-eT*pp;
        p2 = sqrt(p);
        
        Vc = p2*C_;
        Vr1 = X1_/p2;
        Vr2 = X2_/p2;
        
        DV1 = (Vc+Vr1) - W1;
        DV2 = W2 - (Vc-Vr2);
        dv1 = norm(DV1);
        dv2 = norm(DV2);
        dv = dv1+dv2;
        
    end

end