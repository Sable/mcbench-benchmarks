function [PrimaryMargin RotorMargin] = PointAnalysisBEA(AC, State)

if isnan(State.range)
    State.Vcond = 'min power';
else
    State.Vcond = 'max SAR';
end

if State.hmin == State.hmax
    hFixed=true;
else hFixed=false;
end
if State.Vmin == State.Vmax
    VFixed = true;
else VFixed=false;
end

State.beta = betafinder(AC,State.AUWfrac,State.PAYfrac,State.FUELfrac);

nr = 25; npsi = 36;
rmin = .1;
rlocs = sinspace(rmin,1,nr,.2);
Rlocs = rlocs.*AC.Rotor.R;
psilocs = linspace(0,2*pi*(1-1/npsi),npsi);
[r,psi] = meshgrid(rlocs,psilocs);

% AC axes:
X = AC.Rotor.R*r.*cos(psi); %positive toward AFT
Y = AC.Rotor.R*r.*sin(psi); %positive to starboard


% decision variables for converging on point conditions:
% collective, A1 cyclic, B1 cyclic
LB = [-.1 -.05 -.4]';
UB = [ .5   .2   .1]';

coll0 = -.5*AC.Rotor.tw;
mu = (4*State.Vmin+State.Vmax)/5/AC.Rotor.TS;
X0 = [coll0 0 -0.3383*mu]';% Initial guesses for collective, A1, B1 based on a WAG curve fit

TypicalX = [.1 .01 .01]';

if any(X0>UB)||any(X0<LB)
    disp('fmincon in BEA using X outside bounds')
end

if ~VFixed
    LB(end+1) = State.Vmin/100;
    UB(end+1) = State.Vmax/100;
    X0(end+1) = (4*LB(4)+UB(4))/5;
    TypicalX(end+1) = .3;
end
if ~hFixed
    LB(end+1) = State.hmin/10000;
    UB(end+1) = State.hmax/10000;
    X0(end+1) = (99*LB(end)+UB(end))/100;
    TypicalX(end+1) = .1;
end

myFun = @(X0) FixedPointAnalysis(X0,AC,State,Rlocs,r,psi,X,Y,VFixed,hFixed,LB,UB,false);
mycons = @(X0) myNonLcons(X0,AC,State,Rlocs,r,psi,X,Y,VFixed,hFixed,LB,UB);

DiffMinChange = 5e-5;
if ~VFixed
    DiffMinChange = 1e-3;
end
if VFixed && hFixed
    MaxFunEvals = 120;
elseif ~VFixed && ~hFixed
    MaxFunEvals = 500;
else
    MaxFunEvals = 450;
end


options = optimset('Display','off', 'Diagnostics','off', 'FunValCheck','on',...
    'MaxFunEvals',MaxFunEvals,'MaxIter',100,'TolX',1e-5,'TolFun',1e-5,...
    'LargeScale','off',...
    'Algorithm','sqp',...
    'TolCon',1e-4,'TypicalX',TypicalX,...
    'DiffMinChange',DiffMinChange);

[decisionXout,fval,exitflag,output] =...
    fmincon(myFun,X0,[],[],[],[],LB,UB,mycons,options);

myFun = @(X0) FixedPointAnalysis(X0,AC,State,Rlocs,r,psi,X,Y,VFixed,hFixed,LB,UB,true);

[~, ExtraOut] = myFun(decisionXout);
RotorMargin = 0;
PrimaryMargin = -fval;

nFunEvals = output.funcCount;
Thrust_capability=ExtraOut.Frotor(3)/ExtraOut.Tmtot;
Thrust_error = abs(Thrust_capability-1);
if any(exitflag == [0 -1 -2]) || (nFunEvals+3>MaxFunEvals) || Thrust_error>.005
    moments_over_TolM=ExtraOut.Frotor(4:5)/ExtraOut.TolM;
    PrimaryMargin = min([PrimaryMargin;-Thrust_error;-moments_over_TolM(:)/5000]);
end

%% Pavail - Preq plotting:
% kts = sinspace(0,185,-18);
% ms = kts*0.514444444;
% for ii = 1:length(ms)
%     tState.V = ms(ii)/100;
%     [ObjectiveValue EO] = ...
%     FixedPointAnalysis(decisionX,AC,tState,Rlocs,r,psi,X,Y,VFixed,hFixed,LB,UB,true)
%     jnk(ii,:) = struct2array(EO);
% end
% names = fieldnames(EO);
% jnk = jnk(:,1:3);
% plot(kts,jnk);
% legend(names{1:3})
% keyboard
end

function [C Ceq] = myNonLcons(decisionX,AC,tState,Rlocs,r,psi,X,Y,VFixed,hFixed,LB,UB)
[~, ExtraOut] = ...
    FixedPointAnalysis(decisionX,AC,tState,Rlocs,r,psi,X,Y,VFixed,hFixed,LB,UB,false);
a = ExtraOut.Frotor(3)/ExtraOut.Tmtot;
b = ExtraOut.CFrotor(4)*1000;
c = ExtraOut.CFrotor(5)*1000;

Ceq = [a-1 b c]';
% C = a-1.00001;
C=[];
end

function [ObjectiveValue ExtraOut] = ...
    FixedPointAnalysis(decisionX,AC,tState,Rlocs,r,psi,X,Y,VFixed,hFixed,LB,UB,clearflag) %#ok<INUSL>
persistent UNIQUEID ExtraOutPers ObjPers
ID_current = decisionX;
if length(UNIQUEID) == length(ID_current) && ...
        all(UNIQUEID == ID_current) && ~isempty(ObjPers)
    ExtraOut = ExtraOutPers;
    ObjectiveValue = ObjPers;
    return
else
    UNIQUEID = ID_current;
end


decisionX(decisionX>UB) = UB(decisionX>UB);
decisionX(decisionX<LB) = LB(decisionX<LB);

ClimbEfficiency = .9; %Assume
CyclicTolerance = .05; %deg

% V always 4th, h always end
if VFixed
    tState.V = tState.Vmin;
else
    tState.V = decisionX(4)*100;
end
V = tState.V;
if hFixed
    tState.h = tState.hmin;
else
    tState.h = decisionX(end)*10000;
end
h = tState.h;

PAblade_elements;

%% climb power
climbpower = ClimbEfficiency * tState.ROC * nW;

extratorq = climbpower/AC.Rotor.Omega;

newTORQ = TORQ+extratorq;

%% tail rotor power required
Ptailrotor = tail_rotor_power(newTORQ,AC,tState);

totalPreq = max(0,newTORQ*AC.Rotor.Omega + Ptailrotor) + tState.AccessPwr; %climb included in newTORQ

totalTreq = Tprop;
[Pavail, ~, ~, ~, totalfuelburn] = ...
    AC.Ass.plapse(AC, tState, totalTreq, totalPreq);

%% create the objective %%
power_margin = 1-totalPreq/Pavail;

total_power_margin = power_margin;

switch tState.Vcond
    case 'max SAR'
        SAR = V/totalfuelburn;
        range = SAR*AC.W.fuel;
        rangemargin = (range-tState.range)/tState.range;
        PrimaryMargin = rangemargin;
    case 'min power' %the default for point performance
        PrimaryMargin = total_power_margin;
end

% Estimate a tolerance on moment;
liftcurveslope = .1; %per deg
Tolq = 1/2*rho*(V+AC.Rotor.TS/3)^2;
TolM = CyclicTolerance*liftcurveslope.*Tolq.*AC.Rotor.BA*AC.Rotor.R/3;

ObjectiveValue = -PrimaryMargin;

rotormargin = FZ/Tmtot-1;

RotorMargin =               rotormargin;
ExtraOut.Pavail =           Pavail;
ExtraOut.Pclimb =           climbpower;
ExtraOut.totalPreq=         totalPreq;
ExtraOut.fuelburn =         totalfuelburn;
ExtraOut.vi =               vi;
ExtraOut.rotortilt =        rotortilt;
ExtraOut.Fbody =            Fb;
ExtraOut.Frotor =           Frotor;
ExtraOut.CFrotor =          CFrotor;
ExtraOut.CTmtot =           CTmtot;
ExtraOut.V =                V;
ExtraOut.h =                h;
ExtraOut.message =          [];
ExtraOut.TolM=              TolM;
ExtraOut.Tmtot=             Tmtot;
ExtraOut.PrimaryMargin=     PrimaryMargin;
ExtraOut.RotorMargin =      RotorMargin;
ExtraOut.coll =             theta_coll;
ExtraOut.cyc =              [A1 B1];
ExtraOut.alpha =            BladeState.alpha;
ExtraOut.Xb =               X;
ExtraOut.Yb =               Y;
ExtraOutPers = ExtraOut;
ObjPers = ObjectiveValue;
if clearflag
    clear UNIQUEID ExtraOutPers ObjPers
end
end

