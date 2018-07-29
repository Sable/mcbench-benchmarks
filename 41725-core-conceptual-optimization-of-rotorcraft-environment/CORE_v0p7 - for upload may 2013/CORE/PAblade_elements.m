tState.mu = V/AC.Rotor.TS; %#ok<*SUSENS>
[tState.rho,tState.a,tState.temp,tState.pres,tState.nu]=stdatmo(h,tState.dT);
rho = tState.rho;
q = 1/2*rho.*V.^2;

[n maxLflag] = loadfactor(tState);
%   max lift flag when the wing will be forced to operate at CLmax instead
%   of the minimum drag CL defined by L/Tm = (b/D)^2 [Prouty]

W = tState.beta*AC.W.W;
nW = n*W;

[~, CLmax CDvwing qratiowing]= AC.Ass.wingpolar(0,AC,tState);
Lmax = CLmax * q * AC.Wing.S;
Lmin = 0;

% ground effect
viratio = IGEvi(tState.IGEzD);
DWqratio = viratio.^2;

[CDfuse,DLfactor] = fusepolar_arealoading(AC,tState);

Kfuse = DWqratio*(1-1/(1+DLfactor));
Kwing = DWqratio*CDvwing*qratiowing*AC.Wing.S/AC.Rotor.DA;

if maxLflag %i.e. instantaneous turn
    L = Lmax;
    Tmv = (nW-L)/(1-(Kfuse+Kwing));
else
    Tmv = nW/(1+(AC.Wing.b/AC.Rotor.D)^2-(Kfuse+Kwing)); %Tmv for min drag
    L = Tmv*(AC.Wing.b/AC.Rotor.D)^2;
    
    L = min(L,Lmax);
    L = max(L,Lmin);
    if L == Lmax;
        maxLflag = true;
    end
    Tmv = (nW-L)/(1-(Kfuse+Kwing));
end

%% Drag
junk = q*AC.Wing.S;
if junk == 0
    CL = 0;
else
    CL = L./(junk);
end
CDwing = AC.Ass.wingpolar(CL,AC,tState);

Dwing = CDwing.*q.*AC.Wing.S;
Dfuse = CDfuse.*q;

% C_H/sigma0 = cd*mu/4
% HforceEstimate = AC.Rotor.sigma*AC.Rotor.DA*simple_profile_cd*tState.mu...
%     *rho*AC.Rotor.TS^2/4;

Treq = Dwing + Dfuse;% +HforceEstimate;

[~, Tavail] = AC.Ass.plapse(AC, tState, Treq);

Tprop = min(Treq,Tavail);

Tmh = Treq - Tprop; %autogyros

Tmtot = sqrt(Tmh.^2+Tmv.^2);


%% induced velocity
vi = sqrt(-(V.^2)/2+sqrt(((V.^2)/2).^2+...
    (Tmtot./(2.*rho.*AC.Rotor.DA)).^2));

%% We have vi, rotor tip path plane angle, and required rotor thrust
rotortilt = atan2(Tmh,Tmv); % this could just be a first guess for iteration
lambdainflow = (abs(tState.V*sin(rotortilt))+abs(vi))/AC.Rotor.TS;
vL = -vi.*vLdistribution(r,psi,AC,tState,lambdainflow); % induced velocity distribution (minus sign: pointing downward

theta_coll = decisionX(1);
A1 = decisionX(2);
B1 = decisionX(3);
if V == 0; %simplify a tiny bit for hovering flight
    A1 = 0;
    B1 = 0;
end

TS = AC.Rotor.TS;V = tState.V;tw = AC.Rotor.tw;b = AC.Rotor.b;

theta = theta_coll + tw*AC.Ass.twistf(r) + A1*cos(psi) + B1*sin(psi);

% componnent of V across rotor disc
Vtangential = V*cos(rotortilt);% + vL*sin(rotortilt);
Vnormal = vL-V.*sin(rotortilt); %minus sign: pointing downward

% tangential velocity
mux = Vtangential./AC.Rotor.TS;
U_T = TS.*(r+mux.*sin(psi));

U_P = Vnormal;

phi = atan2(U_P,U_T);
alpha = phi + theta;

% aero forces
%BladeState is the state of the blade element with components:
jnk = U_T.^2 + U_P.^2;
absvlocal = sqrt(jnk);
qlocal = 1/2*rho.*jnk;

BladeState.M = absvlocal./tState.a;
BladeState.alpha = alpha;
BladeState.r = r;
BladeState.psi = psi;
BladeState.alphadot = 0;
BladeState.Re = absvlocal.*AC.Rotor.c./tState.nu;
[cl,cd] = AC.Ass.bpolar(BladeState,AC);

% now resolve aero coefficients into forces normal to and in-line with the
% rotor disc
l = cl.*qlocal.*AC.Rotor.c; %lift per unit span (radius) , edit here for autogyro
d = cd.*qlocal.*AC.Rotor.c;%drag per unit radius

% all of these are per unit radius (per unit span
fz = l.*cos(phi)+d.*sin(phi); %force perpendicular to rotor disc (positive up)
ftan = l.*sin(phi)-d.*cos(phi);%force tangential to rotor disc in direction
% of rotation; should take care of reverse flow
fx = -ftan.*sin(psi);%X force in line with rotor disc (positive AFT)
fy = ftan.*cos(psi);%side force in line with rotor disc (positive to starboard)

%semi-dimensional
torq = -ftan.*r*AC.Rotor.R; %torque required (note minus sign) (aka nmom)
mmom = -fz.*X;%pitching moment contribution positive pitch up
lmom = fz.*Y;%rolling moment contribution positive roll left

%now we add them all together - integrate over radius and average around azimuth - annulus value
ff = cat(3,fx,fy,fz,lmom,mmom,torq);
Ff = mean(ff);
% integrate from r=0 to r=1 & multiply by number of blades
Frotor = b*trapz(Rlocs,Ff);
Frotor = Frotor(:);

FZ = Frotor(3);
FY = Frotor(2);
FX = Frotor(1);
TORQ = Frotor(6);
MMom = Frotor(4); %#ok<*SNASGU>
LMom = Frotor(5);

%transform into body axes (moments are approximations):
FZb = FZ*cos(rotortilt)+FX*sin(rotortilt);
FXb = -FZ*sin(rotortilt)+FX*cos(rotortilt);
Fb = [FXb FY FZb];

nondimensionalizer = rho*AC.Rotor.DA*AC.Rotor.TS.^2;
CFrotor = Frotor/nondimensionalizer;
CFrotor(4:end) = CFrotor(4:end)/AC.Rotor.R;
CTmtot = Tmtot/nondimensionalizer;

