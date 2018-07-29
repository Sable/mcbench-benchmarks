function [AUMestimate,AC] = weightestimate_baseline(AC)
% Write this weight estimation function to estimate the all up mass (TOGW)
% based on all physical parameters of the aircraft, including propulsion
% AND WEIGHTS. The key field to return is the new AUMestimate. However, if
% you want, add fields in the AC structure for use in project-specific
% functions (i.e. AC.W.Wcrew, AC.W.Wrotors, AC.Rotor.weightdistribution)

% The idea of this function is that from the base weight and component
% weight fractions, the components are scaled or calculated and add-ons are
% added on.

%% Assumptions
Baseline_AUM = 10000; %kg
% Baseline_AUM = AC.Vars.Wbaseline*1000; %convert to kg

%%
W = AC.W;

rotors_frac = .0586; %fraction of AUW of main rotor, hub, and tail rotor for conventional helicopter
engines_frac = .05; %fraction of AUW of engines for conventional helicopter
transmission_frac = .075;

typicalfuel_frac = .17;
fuelgrowthfactor = 1.3;

typical_P_W = .25; %kW/kg


%% Wing weight estimation
tc = .12;
taper = .65;
% taper = AC.Wing.taper;
% USAF method from Roskam
b = AC.Wing.b;
D = AC.Rotor.D;
jnk = (b./D).^2;
Wingload = W.AUM .* jnk./(1+jnk); %from biplane min induced drag relation

nUlt = 5; 
Load = nUlt * convmass(Wingload,'kg','lbm'); %lbf

KEASmax = convvel(190,'m/s','kts'); %kts
AR = AC.Wing.AR;
S = convarea(AC.Wing.S,'m2','ft2');

W.Wing = 96.948*((Load/1e5).^.65.*AR.^.57.*(S/100).^.61.*((1+taper)./(2*tc)).^.36.*sqrt(1+KEASmax/500)).^.993;
W.Wing = convmass(W.Wing,'lbm','kg');

%% Thrust weight
W.Thrust = .25*(AC.Power.T/g0); %T/W of engine of 4

%% rotor blades and hub
% from Prouty
c = AC.Rotor.c/.3048; 
b = round(AC.Rotor.b);
R = AC.Rotor.R/.3048; 
TS = convvel(AC.Rotor.TS,'m/s','ft/s');

MRB = .026*(b.^0.66).*c.*(R.^1.3).*(TS.^.67);
W.MRB = MRB/2.20462;

J = (.4*R).^2.*MRB;
MRhub = .0037*(b.^.28).*(R.^1.5).*(TS.^.43).*(.67*MRB+9.81*J./(R.^2)).^.55;

W.Rotor = (MRB+MRhub)/2.20462;

RT = AC.TRotor.R/.3048;
hprating = AC.Power.P/746.6999*1.1; %AC Power wrong - way too high
OmegaM = TS./R;
W.TRotor = 1.4*RT.^.09.*(hprating./OmegaM).^.90;
W.TRotor = W.TRotor/2.20462;

%% scaled (engines, transmission, fuel) and added (rotors/hub, thrust, wing) components
P_W_ratio = AC.Power.P./1000./W.AUM/typical_P_W;
engineweight_baseline = Baseline_AUM * engines_frac;
newengineweight = engineweight_baseline*P_W_ratio;

transweight_baseline = Baseline_AUM * transmission_frac;
newtransweight = transweight_baseline * P_W_ratio;

fuelweight_baseline = Baseline_AUM * typicalfuel_frac;
newfuelweight = fuelweight_baseline * W.fuelfrac/typicalfuel_frac;

rotorweight_baseline = Baseline_AUM * rotors_frac;
newrotorweight = W.Rotor + W.TRotor;

%baseline w/o componenets
Barebaseline = Baseline_AUM -engineweight_baseline-transweight_baseline...
    -fuelweight_baseline-rotorweight_baseline;

AUMestimate = Barebaseline+newengineweight+newtransweight...
    +newfuelweight+newrotorweight...
    +W.Thrust+W.Wing+ ...
    fuelgrowthfactor *(newfuelweight-fuelweight_baseline);
