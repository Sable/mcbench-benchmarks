function [HF,psi,x,y] = feed_dist(F,z,TF,PF)

parameters_dist
c = length(z); % c includes all species
options = optimset('Display','iter','Diagnostics','on','Algorithm','interior-point');

% Bubble point calculation
xB = z'; % Bubble point requirement (together with PF)
yB = xB; % Initial guess
TB = TF; % Initial guess
x0 = [yB; TB];
r  = fmincon('1',x0,[],[],[],[],[],[],@gB,options,xB,PF,c);
yB = r(1:c);
TB = r(end);

% Dew point calculation
yD = z'; % Dew point requirement (together with PF)
xD = yD; % Initial guess
TD = TF; % Initial guess
x0 = [xD; TD];
r  = fmincon('1',x0,[],[],[],[],[],[],@gD,options,yD,PF,c);
xD = r(1:c);
TD = r(end);

if TF <= TB
    psi = 0;
    x   = xB;
    y   = yB;
    [~,~,~,~,~,HF,~,~] = prsrk(x,PF*1e5,TF+273.15,pc,Tc,w,k,cpig,DHf,DGf,'L',Thermo);
elseif TF >= TD
    psi = 1;
    x   = xD;
    y   = yD;
    [~,~,~,~,~,HF,~,~] = prsrk(y,PF*1e5,TF+273.15,pc,Tc,w,k,cpig,DHf,DGf,'V',Thermo);
else
    % Two-phase calculation
    x  = z';    % Initial guess
    y  = x;     % Initial guess
    V  = 0.5*F; % Initial guess
    L  = V;     % Initial guess
    x0 = [x; y; V; L]; d = [F; TF; PF; z'];
    r = fmincon('1',x0,[],[],[],[],[],[],@gF,options,d,c);
    x = r(1:c); y = r(c+1:2*c);
    [~,~,~,~,~,HL,~,~] = prsrk(x,PF*1e5,TF+273.15,pc,Tc,w,k,cpig,DHf,DGf,'L',Thermo);
    [~,~,~,~,~,HV,~,~] = prsrk(y,PF*1e5,TF+273.15,pc,Tc,w,k,cpig,DHf,DGf,'V',Thermo);
    V = r(end-1); L = r(end);
    HF = 1/F*(HV*V + HL*L); psi = r(end-1)/F;
end


function [c,ceq] = gB(x0,x,PF,c)

parameters_dist
y = x0(1:c);
T = x0(end);

[~,~,phiL,~,~,~,~,~] = prsrk(x,PF*1e5,T+273.15,pc,Tc,w,k,cpig,DHf,DGf,'L',Thermo);
[~,~,phiV,~,~,~,~,~] = prsrk(y,PF*1e5,T+273.15,pc,Tc,w,k,cpig,DHf,DGf,'V',Thermo);
K = phiL./phiV;

ceq = [y - K.*x; sum(y) - 1];
c   = [];


function [c,ceq] = gD(x0,y,PF,c)

parameters_dist
x = x0(1:c);
T = x0(end);

[~,~,phiL,~,~,~,~,~] = prsrk(x,PF*1e5,T+273.15,pc,Tc,w,k,cpig,DHf,DGf,'L',Thermo);
[~,~,phiV,~,~,~,~,~] = prsrk(y,PF*1e5,T+273.15,pc,Tc,w,k,cpig,DHf,DGf,'V',Thermo);
K = phiL./phiV;

ceq = [y - K.*x; sum(x) - 1];
c   = [];


function [c,ceq] = gF(x0,d,c)

parameters_dist
x = x0(1:c);
y = x0(c+1:2*c);
V = x0(end-1);
L = x0(end);

F  = d(1);
TF = d(2);
PF = d(3);
z  = d(4:end);

[~,~,phiL,~,~,~,~,~] = prsrk(x,PF*1e5,TF+273.15,pc,Tc,w,k,cpig,DHf,DGf,'L',Thermo);
[~,~,phiV,~,~,~,~,~] = prsrk(y,PF*1e5,TF+273.15,pc,Tc,w,k,cpig,DHf,DGf,'V',Thermo);
K = phiL./phiV;

ceq = [y - K.*x; F*z - V*y - L*x; sum(x) - 1; sum(y) - 1];
c   = [];

