function [] = FinalOutput(CL, CDi, CD0, y_cp, geo, WingVolume, airfoildata, output)
% calculate score and other outputs, post to the GUI

q = 1/2*geo.density*geo.V^2;


%Determine the stall angles of attack for root and tip airfoils
alpha_r = (geo.i_r + geo.alpha)*180/pi;
chord_r = geo.c_r;
thick_r = str2num(geo.root(end-1:end));  %Determine thickness of root airfoil
Re_r = geo.V*geo.density*chord_r/geo.visc;
k = cell2mat(airfoildata{5}(geo.rootindex));
alpha_stall_r = k(1) + k(2)*log10(Re_r) + k(3)*log10(Re_r)^2;

alpha_t = (geo.i_r + geo.twist + geo.alpha)*180/pi;
chord_t = geo.c_r*geo.taper;
thick_t = str2num(geo.tip(end-1:end));  %#ok<ST2NM> %Determine thickness of tip airfoil
Re_t = geo.V*geo.density*chord_t/geo.visc;
k = cell2mat(airfoildata{5}(geo.tipindex));
alpha_stall_t = k(1) + k(2)*log10(Re_t) + k(3)*log10(Re_t)^2;

eta = (2*(1:geo.ns)-1)/(2*geo.ns);
chord = chord_r + eta*(chord_t-chord_r);
alpha = alpha_r + eta*(alpha_t-alpha_r);
alpha_stall = alpha_stall_r + eta*(alpha_stall_t-alpha_stall_r);
thick = thick_r + eta*(thick_t-thick_r);

counter = 0;    %Tracks the number of panels that are stalled
percentstalled = 0; %Tracks percentage of wing that is stalled
averagechord = 0; %Tracks average chord of stalled wing
averagealphapaststall = 0; %Tracks the average number of degrees past stall
averagethickness = 0; %Tracks the average thickness of the airfoil sections past stall
averagestallalpha = 0; %Tracks the average stall angle
for i = 1:geo.ns
    if alpha(i) > alpha_stall(i)
        counter = counter + 1;
        percentstalled = percentstalled + 1;
        averagechord = averagechord + chord(i);
        averagealphapaststall = averagealphapaststall + (alpha(i) - alpha_stall(i));
        averagethickness = averagethickness + thick(i);
        averagestallalpha = averagestallalpha + alpha_stall(i);
    end
end

if counter ~= 0 %Some part of the wing is stalled; prevents divide by zero
    percentstalled = percentstalled/geo.ns;
    averagechord = averagechord/counter;
    averagealphapaststall = averagealphapaststall/counter*pi/180;  %Convert to radians because stall model was developed in radians
    averagethickness = averagethickness/counter;
    averagestallalpha = averagestallalpha/counter;
end
%Determine lift while accounting for lift after the stall angle of attack
c = averagethickness/12;   %Thickness coefficient
d = 100*c;  %Determined by trial and error to closely model the shape and behavior of the lift curve
k = 400*c;
CL_stall = sum(CL.c+CL.alpha*averagestallalpha*pi/180);  %Average max lift coefficient
%The following equation is the result of modeling the lift
%coefficient of the airfoil after the stall angle of attack as a
%2nd order ODE with initial position of CL_stall and initial
%velocity of CL_alpha.  See Stall Model.nb for Mathematica
%derivation
if percentstalled == 0
    stallcorrection = 1;
else
    stallcorrection = exp(0.5*(-d-sqrt(d^2-4*k))*(averagealphapaststall))*(-2*CL.alpha-CL_stall*d+CL_stall*sqrt(d^2-4*k))/(2*sqrt(d^2-4*k))...
        +exp(0.5*(-d+sqrt(d^2-4*k))*(averagealphapaststall))*(2*CL.alpha+CL_stall*d+CL_stall*sqrt(d^2-4*k))/(2*sqrt(d^2-4*k));
end

CL = ((1-percentstalled)*(CL.c+CL.alpha*geo.alpha)+percentstalled*stallcorrection);

L = CL*q*geo.S;

Dind = CDi*q*geo.S;

%CD0 is profile drag of wing, S_Sref*Cfe is the zero-lift drag of the
%fuselage from section 2.9.1 of Anderson, Aircraft Performance and Design
%The sum of these two terms represents the total skin friction drag on the
%wing body or the zero-lift drag 
Dprofile = (CD0 + geo.S_Sref*geo.cf)*q*geo.S;  

Dtotal = Dind + Dprofile;  %Newton

BendMoment = -(y_cp.c+y_cp.alpha*geo.alpha)*L;

%Determine useful payload
Fuel_weight = geo.wingfuel*geo.fueldens*WingVolume*9.81;   %Fuel weight in N
Payload = L - geo.emptyweight - Fuel_weight;    %Useful payload in N

%Range equations from Aircraft Performance and Design
switch geo.engine
    case 'prop'
        Range = geo.propefficiency/geo.propSFC*L/Dtotal*log((geo.emptyweight+Fuel_weight)/geo.emptyweight);  %25% usable volume
        SFC = geo.propSFC;
    case 'jet'
        CD = CD0 + CDi;
        Range = 2/geo.jetTSFC*sqrt(2/(geo.S*geo.density)*CL/CD^2)*(sqrt(geo.emptyweight+Fuel_weight)-sqrt(geo.emptyweight));
        SFC = geo.jetTSFC;
    otherwise
        Range = 0;
        SFC = 0;
end

%Score function
Baseline_payload = 45000; %C130 maximum payload, Wikipedia
Cost_payload = 10000/400; %An extra 10000 lbf of lift is worth 1000 miles
Baseline_moment = 422000; %C130 moment from Wing Designer using C130 geometry
Cost_moment = 400000/10000; %Doubling the baseline moment incurs a penalty of 10000 miles
Baseline_airspeed = 292; %292 knots (C130 cruise), Wikipedia
Cost_airspeed = 10/100; %An extra 10 knots of cruising speed is worth 100 miles
Baseline_span = 132/3.28; %C130 wing span, Wikipedia
Cost_span = 20/3.28/2000; %An extra 20 feet incurs a penalty of 1200 miles
Score = Range/1609 + (Payload*0.22481-Baseline_payload)/Cost_payload - (BendMoment - Baseline_moment)/Cost_moment + ...
    (geo.V/0.5144 - Baseline_airspeed)/Cost_airspeed - (geo.b - Baseline_span)/Cost_span; %Convert range to miles; lift to lbf; airspeed to knots
	
	%Set output
set(output.bendmoment,'String',num2str(round(BendMoment)));
set(output.totaldrag,'String',num2str(round(Dtotal*0.22481*10)/10));%Convert to lbf
set(output.inddrag,'String',num2str(round(Dind*0.22481*10)/10));%Convert to lbf
set(output.profdrag,'String',num2str(round(Dprofile*0.22481*10)/10));%Convert to lbf
set(output.range,'String',num2str(round(Range/1609*10)/10));%Convert m to miles
set(output.volume,'String',num2str(round(WingVolume*35.315*100)/100));%Convert to ft^3
set(output.calctime,'String',num2str(etime(clock,geo.t0)));
set(output.lift,'String',num2str(round(L*0.22481)));  %Convert to lbf
set(output.fuelweight,'String',num2str(round(Fuel_weight*0.22481)));  %Convert to lbf
set(output.payload,'String',num2str(round(Payload*0.22481)));  %Convert to lbf

%Conditional formatting; if payload < requirements, font -> red, score -> 0
if (Payload*0.22481 < 45000) ||  (Range/1609 < 2360) %Baseline payload and range of C130, Wikipedia
    set(output.SCORE,'String','0');
else
    set(output.SCORE,'String',num2str(round(Score*10)/10));
end

if Payload*0.22481 < 45000
    set(output.payload,'ForegroundColor','red')
else
    set(output.payload,'ForegroundColor','black')
end

if Range/1609 < 2360
    set(output.range,'ForegroundColor','red')
else
    set(output.range,'ForegroundColor','black')
end
