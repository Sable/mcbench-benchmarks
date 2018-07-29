% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Joerg Kienitz
%           Daniel Wetterau
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 



% Script chap::2::script
% Density Heston Model
%
%   uses the characteristic function of the Heston model
%
t = 10;                             % maturity
a = 600;                            % spot value
N = 512;                            % number of grid points  
x = ( (0:N-1) - N/2 ) / a;          % range

figname = 'Risk Neutral Density - Heston-Hull-White';

vInst_base = 0.02;                  % instantanuous variance of base parameter set  
vLong_base = 0.02;                  % long term variance of base parameter set
kappa_base = 0.1;                   % mean reversion speed of variance of base parameter set
omega_base = 0.2;                   % volatility of variance of base parameter set
rho_base = 0;                       % correlation of base parameter set

lambda_base = 0.1;
eta_base = 0.02;

icurveData = [0.999884333380315;0.996803132736937;0.993568709230647;0.990285301195274;0.986945903402709;0.983557350486521;0.980185549124449;0.976782934344041;0.973361992614499;0.969976793305220;0.966616749933289;0.962914317958160;0.959904777446077;0.920091903961326;0.882870065420196;0.847186544281939;0.812742515687365;0.779459552415061;0.747152463119429;0.715745016074346;0.685138723808460;0.655753392359115;0.627333845297308;0.599226698198774;0.572763319281569;0.547259133751455;0.523441996253080;0.499646068368557;0.477507905873099;0.456481811728753;0.436385788738282;0.417350253831050;0.399187111819286;0.381865611666566;0.365435617455498;0.349786183601181;0.334806921914717;0.320548897004994;0.306983265264429;0.294081800917050;0.282443547729164;0.269929224010243];
icurveDates = [734472;734501;734534;734562;734591;734622;734653;734683;734713;734744;734775;734807;734836;735202;735567;735931;736298;736663;737028;737393;737758;738125;738489;738854;739219;739585;739949;740316;740680;741046;741411;741776;742140;742507;742872;743237;743602;743967;744334;744698;745063;745429];
icurveInterpMethod = 'spline';
icurveType = 'Discount';
icurveSettle = 734471;
irdc = IRDataCurve(icurveType,icurveSettle,icurveDates,icurveData);
% cf (characteristic function) for the heston hull white model
f = @(x) cf_heston(x,vInst_base,vLong_base,kappa_base,omega_base,rho_base,t,0) .* cf_hullwhite(x+1i,t,0,lambda_base,eta_base,irdc);

legendname_base = 'Base parameter set';
y_base = fftdensity(f,a,N);         % density calculated from cf for base parameter set
%% Changing lambda_base
lambda_low = .005;                    % changing parameter (low value)
lambda_high = .5;                   % changing parameter (high value)

f_low = @(x) cf_heston(x,vInst_base,vLong_base,kappa_base,omega_base,rho_base,t,0).* cf_hullwhite(x+1i,t,0,lambda_low,eta_base,irdc);
f_high = @(x)  cf_heston(x,vInst_base,vLong_base,kappa_base,omega_base,rho_base,t,0).* cf_hullwhite(x+1i,t,0,lambda_high,eta_base,irdc);

y_low = fftdensity(f_low,a,N);
y_high = fftdensity(f_high,a,N);

legendname_low = 'Changing \lambda low value';
legendname_high = 'Changing \lambda high value';

% output density as figure
createfigure_density(x,y_base,y_low,y_high,...
    figname, legendname_base,legendname_low,legendname_high);
%% Changing eta_base
eta_low = .01;
eta_high = .03;

f_low =  @(x) cf_heston(x,vInst_base,vLong_base,kappa_base,omega_base,rho_base,t,0).* cf_hullwhite(x+1i,t,0,lambda_base,eta_low,irdc);
f_high =  @(x) cf_heston(x,vInst_base,vLong_base,kappa_base,omega_base,rho_base,t,0).* cf_hullwhite(x+1i,t,0,lambda_base,eta_high,irdc);

y_low = fftdensity(f_low,a,N);
y_high = fftdensity(f_high,a,N);

legendname_low = 'Changing \eta low value';
legendname_high = 'Changing \eta high value';

createfigure_density(x,y_base,y_low,y_high,...
    figname, legendname_base,legendname_low,legendname_high);


%% Changing curve_base
zero = -log(icurveData)./(icurveDates-icurveSettle)*360 - 0.01;
icurveData_low = exp(-zero .*(icurveDates-icurveSettle)/360);
zero = -log(icurveData)./(icurveDates-icurveSettle)*360 + 0.01;
icurveData_high = exp(-zero .*(icurveDates-icurveSettle)/360);

irdc_low = IRDataCurve(icurveType,icurveSettle,icurveDates,icurveData_low);
irdc_high = IRDataCurve(icurveType,icurveSettle,icurveDates,icurveData_high);

f_low =  @(x) cf_heston(x,vInst_base,vLong_base,kappa_base,omega_base,rho_base,t,0).* cf_hullwhite(x+1i,t,0,lambda_base,eta_base,irdc_low);
f_high =  @(x) cf_heston(x,vInst_base,vLong_base,kappa_base,omega_base,rho_base,t,0).* cf_hullwhite(x+1i,t,0,lambda_base,eta_base,irdc_high);

y_low = fftdensity(f_low,a,N);
y_high = fftdensity(f_high,a,N);

legendname_low = 'Changing curve parallel shift - low value';
legendname_high = 'Changing curve parallel shift - high value';

createfigure_density(x,y_base,y_low,y_high,...
    figname, legendname_base,legendname_low,legendname_high);
