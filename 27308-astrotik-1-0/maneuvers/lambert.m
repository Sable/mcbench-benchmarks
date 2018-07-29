% ASTROTIK by Francesco Santilli
% R2BP (Restricted Two Bodies Problem)
% Solves the problem of Lambert with the method developed by G. Avanzini.
%
% Usage: [p,e,w] = lambert(r1,r2,q,t,mi)
%
% where: r1 = starting point radius [L] (r1>0)
%        r2 = ending point radius [L] (r2>0)
%        q = transfer angle [rad] (q>0)
%        t = transfer time [T] (t>0)
%        mi = gravitational parameter [L^3*T^-2] (mi>0)
%        p = semi-latus rectum [L]
%        e = eccentricity [-]
%        w = argument of perifocus (from r1) [rad]

function [p,e,w] = lambert(r1,r2,q,t,mi)
    
    if ~(nargin == 5)
        error('Wrong number of input arguments.')
    end
    
    check(r1,0)
    check(r2,0)
    check(q,0)
    check(t,0)
    check(mi,0)
    
    if ~(r1>0 && r2>0 && q>0 && t>0 && mi>0)
        error('Input arguments must be strictly positive values.')
    end

    L = r1;
    T = sqrt(L^3/mi);
    rho = r2/L;
    tau = t/T;
    
    % multiple revolutions disabled
    N = 0;
    q = mod(q,2*pi);
    
    cq = cos(q);
    sq = sin(q);
    c = sqrt(1+rho^2-2*rho*cq);
    pp = rho*sq/c;
    
    aF = (1+rho)/2;
    eF = (1-rho)/c;
    eF2 = eF^2;
    pF = aF*(1-eF2);
    eP = sqrt(1-eF2);
    eH = sqrt(cos(q/2)^(-2)-eF2);
    wc = atan2(eF*rho*sq, eF*(rho*cq-1));
    
    if N > 0
        % multiple revolutions (to be done)
    else
        if q < pi
            x1 = -pi/2;
            x2 =  pi/4;
            eT = @(x) tan(x)*eP;
        else
            x1 = exp(-eH);
            x2 = exp( eP);
            eT = @(x) log(x);
        end
    end
    
    dt0 = lamb(0);
    y = @(dt) atan(dt/dt0);
    dt = @(x) lamb(eT(x));
    F = @(x) y(dt(x)) - y(tau);
    x0 = regulafalsi(F,x1,x2);
    eT = eT(x0);
    
    e = sqrt(eF^2+eT^2);
    p = (pF-eT*pp)*L;
    w = wc + atan(eT/eF);
    w = mod(w+pi,2*pi)-pi;
    
    function dt = lamb(eT)
        
        e = sqrt(eF2+eT^2);
        p = pF-eT*pp;
        if p > 0
            c = p^(-3/2);
            w = wc + atan(eT/eF);
            f = [-w -w+q];
            tt = f2t(f,c,e);
            dt = tt(2)-tt(1);
            if dt < 0
                if e < 1
                    P = 2*pi * (p/(1-e^2))^(3/2);
                    dt = P+dt;
                elseif e == 1
                    dt = Inf;
                end
            end
        else
            dt = 0;
        end
        
    end

end