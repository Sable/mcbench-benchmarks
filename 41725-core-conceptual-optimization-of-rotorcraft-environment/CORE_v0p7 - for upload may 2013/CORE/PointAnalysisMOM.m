function [PrimaryMargin] = ...
    PointAnalysisMOM(AC, State)%,nr,npsi)

if isnan(State.range)
    State.Vcond = 'min power';
else
    State.Vcond = 'max SAR';
end

if State.hmin == State.hmax
    hFixed=true;
    fixedh = State.hmin;
else hFixed=false;
end
if State.Vmin == State.Vmax
    VFixed = true;
    fixedV = State.Vmin;
else VFixed=false;
end

State.beta = betafinder(AC,State.AUWfrac,State.PAYfrac,State.FUELfrac);

LB = []; UB = []; X0 = []; TypicalX = [];
doanalysis = true;
if VFixed && hFixed
    PrimaryMargin = -FixedPointAnalysis([fixedh/10000,fixedV/100],AC,State);
    doanalysis = false;
elseif ~VFixed && ~hFixed
    myFun = @(hVX) FixedPointAnalysis(hVX,AC,State);
    LB = [State.hmin/10000;State.Vmin/100];
    UB = [State.hmax/10000;State.Vmax/100];
    X0 = [(999*LB(1)+UB(1))/1000;(9*LB(2)+UB(2))/10];
    TypicalX = [.1;.3];
elseif VFixed %vary h
    myFun = @(hX) FixedPointAnalysis([hX,fixedV/100],AC,State);
    LB = State.hmin/10000;
    UB = State.hmax/10000;
    X0 = (999*LB+UB)/1000;
    TypicalX = .1;
elseif hFixed %vary V
    myFun = @(VX) FixedPointAnalysis([fixedh/10000,VX],AC,State);
    LB = State.Vmin/100;
    UB = State.Vmax/100;
    X0 = (9*LB+UB)/10;
    TypicalX = .1;
end
if doanalysis
    options = optimset('Display','off', 'Diagnostics','off', 'FunValCheck','on',...
        'MaxFunEvals',120,'MaxIter',100,'TolX',1e-5,'TolFun',1e-5,...
        'LargeScale','off',...
        'Algorithm','sqp',...
        'TolCon',1e-4,'TypicalX',TypicalX,...
        'DiffMinChange',5e-5);
    
    [~,fval] =...
        fmincon(myFun,X0,[],[],[],[],LB,UB,[],options);
    PrimaryMargin = -fval;
    
end
%% Pavail - Preq plotting:
% kts = 0:185;
% ms = kts*0.514444444;
% for ii = 1:length(ms)
%     tState.V = ms(ii)/100;
%     [~,EO] = FixedPointAnalysis([State.hmin/10000,ms(ii)/100],AC,State);
%     jnk(ii,:) = struct2array(EO);
% end
% names = fieldnames(EO);
% jnk = jnk(:,2:end-3);
% plot(kts,jnk);
% legend(names{2:end-3})
% keyboard
end

function [ObjectiveValue,EO] = ...
    FixedPointAnalysis(hV,AC,tState)

h = hV(1)*10000;
V = hV(2)*100;
tState.V = V;

profile_cd = .008;
ClimbEfficiency = .9; %Assume
Kind = 1.00;
max_tip_M = .92;

tState.mu = V/AC.Rotor.TS; 
[tState.rho,tState.a,tState.temp,tState.pres,tState.nu]=stdatmo(h,tState.dT);
tState.M = V/tState.a;
rho = tState.rho;
q = 1/2*rho.*V.^2;

n = loadfactor(tState);

W = tState.beta*AC.W.W;
nW = n*W;

% ground effect
viratio = IGEvi(tState.IGEzD);
DWqratio = viratio.^2;

[CDfuse,DLfactor] = fusepolar_arealoading(AC,tState);

Kfuse = DWqratio*(1-1/(1+DLfactor));

Tmv = (nW)/(1-Kfuse);
EO.Tmv = Tmv;

%% Drag
Dfuse = CDfuse.*q;
POWER_parasite = Dfuse * V;
EO.POWER_parasite = POWER_parasite;

%% induced velocity
POWER_induced = Kind*Tmv .* sqrt(-(V.^2)/2+sqrt(((V.^2)/2).^2+...
    (Tmv./(2.*rho.*AC.Rotor.DA)).^2));
EO.POWER_induced = POWER_induced;

% Profile power
POWER_profile = rho*AC.Rotor.BA*(AC.Rotor.TS^3)*profile_cd *(1+3*V/AC.Rotor.TS)/8;
EO.POWER_profile = POWER_profile;

%% climb power
POWER_climb = ClimbEfficiency * tState.ROC * nW;
EO.POWER_climb = POWER_climb;

%% MR power
POWER_MR = POWER_climb + POWER_induced + POWER_parasite + POWER_profile;
EO.POWER_MR = POWER_MR;

MRTorq = POWER_MR/AC.Rotor.Omega;

%% tail rotor power required
POWER_TR = tail_rotor_power(MRTorq,AC,tState);
EO.POWER_TR = POWER_TR;

totalPreq = POWER_MR + POWER_TR + tState.AccessPwr;
EO.totalPreq = totalPreq;
EO.AccessPwr = tState.AccessPwr;

[Pavail, ~, ~, ~, totalfuelburn] = ...
    AC.Ass.plapse(AC, tState, 0, totalPreq);
EO.Pavail = Pavail;

power_margin = (Pavail-totalPreq)/Pavail;

total_power_margin = power_margin;
EO.power_margin = power_margin;

switch tState.Vcond
    case 'max SAR'
        SAR = V/totalfuelburn;
        range = SAR*AC.W.fuel;
        rangemargin = (range-tState.range)/tState.range;
        PrimaryMargin = rangemargin;
    case 'min power' %should be the default for point performance
        PrimaryMargin = total_power_margin;
end

% tip mach number margin
tip_M = (V+AC.Rotor.TS)/tState.a;
M_margin = (max_tip_M-tip_M)/max_tip_M;
EO.M_margin = M_margin;

%stall margin
nondimensionalizer = rho*AC.Rotor.DA*AC.Rotor.TS.^2;
CTmv = Tmv/nondimensionalizer;
Stall_margin = retreating_stall_envelope(tState.mu,CTmv/AC.Rotor.sigma);
EO.Stall_margin = Stall_margin;

leastmargin = min([total_power_margin,PrimaryMargin,M_margin,Stall_margin]);
ObjectiveValue = -leastmargin;
end

