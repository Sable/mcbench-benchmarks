%% VVX-lab.
%% Derivatafil med n st T (i vvx) + ipart för regulator
%%

function der = labtest(t,in,flag,regpar,vvxpar)

rho  = vvxpar(1);
cp   = vvxpar(2);
Fk   = vvxpar(3);
Fv   = vvxpar(4);
k    = vvxpar(5);
Tkin = vvxpar(6);
Tvin = vvxpar(7);
Atot = vvxpar(8);
Vtot = vvxpar(9);

regk = regpar(1);
itime = regpar(2);
Tset = regpar(3);

% Disturbances
if t > 1*60, vvxpar(3)=vvxpar(3)*0.7; end
%if t > 5*60, Tset = 50; end

% In-values
n = length(in)-1;
T = in(1:n);
ipart = in(n+1);

% Add noise
%noise = 1*(rand(1)-0.5);
noise = 0;
Tmeas = T(1) + noise;

% Ventil
e = Tset - Tmeas;
regut = regk*(e + ipart) + Fv/2; %u0 halva flödet
regut = regut*0.5;
vvxpar(4) = max(min(regut,Fv),0);
%vvxpar(4)

dT = dTlabvvx2(T,vvxpar);
dipart = 1/itime*e;

der = [dT; dipart];