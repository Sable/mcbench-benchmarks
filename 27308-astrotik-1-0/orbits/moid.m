% ASTROTIK by Francesco Santilli
% R2BP (Restricted Two Bodies Problem)
% Compute the Minimum Orbit Intersection Distance (MOID)
%
% Usage: [d,f] = moid(orbitA,orbitB)
%
% where: orbit = [p e i o w] = 3d orbit elements
%        orbit = [p e w] = 2d orbit elements
%           p = semi-latus rectum [L] (p>0)
%           e = eccentricity [-] (0<=e<1)
%           i = inclinaion [rad]
%           o = raan [rad]
%           w = argument of perifocus [rad]
%        d = MOID [L]
%        f = [fA fB] = true anomalies [rad]

function [d,f] = moid(orbitA,orbitB)

    if ~(nargin == 2)
        error('Wrong number of input arguments.')
    end
    
    DA = check(orbitA,1);
    DB = check(orbitB,1);
    
    if DA ~= DB
        error('Wrong size of input arguments.')
    end
    
    if ~(DA==3 || DA==5)
        error('Wrong size of input arguments.')
    end
    d3 = (DA==5);
    
    % rotation matrix
    if d3
        [pA,eA,iA,oA,wA] = take(orbitA);
        [pB,eB,iB,oB,wB] = take(orbitB);
        RA = rotation([oA iA wA]);
        RB = rotation([oB iB wB]);
        RA = RA(1:2,:);
        RB = RB(1:2,:);
    else
        [pA,eA,wA] = take(orbitA);
        [pB,eB,wB] = take(orbitB);
        cwA = cos(wA);
        swA = sin(wA);
        cwB = cos(wB);
        swB = sin(wB);
        RA = [ cwA swA
             -swA cwA];
        RB = [ cwB swB
              -swB cwB];
    end
    
    if pA<=0 || pB<=0
        error('p must be a stricly positive value.')
    end
    
    if eA<0 || eB<0 || eA>=1 || eB>=1
        error('e must be in the range [0,1).')
    end
    
    L2 = pA^2+pB^2;
    f0 = [+1 +1 -1 -1     
          +1 -1 +1 -1]*pi/2;
      
    f = zeros(2,4);
    d = zeros(1,4);
    ef = zeros(1,4);
    
    opt = optimset('LargeScale','on','Display','off','GradObj','on',...
                   'TolX',eps,'TolFun',0,... % 'Hessian','on',
                   'MaxFunEvals',Inf,'MaxIter',Inf);
    for k = 1:4
        try
            [f(:,k),d(k),ef(k)] = fminunc(@fun,f0(:,k),opt);
        catch
            f(:,k) = [NaN NaN]';
            d(k) = NaN;
            ef(k) = 0;
        end
    end
    
    bad = (ef==0);
    f(:,bad) = [];
    d(:,bad) = [];
    if isempty(f)
        error('No solution found.')
    end
    
    d = sqrt(d*L2);
    f = mod(f+pi,2*pi)-pi;
    [d,k] = min(d);
    f = f(:,k(1))';
    
    function [F,FF,FFF] = fun(f)

        fA = f(1);
        fB = f(2);

        cA = cos(fA);
        cB = cos(fB);
        sA = sin(fA);
        sB = sin(fB);

        rA = pA/(1+eA*cA);
        rB = pB/(1+eB*cB);

        A = rA*[cA sA]*RA;
        B = rB*[cB sB]*RB;
        
        D = A-B;
        F = D*D' / L2;
        
        if nargout > 1

            kA = rA^2/pA;
            kB = rB^2/pB;
            
            GA = [-sA eA+cA]*RA;
            GB = [-sB eB+cB]*RB;
            
            FA =  2*kA*D*GA';
            FB = -2*kB*D*GB';
            FF = [FA; FB] / L2;
            
            if nargout > 2

                kAA = 2*kA^2/rA*eA*sA;
                kBB = 2*kB^2/rB*eB*sB;

                GAA = -[cA sA]*RA;
                GBB = -[cB sB]*RB;

                FAA =  2*(kAA*D*GA' + kA*D*GAA' + kA^2*GA*GA');
                FBB = -2*(kBB*D*GB' + kB*D*GBB' + kB^2*GB*GB');
                FAB = -2*kA*kB*GA*GB';

                FFF = [FAA FAB
                       FAB FBB] / L2;
                   
            end
        end
        
        %fprintf('%.20f %.20f -> %.20f\n',f',F);
                
    end
    
end